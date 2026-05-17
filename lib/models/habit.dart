class Habit {
  String name;
  bool completed;
  int streak;

  List<String> completedDays;
  String lastCompletedDate;

  Habit({
    required this.name,
    this.completed = false,
    this.streak = 0,
    List<String>? completedDays,
    this.lastCompletedDate = '',
  }) : completedDays = completedDays ?? [];

  String toStorageString() {
    return '$name|$completed|$streak|'
      '${completedDays.join(",")}|'
      '$lastCompletedDate';
  }

  factory Habit.fromStorageString(String data) {
    final parts = data.split('|');

    return Habit(
      name: parts[0],
      completed: parts[1] == 'true',
      streak: int.parse(parts[2]),

      completedDays: parts.length > 3 &&
              parts[3].isNotEmpty
          ? parts[3].split(',')
          : [],
          lastCompletedDate:
            parts.length > 4 ? parts[4] : '',
    );
  }
}