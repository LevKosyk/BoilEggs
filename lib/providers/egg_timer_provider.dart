import 'package:flutter/material.dart';
import 'dart:async';
import 'package:boil_eggs/services/notification_service.dart'; // Import NotificationService

enum EggDoneness {
  soft(label: 'Soft', minutes: 6, description: 'Runny yolk, firm white'),
  medium(label: 'Medium', minutes: 8, description: 'Jammy yolk, firm white'),
  hard(label: 'Hard', minutes: 12, description: 'Fully cooked yolk');

  final String label;
  final int minutes;
  final String description;

  const EggDoneness({
    required this.label,
    required this.minutes,
    required this.description,
  });
}

enum TimerStatus { idle, boiling, paused, done }

class EggTimerProvider with ChangeNotifier {
  EggDoneness? _selectedDoneness;
  TimerStatus _status = TimerStatus.idle;
  int _remainingSeconds = 0;
  Timer? _timer;

  EggDoneness? get selectedDoneness => _selectedDoneness;
  TimerStatus get status => _status;
  int get remainingSeconds => _remainingSeconds;
  
  double get progress {
    if (_selectedDoneness == null) return 0.0;
    final totalSeconds = _selectedDoneness!.minutes * 60;
    return 1.0 - (_remainingSeconds / totalSeconds);
  }

  void selectDoneness(EggDoneness doneness) {
    _selectedDoneness = doneness;
    _remainingSeconds = doneness.minutes * 60;
    _status = TimerStatus.idle;
    notifyListeners();
  }

  void startTimer() {
    if (_status == TimerStatus.boiling) return;
    
    _status = TimerStatus.boiling;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _status = TimerStatus.done;
        NotificationService().showNotification(
          id: 0,
          title: 'Egg Ready!',
          body: 'Your egg is boiled to perfection.',
        );
        notifyListeners();
      }
    });
  }

  void upgradeDoneness(EggDoneness newDoneness) {
    if (_selectedDoneness == null) return;
    if (newDoneness.minutes <= _selectedDoneness!.minutes) return;

    final diffMinutes = newDoneness.minutes - _selectedDoneness!.minutes;
    _remainingSeconds += diffMinutes * 60;
    _selectedDoneness = newDoneness;
    
    // Resume timer if it was done or just update if running
    if (_status == TimerStatus.done || _status == TimerStatus.idle) {
        startTimer();
    } 
    // If paused, we just extended time, user can resume manually or auto? 
    // Let's auto-resume for better UX "Go Harder" -> Starts boiling.
    else if (_status == TimerStatus.paused) {
        startTimer();
    }
    
    notifyListeners();
  }

  void pauseTimer() {
    if (_status == TimerStatus.boiling) {
      _timer?.cancel();
      _status = TimerStatus.paused;
      notifyListeners();
    }
  }

  void cancelTimer() {
    _timer?.cancel();
    _status = TimerStatus.idle;
    if (_selectedDoneness != null) {
      _remainingSeconds = _selectedDoneness!.minutes * 60;
    }
    notifyListeners();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
