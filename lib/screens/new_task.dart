import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iostest/designComponents/Input_text.dart';
import 'package:iostest/designComponents/base_template.dart';
import 'package:iostest/designComponents/divider.dart';
import 'package:iostest/extensions/extension_color.dart';
import 'package:iostest/designComponents/space.dart';
import 'package:iostest/helper/task_db.dart';
import 'package:iostest/provider/taskprovider.dart';
import 'package:iostest/screens/new_task_top_widget.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../constants.dart';
import '../designComponents/header_widget.dart';
import '../model/task_model.dart';

class NewTaskWidget extends StatefulWidget {
  const NewTaskWidget({Key? key}) : super(key: key);

  @override
  State<NewTaskWidget> createState() => _NewTaskWidgetState();
}

class _NewTaskWidgetState extends State<NewTaskWidget> {
  var dateController = TextEditingController();
  var placeController = TextEditingController();
  var titleTextController = TextEditingController();
  var descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  Color selectedColor = HexColor.fromHex('#fbe114');
  late final Box taskBox;
  List<String>selectedChips =[];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TaskDbManger().taskBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      body: buildBody(),
      titleText: 'New Task',
      leadingIcon: InkWell(
          onTap: goBack,
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          )),
      trailingIcon: const SizedBox(),
    );
  }

  Widget buildBody() {
    return Container(
      padding: const EdgeInsets.only(left: spacing_small, right: spacing_small),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
               NewTaskTopWidget(titleTextController: titleTextController,),
                const VSpace(size: spacing_small),
                InputFieldWidget(
                  labelText: 'Description',
                  onTapIcon: () {},
                  controller: descriptionController,
                ),
                const VSpace(size: spacing_small),
                _titleWidget(),
                const VSpace(size: spacing_small),
                _colorsRow(),
                const VSpace(size: spacing_small),
                const HorizontalDivider(),
                const VSpace(size: spacing_tiny),
                _dateSelector(),
                const HorizontalDivider(),
                const VSpace(size: spacing_tiny),
                //_placeEntry(),
                // const HorizontalDivider(),
                const VSpace(size: spacing_tiny),
                _taskPriorityWidget(),
                const VSpace(size: spacing_tiny),
                const HorizontalDivider(),
                _chipItems(),
                const VSpace(size: spacing_tiny),
              ],
            ),
          ),
          Positioned(bottom: 20, child: Container(color: Colors.transparent, padding: EdgeInsets.all(spacing_tiny), child: _submitButton()))
        ],
      ),
    );
  }


  Widget _chipItems() {
    String _isSelected = "";
    return Wrap(
        alignment: WrapAlignment.start,
        spacing: 2.0,

        runAlignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        direction: Axis.horizontal,
        children: chipCategories.map((i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          child: ChoiceChip(
              backgroundColor: customColors[Random().nextInt(customColors.length)],
              label: Text(i), onSelected: (value) {
                selectedChips.add(i);

          ;},  selected: _isSelected == i,),
        )).toList());
  }

  Widget _submitButton() {
    return SafeArea(
      child: SizedBox(
        width: 200.0,
        child: ElevatedButton(
            onPressed: () async {
              await addTask();
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(kPrimary),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(18.0),
                ))),
            child: Text('Save Task')),
      ),
    );
  }

  Future<void> addTask() async {
    TaskProvider counter = Provider.of<TaskProvider>(context, listen: false);
    var task = TaskModel(
        id: 0.toString(),
        title: titleTextController.text,
        description: descriptionController.text,
        dateCreated: DateTime.now().toString(),
        dateTarget: selectedDate.toString(),
        currentStatus: status.notStarted.toString(),
        colorCode: selectedColor.toHex(), categories: selectedChips.isNotEmpty ? selectedChips : ['General'].toList());
    //TaskDbManger().addTask(val: tasks[0]);
    await counter.addItem(task);
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  Widget _colorsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // runSpacing: 8.0,
      children: List<Widget>.generate(
          customColors.length, // place the length of the array here
          (int index) {
        return InkWell(
          onTap: () {
            getSelectedColor(index);
          },
          child: CircleAvatar(radius: 16, backgroundColor: customColors[index]),
        );
      }).toList(),
    );
  }

  void getSelectedColor(int selectedIndex) {
    Color currentColor = customColors[selectedIndex];
    //context.select((TaskProvider value) => value.selectedColor = currentColor);
    context.read<TaskProvider>().selectedColor = currentColor;
    selectedColor = currentColor;
  }

  Widget _titleWidget() {
    return const Text(
      'Color Task',
      style: TextStyle(
          color: Colors.grey,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w800,
          fontSize: 18),
    );
  }

  Widget _dateSelector() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            style: TextStyle(
                color: kPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                fontFamily: 'Poppins'),
            enabled: false,
            onTap: () {
              _selectDate(context);
            },
            controller: dateController,
            decoration: const InputDecoration(
                hintStyle: TextStyle(
                  height: 2.0, // sets the distance between label and input
                ),
                hintText: '',
                // needed to create space between label and input
                border: InputBorder.none,
                labelText: 'Deadline',
                labelStyle: TextStyle(color: Colors.grey)),
          ),
        ),
        const HSpace(size: spacing_tiny),
        InkWell(
          child: Icon(CupertinoIcons.calendar_today),
          onTap: () {
            _selectDate(context);
          },
        )
      ],
    );
  }

  Widget _placeEntry() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            style: TextStyle(
                color: kPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                fontFamily: 'Poppins'),
            onTap: () {},
            controller: placeController,
            decoration: const InputDecoration(
                hintStyle: TextStyle(
                  height: 2.0, // sets the distance between label and input
                ),
                hintText: '',
                // needed to create space between label and input
                border: InputBorder.none,
                labelText: 'Place',
                labelStyle: TextStyle(color: Colors.grey)),
          ),
        ),
        HSpace(size: spacing_tiny),
        InkWell(
          child: Icon(CupertinoIcons.location),
          onTap: () {},
        )
      ],
    );
  }

  void goBack() {
    Navigator.pop(context);
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      //setState(() {
        selectedDate = picked;
        dateController.text = selectedDate.toIso8601String();
     // });
    }
  }

  Widget _taskPriorityWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(kPrimary),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              child: Text('Basic')),
        ),
        HSpace(size: spacing_tiny),
        Expanded(
          child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              child: Text('Urgent', style: TextStyle(color: kPrimary))),
        ),
        HSpace(size: spacing_tiny),
        Expanded(
          child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              child: Text(
                'Important',
                style: TextStyle(color: kPrimary),
              )),
        ),
      ],
    );
  }
}
