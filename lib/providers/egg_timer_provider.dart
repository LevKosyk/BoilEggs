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
  fridge(label: 'Fridge', adjustmentSeconds: 0),  
  room(label: 'Room Temp', adjustmentSeconds: -60);  
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
  int _totalSeconds = 0;  
  Timer? _timer;
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
    if (_totalSeconds < 60) _totalSeconds = 60;
    if (_status == TimerStatus.idle) {
      _remainingSeconds = _totalSeconds;
    }
    notifyListeners();
  }
  int calculateDuration(EggDoneness doneness) {
    int base = doneness.baseMinutes * 60;
    int size = _selectedSize.adjustmentSeconds;
    int temp = _selectedTemp.adjustmentSeconds;
    int total = base + size + temp;
    return total < 60 ? 60 : total;
  }
  Future<void> _syncWidget() async {
    const groupId = 'group.com.example.boilEggs';
    try {
      await HomeWidget.setAppGroupId(groupId);
    } catch (e) {
      debugPrint("Error setting App Group ID: $e");
    }
    await HomeWidget.saveWidgetData<String>('status', _status.name);
    await HomeWidget.saveWidgetData<String>('doneness', _selectedDoneness?.label ?? '--');
    int endTimestamp = 0;
    if (_status == TimerStatus.boiling) {
       endTimestamp = DateTime.now().add(Duration(seconds: _remainingSeconds)).millisecondsSinceEpoch;
    }
    await HomeWidget.saveWidgetData<int>('end_timestamp', endTimestamp);
    await HomeWidget.saveWidgetData<int>('total_seconds', _totalSeconds);
    await HomeWidget.saveWidgetData<int>('remaining_seconds', _remainingSeconds);
    await HomeWidget.updateWidget(
      name: 'BoilEggsWidget',  
      iOSName: 'BoilEggsWidget',  
    );
  }
  void startTimer() {
    if (_status == TimerStatus.boiling) return;
    if (_status == TimerStatus.idle && _remainingSeconds == 0) {
        _recalculateTime();
    }
    if (_remainingSeconds <= 0) {
      _recalculateTime();
      if (_remainingSeconds <= 0) {
         _remainingSeconds = 60;  
      }
    }
    _status = TimerStatus.boiling;
    _syncWidget();  
    notifyListeners();
    final now = DateTime.now();
    final targetTime = now.add(Duration(seconds: _remainingSeconds));
    if (_soundEnabled) {
      NotificationService().scheduleNotification(
        id: 0,
        title: 'Egg Ready!',
        body: 'Your egg is boiled perfectly!',
        scheduledDate: targetTime,
      );
    }
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
    _syncWidget();  
    HistoryService().recordBoil();  
    notifyListeners();
  }
  void upgradeDoneness(EggDoneness newDoneness) {
    if (_selectedDoneness == null) return;
    int oldBase = _selectedDoneness!.baseMinutes;
    int newBase = newDoneness.baseMinutes;
    if (newBase <= oldBase) return;
    int diffSeconds = (newBase - oldBase) * 60;
    _remainingSeconds += diffSeconds;
    _totalSeconds += diffSeconds;  
    _selectedDoneness = newDoneness;
    int sizeAdj = _selectedSize.adjustmentSeconds;
    int tempAdj = _selectedTemp.adjustmentSeconds;
    int newTotal = (newBase * 60) + sizeAdj + tempAdj;
    _totalSeconds = newTotal;
    if (_status == TimerStatus.done || _status == TimerStatus.idle) {
        startTimer();
    } else if (_status == TimerStatus.paused) {
        startTimer();
    }
    _syncWidget();  
    notifyListeners();
  }
  void pauseTimer() {
    if (_status == TimerStatus.boiling) {
      _timer?.cancel();
      NotificationService().cancel(0);  
      _status = TimerStatus.paused;
      _syncWidget();  
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
    _syncWidget();  
    notifyListeners();
  }
  void cancelTimer() {
    _timer?.cancel();
    NotificationService().cancel(0);  
    reset();  
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
