import 'package:flutter/material.dart';

import '../models/habit.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback onDelete;
  final Function(bool?) onChanged;

  const HabitTile({
    super.key,
    required this.habit,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: ListTile(
        leading: Checkbox(
          value: habit.completed,
          onChanged: onChanged,
        ),

        title: Text(
          habit.name,
          style: TextStyle(
            decoration: habit.completed
                ? TextDecoration.lineThrough
                : null,
          ),
        ),

        subtitle: Text(
          '🔥 Streak: ${habit.streak}',
        ),

        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}