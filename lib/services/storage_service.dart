import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit.dart';

class StorageService {
  static const String habitsKey = 'habits';

  static Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();

    final data = habits
        .map((habit) => habit.toStorageString())
        .toList();

    await prefs.setStringList(habitsKey, data);
  }

  static Future<List<Habit>> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getStringList(habitsKey) ?? [];

    return data
        .map((item) => Habit.fromStorageString(item))
        .toList();
  }
}