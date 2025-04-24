//importing modules
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

class TaskScreen extends StatelessWidget {
  //controllers to manage task title and description
  final TextEditingController taskController;
  final TextEditingController descriptionController;

  //variables to manage the states of the task
  final String selectedPriority;
  final String selectedRecurrence;
  final DateTime? selectedDeadline;
  final Duration selectedReminderOffset;
  final bool isTaskFormVisible;
  final List<TaskModel> tasks;

  //callback functions to handle task UIs
  final VoidCallback onToggleFormVisibility;
  final VoidCallback onAddTask;
  final Function(String?) onPriorityChanged;
  final Function(String?) onRecurrenceChanged;
  final VoidCallback onPickDeadline;
  final Function(Duration?) onReminderChanged;
  final Function(int) onToggleTask;
  final Function(int) onDeleteTask;

  //constructor with the parameters needed for the task creation
  const TaskScreen({
    super.key,
    required this.taskController,
    required this.descriptionController,
    required this.selectedPriority,
    required this.selectedRecurrence,
    required this.selectedDeadline,
    required this.selectedReminderOffset,
    required this.isTaskFormVisible,
    required this.tasks,
    required this.onToggleFormVisibility,
    required this.onAddTask,
    required this.onPriorityChanged,
    required this.onRecurrenceChanged,
    required this.onPickDeadline,
    required this.onReminderChanged,
    required this.onToggleTask,
    required this.onDeleteTask
  });

  //gets the colour of priority
  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'High Priority': return Colors.red;
      case 'Medium Priority': return Colors.orange;
      case 'Low Priority': return Colors.green;
      default: return Colors.grey;
    }
  }

  //this builds everything in the task screen UI
  @override
  Widget build(BuildContext context) {
    //reminder options
    const reminderOptions = {'10 minutes before': Duration(minutes: 10), '30 minutes before': Duration(minutes: 30),
      '1 hour before': Duration(hours: 1), '1 day before': Duration(days: 1),};
    //recurrence options
    const recurrenceOptions = ['None', 'Daily', 'Weekly', 'Monthly',];

    return Column(
      children: [
        Padding( padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              //create task button
              ElevatedButton(onPressed: onToggleFormVisibility, child: const Text('Create Task')),
              const SizedBox(height: 16.0),
              Visibility(
                visible: isTaskFormVisible,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //enter task title field
                    TextField(
                      controller: taskController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(hintText: 'Enter a new task title...', hintStyle: const TextStyle(color: Colors.black45),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)), filled: true, fillColor: Colors.grey[200])),
                    const SizedBox(height: 16.0),
                    //enter description field
                    TextField(
                      controller: descriptionController,
                      style: const TextStyle(color: Colors.black),
                      maxLines: 3,
                      decoration: InputDecoration(hintText: 'Enter a description (optional)...', hintStyle: const TextStyle(color: Colors.black45),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                        filled: true, fillColor: Colors.grey[200])
                    ),
                    const SizedBox(height: 16.0),
                    //priority dropdown
                    const Text('Priority'),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      value: selectedPriority,
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                        filled: true, fillColor: Colors.grey[200]),
                      items: ['Low Priority', 'Medium Priority', 'High Priority'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Icon(Icons.circle, size: 10, color: getPriorityColor(value)),
                              const SizedBox(width: 8),
                              Text(
                                value,
                                style: TextStyle(color: getPriorityColor(value))
                              )
                            ]
                          )
                        );
                      }).toList(),
                      onChanged: onPriorityChanged
                    ),
                    //recurrence dropdown
                    const SizedBox(height: 16.0),
                    const Text('Recurrence'),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      value: selectedRecurrence,
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                        filled: true, fillColor: Colors.grey[200]),
                      items: recurrenceOptions.map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value)
                        );
                      }).toList(),
                      onChanged: onRecurrenceChanged
                    ),
                    //reminder dropdown
                    const SizedBox(height: 16.0),
                    const Text('Reminder'),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<Duration>(
                      value: selectedReminderOffset,
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                        filled: true, fillColor: Colors.grey[200]),
                      items: reminderOptions.entries.map((entry) {
                        return DropdownMenuItem<Duration>(
                          value: entry.value, child: Text(entry.key)
                        );
                      }).toList(),
                      onChanged: onReminderChanged
                    ),
                    //picking deadline
                    const SizedBox(height: 16.0),
                    ElevatedButton.icon(
                      onPressed: onPickDeadline,
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Pick Deadline')
                    ),
                    if (selectedDeadline != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('Selected Deadline: ${DateFormat.yMMMd().format(selectedDeadline!)}',
                          style: const TextStyle(color: Colors.black87)
                        )
                      ),
                    const SizedBox(height: 16.0),
                    //add task without details
                    ElevatedButton.icon(
                      onPressed: () {
                        if (taskController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a task title.')));
                          return;
                        }
                        if (selectedDeadline == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please pick a deadline.')));
                          return;
                        }
                        onAddTask();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Task')
                    )
                  ]
                )
              )
            ]
          )
        ),
        //building the list view
        Expanded(
          //check if list is empty
          child: tasks.isEmpty ? const Center(child: Text('No tasks yet. Add your first one!', style: TextStyle(fontSize: 16)))
          //if not empty then build list with tasks
              : ListView.builder(padding: const EdgeInsets.all(16.0), itemCount: tasks.length, itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                elevation: 2.0, margin: const EdgeInsets.only(bottom: 16.0), shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
                child: ListTile(
                  title: Text(task.title,
                      style: TextStyle(decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none, fontWeight: FontWeight.bold)),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Priority: ${task.priority} | Deadline: ${DateFormat.yMMMd().format(task.deadline)}'),
                      if (task.recurrence != 'None')
                        Padding(padding: const EdgeInsets.only(top: 2.0), child: Text('Repeats: ${task.recurrence}')),
                      if (task.description.isNotEmpty)
                        Padding(padding: const EdgeInsets.only(top: 4.0), child: Text(task.description))
                    ]
                  ),
                  leading: CircleAvatar(backgroundColor: getPriorityColor(task.priority), radius: 10),
                  trailing: Row(mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(value: task.completed, onChanged: (value) => onToggleTask(index)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red),onPressed: () => onDeleteTask(index))
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