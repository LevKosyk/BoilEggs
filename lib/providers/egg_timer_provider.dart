import 'package:flutter/material.dart';
import 'dart:async';
import 'package:boil_eggs/services/notification_service.dart';
import 'package:boil_eggs/services/history_service.dart';

enum EggDoneness {
  soft(label: 'Soft', baseMinutes: 6, description: 'Runny yolk, firm white'),
  medium(label: 'Medium', baseMinutes: 8, description: 'Jammy yolk, firm white'),
  hard(label: 'Hard', baseMinutes: 12, description: 'Fully cooked yolk');

  final String label;
  final int baseMinutes;
  final String description;

  const EggDoneness({
    required this.label,
    required this.baseMinutes,
    required this.description,
  });
}

enum EggSize {
  small(label: 'Small', adjustmentSeconds: -30),
  medium(label: 'Medium', adjustmentSeconds: 0),
  large(label: 'Large', adjustmentSeconds: 30);

  final String label;
  final int adjustmentSeconds;

  const EggSize({
    required this.label,
    required this.adjustmentSeconds,
  });
}

enum EggTemp {
  fridge(label: 'Fridge', adjustmentSeconds: 0), // Base time assumes fridge
  room(label: 'Room Temp', adjustmentSeconds: -60); // Cooks faster

  final String label;
  final int adjustmentSeconds;

  const EggTemp({
    required this.label,
    required this.adjustmentSeconds,
  });
}

enum TimerStatus { idle, boiling, paused, done }

class EggTimerProvider with ChangeNotifier {
  EggDoneness? _selectedDoneness;
  EggSize _selectedSize = EggSize.medium;
  EggTemp _selectedTemp = EggTemp.fridge;
  
  TimerStatus _status = TimerStatus.idle;
  int _remainingSeconds = 0;
  int _totalSeconds = 0; // To track progress accurately
  Timer? _timer;

  // Getters
  EggDoneness? get selectedDoneness => _selectedDoneness;
  EggSize get selectedSize => _selectedSize;
  EggTemp get selectedTemp => _selectedTemp;
  TimerStatus get status => _status;
  int get remainingSeconds => _remainingSeconds;
  
  double get progress {
    if (_totalSeconds == 0) return 0.0;
    return 1.0 - (_remainingSeconds / _totalSeconds);
  }

  // Setters
  void setSize(EggSize size) {
    _selectedSize = size;
    _recalculateTime();
  }

  void setTemp(EggTemp temp) {
    _selectedTemp = temp;
    _recalculateTime();
  }

  void selectDoneness(EggDoneness doneness) {
    _selectedDoneness = doneness;
    _recalculateTime();
  }

  void _recalculateTime() {
    if (_selectedDoneness == null) return;
    
    int baseSeconds = _selectedDoneness!.baseMinutes * 60;
    int sizeAdj = _selectedSize.adjustmentSeconds;
    int tempAdj = _selectedTemp.adjustmentSeconds;
    
    _totalSeconds = baseSeconds + sizeAdj + tempAdj;
    
    // Safety check: minimum 1 minute
    if (_totalSeconds < 60) _totalSeconds = 60;

    if (_status == TimerStatus.idle) {
      _remainingSeconds = _totalSeconds;
    }
    notifyListeners();
  }

  void startTimer() {
    if (_status == TimerStatus.boiling) return;
    
    // If starting from idle, ensure time is set
    if (_status == TimerStatus.idle && _remainingSeconds == 0) {
        _recalculateTime();
    }
    
    _status = TimerStatus.boiling;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _finishTimer();
      }
    });
  }

  void _finishTimer() {
    _status = TimerStatus.done;
    NotificationService().showNotification(
      id: 0,
      title: 'Egg Ready!',
      body: 'Your egg is boiled perfectly!',
    );
    HistoryService().recordBoil(); // Save only on success
    notifyListeners();
  }

  void upgradeDoneness(EggDoneness newDoneness) {
    if (_selectedDoneness == null) return;
    
    // Calculate difference in base minutes
    int oldBase = _selectedDoneness!.baseMinutes;
    int newBase = newDoneness.baseMinutes;
    
    if (newBase <= oldBase) return;

    int diffSeconds = (newBase - oldBase) * 60;
    
    _remainingSeconds += diffSeconds;
    _totalSeconds += diffSeconds; // Extend total duration too for progress bar consistency? 
    // Actually, progress bar usually represents "Current Goal". 
    // If we upgrade, the "Total" for the new goal is (NewBase + Adjs).
    // Let's reset Total to the NEW goal's total time.
    
    _selectedDoneness = newDoneness;
    
    // Recalculate what the TOTAL time would have been for this new setting
    int sizeAdj = _selectedSize.adjustmentSeconds;
    int tempAdj = _selectedTemp.adjustmentSeconds;
    int newTotal = (newBase * 60) + sizeAdj + tempAdj;
    
    // Update total seconds so progress bar doesn't jump weirdly
    // Progress = 1 - (remaining / total). 
    // If we just added time to remaining, and increased total, it should look "less done".
    _totalSeconds = newTotal;
    
    // Resume or auto-start
    if (_status == TimerStatus.done || _status == TimerStatus.idle) {
        startTimer();
    } else if (_status == TimerStatus.paused) {
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
    _recalculateTime(); // Reset to initial calculated time
    notifyListeners();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
