import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;
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
  @HiveField(8)
  String currentStatus;
  @HiveField(9)
  late List<String> categories;

  TaskModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.dateCreated,
      required this.dateTarget,
      required this.categories,
      this.timeCreated = '',
      this.colorCode = '',
      this.place = '',
      this.currentStatus = 'notStarted'});
}

enum status { ongoing, upcoming, completed, notStarted }
