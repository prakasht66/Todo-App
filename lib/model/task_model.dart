import 'package:hive/hive.dart';

import '../constants.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
   String id;
  @HiveField(1)
   String title;
  @HiveField(2)
   String description;
  @HiveField(3)
   String dateCreated;
  @HiveField(4)
   String dateTarget;
  @HiveField(5)
  String timeCreated;
  @HiveField(6)
  String place;
  @HiveField(7)
  String colorCode;
  @HiveField(8)
  String currentStatus;
  @HiveField(9)
  String categories;

  TaskModel(
      {  this.id='0',
       this.title='',
       this.description='',
       this.dateCreated='',
       this.dateTarget='',
        this.categories='',
      this.timeCreated = '',
      this.colorCode = '',
      this.place = '',
      this.currentStatus = 'notStarted'});
}

enum status {  Basic,
  Urgent,
  Important }
