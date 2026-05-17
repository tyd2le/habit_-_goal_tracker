import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const HabitApp());
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
  List<String> habits = [];

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  Future<void> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      habits = prefs.getStringList('habits') ?? [];
    });
  }

  Future<void> saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('habits', habits);
  }

  void addHabit() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      habits.add(controller.text.trim());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Goal Tracker'),
      ),
      body: habits.isEmpty
          ? const Center(
              child: Text(
                'No habits yet',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: Text(habits[index]),
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
      floatingActionButton: FloatingActionButton(
        onPressed: showAddHabitDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}