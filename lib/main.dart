import 'package:flutter/material.dart';

import 'screens/home_page.dart';

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