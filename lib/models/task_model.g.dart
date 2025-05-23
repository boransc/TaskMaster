// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **
// TypeAdapterGenerator
// **

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 0;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      title: fields[0] as String,
      description: fields[1] as String,
      completed: fields[2] as bool,
      deadline: fields[3] as DateTime,
      priority: fields[4] as String,
      reminderOffset: Duration(seconds: fields[5] as int),
      recurrence: fields[6] as String,
    );

  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.completed)
      ..writeByte(3)
      ..write(obj.deadline)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.reminderOffsetSeconds)
      ..writeByte(6)
      ..write(obj.recurrence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TaskModelAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}