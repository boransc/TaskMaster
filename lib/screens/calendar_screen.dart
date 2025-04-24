//importing in modules for calendar
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '/models/task_model.dart';

class CalendarScreen extends StatelessWidget {
  final DateTime selectedDate; //date selected currently
  final Function(DateTime) onDateSelected; //calls function to select date
  final List<TaskModel> tasks; //list of all the tasks in the database
  final Function(int) onCompleteTask; //to complete task
  final Function(int) onDeleteTask; //delete task

  const CalendarScreen({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.tasks,
    required this.onCompleteTask,
    required this.onDeleteTask,
  });

  //retrieves all the tasks on a specific date
  List<TaskModel> getTasksForDate(DateTime date) {
    return tasks.where((task) {
      return task.deadline.year == date.year && task.deadline.month == date.month && task.deadline.day == date.day;}).toList();
  }

  //function to get the highest priority tasks in the list
  String getHighestPriority(List<TaskModel> tasks) {
    String highestPriority = 'Low Priority';
    for (var task in tasks) {
      if (task.priority == 'High Priority') {
        return 'High Priority';
      } else if (task.priority == 'Medium Priority' && highestPriority != 'High Priority') {
        highestPriority = 'Medium Priority';
      }
    }
    return highestPriority;
  }

  //defines the colours of the priorities
  Color getPriorityColour(String priority) {
    switch (priority) {
      case 'High Priority': return Colors.red;
      case 'Medium Priority':return Colors.orange;
      case 'Low Priority':return Colors.green;
      default:
        return Colors.grey;
    }
  }

  //building the calendar screen
  @override
  Widget build(BuildContext context) {
    final tasksForSelectedDate = getTasksForDate(selectedDate);

    return Column(
      children: [
        //building the calendar widget ui
        TableCalendar(
          focusedDay: selectedDate, firstDay: DateTime.utc(2025, 1, 1), lastDay: DateTime.utc(2101, 1, 1),
          onDaySelected: (selectedDay, focusedDay) => onDateSelected(selectedDay),
          selectedDayPredicate: (day) => isSameDay(day, selectedDate),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              final tasksForDay = getTasksForDate(day);
              if (tasksForDay.isEmpty) return null;

              final priority = getHighestPriority(tasksForDay);
              return Align(alignment: Alignment.bottomCenter, child: Container(height: 5.0, width: 5.0,
                  decoration: BoxDecoration(color: getPriorityColour(priority), shape: BoxShape.circle)
                )
              );
            },
            todayBuilder: (context, day, _) {
              final tasksForDay = getTasksForDate(day);
              final priority = getHighestPriority(tasksForDay);
              return Container(margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(color: getPriorityColour(priority), shape: BoxShape.circle),
                child: Center(
                  child: Text('${day.day}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                )
              );
            },
            selectedBuilder: (context, day, _) {
              final tasksForDay = getTasksForDate(day);
              final priority = getHighestPriority(tasksForDay);
              return Container(margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(color: getPriorityColour(priority), shape: BoxShape.circle),
                child: Center(
                  child: Text('${day.day}',style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                )
              );
            }
          )
        ),
        //list of tasks on specific date
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: tasksForSelectedDate.length,
            itemBuilder: (context, index) {
              final task = tasksForSelectedDate[index];
              final taskIndex = tasks.indexOf(task);

              return Card(
                elevation: 2.0,
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  title: Text(task.title, style: TextStyle(
                    decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none, fontWeight: FontWeight.bold,
                    )
                  ),
                  subtitle: Text('Priority: ${task.priority} | Deadline: ${DateFormat.yMMMd().add_jm().format(task.deadline)}'),
                  leading: CircleAvatar(backgroundColor: getPriorityColour(task.priority), radius: 10),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(value: task.completed, onChanged: (value) => onCompleteTask(taskIndex)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red),onPressed: () => onDeleteTask(taskIndex)
                      )
                    ]
                  )
                )
              );
            }
          )
        )
      ]
    );
  }
}