import 'package:flutter/cupertino.dart';
import 'package:iostest/constants.dart';
import 'package:iostest/helper/task_db.dart';
import 'package:iostest/model/task_model.dart';

class TaskProvider with ChangeNotifier {
  List _taskList = <TaskModel>[];

  List get taskList => _taskList;

  Color _selectedColor = kPrimary;

  Color get selectedColor => _selectedColor;

  int _selectedButtonIndex = 0;

  int get selectedButtonIndex => _selectedButtonIndex;

  TaskModel? _selectedTask;
  TaskModel? get selectedTask => _selectedTask;

  bool _isNewTask = false;

  bool get isNewTask => _isNewTask;

  set setIsNewTask(bool val)
  {
    _isNewTask = val;
    notifyListeners();
  }

  set setSelectedTask(TaskModel val)
  {
    _selectedTask = val;
    notifyListeners();
  }

  set setSelectedButtonIndex(int val)
  {
    _selectedButtonIndex = val;
    notifyListeners();
  }

  bool _showAnimation = false;

  bool get showAnimation => _showAnimation;

  set showAnimation(bool val) {
    _showAnimation = val;
    notifyListeners();
  }

  set selectedColor(Color val) {
    _selectedColor = val;
    notifyListeners();
  }

  Future<dynamic> addItem(TaskModel taskModel) async {
    TaskDbManger().addTask(val: taskModel);
    getItems();
    notifyListeners();
  }

  Future<dynamic> getItems() async {
    _taskList = TaskDbManger().taskBox.values.toList();
    print('items -${_taskList.length}');
    //notifyListeners();
  }

  updateItem(int index, TaskModel inventory) {
    TaskDbManger().taskBox.putAt(index, inventory);

    notifyListeners();
  }

  Future<dynamic> deleteItem(int index) async {
    TaskDbManger().taskBox.deleteAt(index);

    getItems();

    notifyListeners();
  }

  void reset()
  {
    _selectedTask = null;
    setSelectedButtonIndex = 0;
  }
}
