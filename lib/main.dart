import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const HabitApp());
}

class Habit {
  String name;
  bool completed;

  Habit({
    required this.name,
    this.completed = false,
  });
}

class HabitApp extends StatelessWidget {
  const HabitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Goal Tracker',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Habit> habits = [];

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  Future<void> saveHabits() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> savedHabits = habits.map((habit) {
      return '${habit.name}|${habit.completed}';
    }).toList();

    await prefs.setStringList('habits', savedHabits);
  }

  Future<void> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> savedHabits =
        prefs.getStringList('habits') ?? [];

    setState(() {
      habits = savedHabits.map((item) {
        final parts = item.split('|');

        return Habit(
          name: parts[0],
          completed: parts[1] == 'true',
        );
      }).toList();
    });
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
    return habits.where((habit) => habit.completed).length;
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
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Completed today: '
              '${completedHabitsCount()}/${habits.length}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
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
                      final habit = habits[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: habit.completed,
                            onChanged: (value) {
                              toggleHabit(index, value);
                            },
                          ),
                          title: Text(
                            habit.name,
                            style: TextStyle(
                              decoration: habit.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deleteHabit(index);
                            },
                          ),
                        ),
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