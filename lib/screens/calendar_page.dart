import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/habit.dart';

class CalendarPage extends StatelessWidget {
  final Habit habit;

  const CalendarPage({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    final completedDates = habit.completedDays
        .map((date) => DateTime.parse(date))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),

        child: TableCalendar(
          focusedDay: DateTime.now(),

          firstDay: DateTime(2020),
          lastDay: DateTime(2035),

          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.green.shade400,
              shape: BoxShape.circle,
            ),

            selectedDecoration: BoxDecoration(
              color: Colors.green.shade700,
              shape: BoxShape.circle,
            ),
          ),

          selectedDayPredicate: (day) {
            return completedDates.any(
              (date) =>
                  isSameDay(date, day),
            );
          },
        ),
      ),
    );
  }
}