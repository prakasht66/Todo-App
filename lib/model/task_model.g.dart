// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
      id: fields[0] ?? '0',
      title: fields[1] ?? 'No Title',
      description: fields[2] ?? '',
      dateCreated: fields[3] ?? DateTime.now().toString(),
      dateTarget: fields[4] ?? DateTime.now().toString(),
      timeCreated: fields[5] ?? DateTime.now().toString(),
      // dateCreated: fields[3] ,
      // dateTarget: fields[4] ,
      // timeCreated: fields[5],
      colorCode: fields[7] ?? '#f79e82' ,
      place: fields[6]  ?? '',
      currentStatus: fields[8] ?? 'notStarted', categories: fields[9] ?? 'General',
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.dateCreated)
      ..writeByte(4)
      ..write(obj.dateTarget)
      ..writeByte(5)
      ..write(obj.timeCreated)
      ..writeByte(6)
      ..write(obj.place)
      ..writeByte(7)
      ..write(obj.colorCode)
      ..writeByte(8)
      ..write(obj.currentStatus);
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
