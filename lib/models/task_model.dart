import 'package:hive/hive.dart';
part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0) String title; //stores title

  @HiveField(1) String description; //stores description

  @HiveField(2) bool completed; //stores true or false for completion

  @HiveField(3) DateTime deadline; //stores deadline

  @HiveField(4) String priority;//stores priority

  @HiveField(5) int reminderOffsetSeconds; //stores reminder offset in seconds

  @HiveField(6) String recurrence; //stores recurrence

  //constructor to create new TaskModel object
  TaskModel({
    required this.title,
    required this.description,
    required this.completed,
    required this.deadline,
    required this.priority,
    required Duration reminderOffset,
    required this.recurrence,
  }) : reminderOffsetSeconds = reminderOffset.inSeconds;

  Duration get reminderOffset => Duration(seconds: reminderOffsetSeconds);
}


