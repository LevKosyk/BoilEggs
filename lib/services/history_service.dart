import 'package:shared_preferences/shared_preferences.dart';
class HistoryService {
  static const String _keyHistory = 'egg_history';
  static final HistoryService _instance = HistoryService._internal();
  factory HistoryService() => _instance;
  HistoryService._internal();
  Future<void> recordBoil() async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();
    final now = DateTime.now();
    history.add(now.toIso8601String());
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    history.removeWhere((dateStr) {
      final date = DateTime.tryParse(dateStr);
      return date == null || date.isBefore(thirtyDaysAgo);
    });
    await prefs.setStringList(_keyHistory, history);
  }
  Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyHistory) ?? [];
  }
  Future<int> getBoilsToday() async {
    final history = await getHistory();
    final now = DateTime.now();
    final todayStr = _dateToString(now);
    return history.where((dateStr) {
      final date = DateTime.tryParse(dateStr);
      return date != null && _dateToString(date) == todayStr;
    }).length;
  }
  Future<int> getBoilsThisWeek() async {
    final history = await getHistory();
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    return history.where((dateStr) {
      final date = DateTime.tryParse(dateStr);
      return date != null && date.isAfter(sevenDaysAgo);
    }).length;
  }
  String _dateToString(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }
}
