class Habit {
  String name;
  bool completed;
  int streak;

  Habit({
    required this.name,
    this.completed = false,
    this.streak = 0,
  });

  String toStorageString() {
    return '$name|$completed|$streak';
  }

  factory Habit.fromStorageString(String data) {
    final parts = data.split('|');

    return Habit(
      name: parts[0],
      completed: parts[1] == 'true',
      streak: int.parse(parts[2]),
    );
  }
}