import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../services/storage_service.dart';
import '../widgets/habit_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Habit> habits = [];

  final TextEditingController controller =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  Future<void> loadHabits() async {
    habits = await StorageService.loadHabits();

    setState(() {});
  }

  Future<void> saveHabits() async {
    await StorageService.saveHabits(habits);
  }

  void addHabit() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      habits.add(
        Habit(name: controller.text.trim()),
      );
    });

    saveHabits();

    controller.clear();

    Navigator.pop(context);
  }

  void deleteHabit(int index) {
    setState(() {
      habits.removeAt(index);
    });

    saveHabits();
  }

  void toggleHabit(int index, bool? value) {
    setState(() {
      habits[index].completed = value ?? false;

      if (value == true) {
        habits[index].streak++;
      } else {
        if (habits[index].streak > 0) {
          habits[index].streak--;
        }
      }
    });

    saveHabits();
  }

  void showAddHabitDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Habit'),

          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter habit name',
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: addHabit,
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  int completedHabitsCount() {
    return habits
        .where((habit) => habit.completed)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Goal Tracker'),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(24),

            margin: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),

              gradient: LinearGradient(
                colors: [
                  Colors.green.shade400,
                  Colors.green.shade700,
                ],
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  'Today Progress',

                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  '${completedHabitsCount()}/${habits.length}',

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                LinearProgressIndicator(
                  value: habits.isEmpty
                      ? 0
                      : completedHabitsCount() / habits.length,

                  borderRadius: BorderRadius.circular(20),
                ),
              ],
            ),
          ),

          Expanded(
            child: habits.isEmpty
                ? const Center(
                    child: Text(
                      'No habits yet',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : ListView.builder(
                    itemCount: habits.length,

                    itemBuilder: (context, index) {
                      return HabitTile(
                        habit: habits[index],

                        onDelete: () {
                          deleteHabit(index);
                        },

                        onChanged: (value) {
                          toggleHabit(index, value);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddHabitDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}