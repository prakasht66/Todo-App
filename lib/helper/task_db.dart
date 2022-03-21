import 'dart:typed_data';

import 'package:hive/hive.dart';

import '../model/task_model.dart';

class TaskDbManger {
  static final TaskDbManger _singleton = TaskDbManger._internal();

  factory TaskDbManger() {
    return _singleton;
  }

  TaskDbManger._internal();

  late final Box taskBox;

  void initDb() {
    if (Hive.isBoxOpen('tasks')) {
      taskBox = Hive.box('tasks');
    }
  }

  void addTask({required TaskModel val}) {
    taskBox.add(val);
  }

  void updateTask({dynamic key, required TaskModel val}) {
    taskBox.put(key, val);
  }

  void deleteTask({dynamic key}) {
    taskBox.delete(key);
  }
}
