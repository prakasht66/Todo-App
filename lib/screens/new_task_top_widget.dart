import 'package:flutter/material.dart';
import 'package:iostest/provider/taskprovider.dart';
import 'package:provider/provider.dart';

import '../designComponents/Input_text.dart';
import '../designComponents/space.dart';
//ignore:must_be immutable
class NewTaskTopWidget extends StatelessWidget {
   NewTaskTopWidget({Key? key,required this.controller, required this.title, required this.focusNode}) : super(key: key);
  final TextEditingController controller;
  final String title;
  final FocusNode focusNode;

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
      focusNode:focusNode ,
      trailingIcon: Icon(
        Icons.circle,
        color: _context.select((TaskProvider value) => value.selectedColor),
      ),
      labelText: title.isEmpty ? '' : title,

      onTapIcon: () {},
      controller: controller,
    );
  }
}
