import 'package:flutter/material.dart';
import '../models/task_model.dart';

class StatisticsScreen extends StatelessWidget {
  final List<TaskModel> tasks;
  const StatisticsScreen({super.key, required this.tasks});

  @override
  //building the logic of the screen
  Widget build(BuildContext context) {
    final totalTasks = tasks.length; //total tasks
    final completedTasks = tasks.where((t) => t.completed).length; //total completed tasks
    final completionRate = totalTasks > 0 ? (completedTasks / totalTasks * 100).toStringAsFixed(1) : '0'; //total completed tasks / total completed tasks * 100

    final now = DateTime.now(); //current day
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); //calculates the start of the week
    final completedThisWeek = tasks.where((t) => t.completed && t.deadline.isAfter(startOfWeek)).length; //calculated tasks done this week

    //priority count
    final priorityCount = {
      'High Priority': tasks.where((t) => t.priority == 'High Priority').length,
      'Medium Priority': tasks.where((t) => t.priority == 'Medium Priority').length,
      'Low Priority': tasks.where((t) => t.priority == 'Low Priority').length,
    };

    final streak = calculateCurrentStreak(tasks);

    //the layout of the cards
    return Scaffold(
      appBar: AppBar(title: const Text('Productivity Dashboard'), backgroundColor: Theme.of(context).colorScheme.primary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildStatCard('🔥 Current Streak', '$streak day${streak == 1 ? '' : 's'}'),
          buildStatCard('Total Tasks', '$totalTasks'),
          buildStatCard('Completed Tasks', '$completedTasks'),
          buildStatCard('Completion Rate', '$completionRate%'),
          buildStatCard('Completed This Week', '$completedThisWeek'),
          buildStatCard('High Priority Tasks', '${priorityCount['High Priority']}'),
          buildStatCard('Medium Priority Tasks', '${priorityCount['Medium Priority']}'),
          buildStatCard('Low Priority Tasks', '${priorityCount['Low Priority']}'),
        ],
      ),
    );
  }

  //styyling of each card
  Widget buildStatCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  //calculating the current streak
  int calculateCurrentStreak(List<TaskModel> tasks) {
    final completedDates = tasks.where((task) => task.completed)
                            .map((task) => DateTime(task.deadline.year, task.deadline.month, task.deadline.day)).toSet();
    int streak = 0;
    DateTime currentDay = DateTime.now();

    while (completedDates.contains(DateTime(currentDay.year, currentDay.month, currentDay.day))) {
      streak++;
      currentDay = currentDay.subtract(const Duration(days: 1));
    }
    return streak;
  }
}
