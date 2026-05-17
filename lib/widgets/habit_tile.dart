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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),

      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        color: habit.completed
            ? Colors.green.withOpacity(0.15)
            : Theme.of(context).cardColor,
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),

        leading: Checkbox(
          value: habit.completed,
          onChanged: onChanged,
        ),

        title: Text(
          habit.name,

          style: TextStyle(
            fontSize: 18,

            fontWeight: FontWeight.w600,

            decoration: habit.completed
                ? TextDecoration.lineThrough
                : null,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),

          child: Text(
            '🔥 Streak: ${habit.streak}',
            style: const TextStyle(fontSize: 15),
          ),
        ),

        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}