
import 'dart:ui';
import 'dart:math' as math;
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iostest/constants.dart';

import '../extensions/extension_color.dart';
part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject{
  @HiveField(0)
  final int id;
  @HiveField(1)
  late String title;
  @HiveField(2)
  late String description;
  @HiveField(3)
  late String dateCreated;
  @HiveField(4)
  late String dateTarget;
  @HiveField(5)
  String timeCreated;
  @HiveField(6)
  String place;
  @HiveField(7)
  String colorCode;
  @HiveField(8, defaultValue: false)
  bool completed;
  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dateCreated,
    this.timeCreated  = '',
    this.colorCode ='',
    this.place = '' ,
    this.completed =false
  });

  void toggleComplete(){
    completed =! completed;
  }


}
