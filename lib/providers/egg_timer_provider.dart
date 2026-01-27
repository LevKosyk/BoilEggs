import 'package:flutter/material.dart';
import 'dart:async';
import 'package:boil_eggs/services/notification_service.dart';
import 'package:boil_eggs/services/history_service.dart';
import 'package:home_widget/home_widget.dart';

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
  small(label: 'Small', adjustmentSeconds: -45),
  medium(label: 'Medium', adjustmentSeconds: 0),
  large(label: 'Large', adjustmentSeconds: 45);

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
  
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

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
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  
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

  // Helper to calculate duration for UI preview without selecting
  int calculateDuration(EggDoneness doneness) {
    int base = doneness.baseMinutes * 60;
    int size = _selectedSize.adjustmentSeconds;
    int temp = _selectedTemp.adjustmentSeconds;
    int total = base + size + temp;
    return total < 60 ? 60 : total;
  }

  Future<void> _syncWidget() async {
    const groupId = 'group.com.example.boilEggs';
    
    // Set the App Group ID for iOS
    try {
      await HomeWidget.setAppGroupId(groupId);
    } catch (e) {
      debugPrint("Error setting App Group ID: $e");
    }

    await HomeWidget.saveWidgetData<String>('status', _status.name);
    await HomeWidget.saveWidgetData<String>('doneness', _selectedDoneness?.label ?? '--');
    
    // Calculate end timestamp (millis since epoch) for native countdowns
    int endTimestamp = 0;
    if (_status == TimerStatus.boiling) {
       endTimestamp = DateTime.now().add(Duration(seconds: _remainingSeconds)).millisecondsSinceEpoch;
    }
    await HomeWidget.saveWidgetData<int>('end_timestamp', endTimestamp);
    await HomeWidget.saveWidgetData<int>('total_seconds', _totalSeconds);
    await HomeWidget.saveWidgetData<int>('remaining_seconds', _remainingSeconds);

    await HomeWidget.updateWidget(
      name: 'BoilEggsWidget', // Android
      iOSName: 'BoilEggsWidget', // iOS
    );
  }

  void startTimer() {
    if (_status == TimerStatus.boiling) return;
    
    // If starting from idle, ensure time is set
    if (_status == TimerStatus.idle && _remainingSeconds == 0) {
        _recalculateTime();
    }
    
    // Guard against 0 or negative seconds to prevent crash
    if (_remainingSeconds <= 0) {
      // If still 0, force recalculate or default (though recalculate should handle it)
      _recalculateTime();
      if (_remainingSeconds <= 0) {
         _remainingSeconds = 60; // Fallback safety
      }
    }
    
    _status = TimerStatus.boiling;
    _syncWidget(); // Update widget state
    notifyListeners();

    // Calculate target completion time
    final now = DateTime.now();
    final targetTime = now.add(Duration(seconds: _remainingSeconds));
    
    // Schedule background notification only if sound is enabled
    if (_soundEnabled) {
      NotificationService().scheduleNotification(
        id: 0,
        title: 'Egg Ready!',
        body: 'Your egg is boiled perfectly!',
        scheduledDate: targetTime,
      );
    }

    // Run timer for UI updates
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
    _syncWidget(); // Update widget state to done
    
    // Notification is handled by schedule, but show one now if app is open just in case
    // Actually scheduling handles it. We can validly show a foreground dialog or just let it be.
    // If we rely on scheduling, we don't need to manually show() if we are in foreground, 
    // BUT flutter_local_notifications handling of foreground varies by settings.
    // For safety, we can leave the scheduling to fire.
    
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
    
    _syncWidget(); // Update widget state logic
    notifyListeners();
  }

  void pauseTimer() {
    if (_status == TimerStatus.boiling) {
      _timer?.cancel();
      NotificationService().cancel(0); // Cancel scheduled notification
      _status = TimerStatus.paused;
      _syncWidget(); // Update widget state
      notifyListeners();
    }
  }

  void setSound(bool enabled) {
    _soundEnabled = enabled;
    notifyListeners();
  }

  void setVibration(bool enabled) {
    _vibrationEnabled = enabled;
    notifyListeners();
  }

  void reset() {
    _status = TimerStatus.idle;
    _recalculateTime();
    _syncWidget(); // Update widget state
    notifyListeners();
  }

  void cancelTimer() {
    _timer?.cancel();
    NotificationService().cancel(0); // Cancel scheduled notification
    reset(); // Reuse reset logic
    // Reset handles sync
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
