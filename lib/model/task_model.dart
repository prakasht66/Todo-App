import 'dart:ui';

import 'package:hive/hive.dart';
part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject{
  @HiveField(0)
  late String title;
  @HiveField(1)
  late String description;
  @HiveField(2)
  late String dateCreated;
  @HiveField(3)
  late String timeCreated;
  @HiveField(4)
  late String place;
  @HiveField(5)
  late Color color;



}
