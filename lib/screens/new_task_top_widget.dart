import 'package:flutter/material.dart';
import 'package:iostest/provider/taskprovider.dart';
import 'package:provider/provider.dart';

import '../designComponents/Input_text.dart';
import '../designComponents/space.dart';

class NewTaskTopWidget extends StatelessWidget {
   NewTaskTopWidget({Key? key,this.titleTextController}) : super(key: key);
  final titleTextController;

  late BuildContext _context;
  @override
  Widget build(BuildContext context) {
    _context =context;
    return Column(children: [
      // HeaderWidget(title: 'My New Task',),
      const VSpace(size: spacing_tiny),
      _taskName(),
    ],);
  }
  Widget _taskName()
  {
    return InputFieldWidget(
      trailingIcon: Icon(
        Icons.circle,
        //color:selectedColor,
        //color: _context.watch<TaskProvider>().selectedColor,
        color: _context.select((TaskProvider value) => value.selectedColor),
      ),
      labelText: 'My New Task',

      onTapIcon: () {},
      controller: titleTextController,
    );
  }
}
