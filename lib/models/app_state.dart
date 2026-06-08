import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'food.dart';

class AppState extends ChangeNotifier {
  List<LogEntry> _log = [];
  int _calorieGoal = 2000;
  double _waterMl = 0;
  final double _waterGoal = 2500;

  List<LogEntry> get log => _log;
  int get calorieGoal => _calorieGoal;
  double get waterMl => _waterMl;
  double get waterGoal => _waterGoal;

  int get totalCalories => _log.fold(0, (s, e) => s + e.calories.toInt());
  double get totalProtein => double.parse(_log.fold(0.0, (s, e) => s + e.protein).toStringAsFixed(1));
  double get totalCarbs => double.parse(_log.fold(0.0, (s, e) => s + e.carbs).toStringAsFixed(1));
  double get totalFat => double.parse(_log.fold(0.0, (s, e) => s + e.fat).toStringAsFixed(1));
  int get remainingCalories => _calorieGoal - totalCalories;

  Map<String, List<LogEntry>> get groupedByMeal {
    final Map<String, List<LogEntry>> grouped = {};
    for (final e in _log) {
      grouped.putIfAbsent(e.meal, () => []).add(e);
    }
    return grouped;
  }

  AppState() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayKey();
    final raw = prefs.getStringList('log_$today') ?? [];
    _log = raw.map((s) => LogEntry.fromJson(jsonDecode(s))).toList();
    _calorieGoal = prefs.getInt('goal') ?? 2000;
    _waterMl = prefs.getDouble('water_$today') ?? 0;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayKey();
    final raw = _log.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('log_$today', raw);
    await prefs.setDouble('water_$today', _waterMl);
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  void addEntry(LogEntry entry) {
    _log.add(entry);
    _save();
    notifyListeners();
  }

  void removeEntry(String id) {
    _log.removeWhere((e) => e.id == id);
    _save();
    notifyListeners();
  }

  void setGoal(int goal) async {
    _calorieGoal = goal;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('goal', goal);
    notifyListeners();
  }

  void addWater(double ml) {
    _waterMl = (_waterMl + ml).clamp(0, _waterGoal + 500);
    _save();
    notifyListeners();
  }

  String getMealSlot() {
    final h = DateTime.now().hour;
    if (h < 10) return 'Breakfast';
    if (h < 13) return 'Morning Snack';
    if (h < 15) return 'Lunch';
    if (h < 18) return 'Evening Snack';
    return 'Dinner';
  }
}
