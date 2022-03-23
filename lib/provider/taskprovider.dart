import 'package:flutter/cupertino.dart';
import 'package:iostest/helper/task_db.dart';
import 'package:iostest/model/task_model.dart';

class TaskProvider with ChangeNotifier{

  List _taskList = <TaskModel>[];

  List get taskList => _taskList;

  addItem(TaskModel taskModel) async {
    TaskDbManger().addTask(val: taskModel);
    getItems();
    //notifyListeners();
  }

  getItems() async {

    _taskList = TaskDbManger().taskBox.values.toList();

    //notifyListeners();
  }

  updateItem(int index, TaskModel inventory) {

    TaskDbManger().taskBox.putAt(index, inventory);

    notifyListeners();
  }

  deleteItem(int index) {


    TaskDbManger().taskBox.deleteAt(index);

    getItems();

    notifyListeners();
  }



}