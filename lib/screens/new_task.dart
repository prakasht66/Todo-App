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
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../constants.dart';
import '../designComponents/header_widget.dart';
import '../model/task_model.dart';
import '../utils.dart';

class NewTaskWidget extends StatefulWidget {
  NewTaskWidget({Key? key, this.selectedTask}) : super(key: key);

  dynamic selectedTask;

  @override
  State<NewTaskWidget> createState() => _NewTaskWidgetState();
}

class _NewTaskWidgetState extends State<NewTaskWidget> {
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var placeController = TextEditingController();
  var titleTextController = TextEditingController();
  var descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  Color selectedColor = HexColor.fromHex('#fbe114');
  late final Box taskBox;
  List<String> selectedChips = [];
  bool shouldPop = true;

  var titleFocus = FocusNode();
  late List<bool> isSelectedButton;

  @override
  void initState() {
    if ( context.read<TaskProvider>().isNewTask)
      {
        context.read<TaskProvider>().reset();
        isSelectedButton = [true, false, false];
      }

    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    placeController.dispose();
    titleTextController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (context.read<TaskProvider>().selectedTask !=null) {
      var task = context.read<TaskProvider>().selectedTask;
      titleTextController.text = task!.title;
      descriptionController.text = task.description;
      dateController.text = task.dateTarget.toString();
      timeController.text = task.timeCreated.toString();
    }
    return BaseWidget(
      body: buildBody(),
      titleText: widget.selectedTask != null ? 'Edit Task' : 'New Task',
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
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                NewTaskTopWidget(
                  controller: titleTextController,
                  title: widget.selectedTask?.title ?? 'My New Task',
                  focusNode: titleFocus,
                  selectedColor: widget.selectedTask?.colorCode,
                ),
                const VSpace(size: spacing_small),
                InputFieldWidget(
                  labelText: 'Description',
                  onTapIcon: () {},
                  controller: descriptionController,
                ),
                const VSpace(size: spacing_small),
                _thinkAnimation(),
                const VSpace(size: spacing_small),
                _titleWidget(),
                const VSpace(size: spacing_small),
                _colorsRow(),
                const VSpace(size: spacing_small),
                const HorizontalDivider(),
                const VSpace(size: spacing_small),
                _dateSelector(),
                //_placeEntry(),
                // const HorizontalDivider(),
                const VSpace(size: spacing_small),
                //_toggleButtons(),
                _taskPriorityWidget(),
                const VSpace(size: spacing_small),
                const HorizontalDivider(),
                const VSpace(size: spacing_small),
                _chipItems(),
                const VSpace(size: spacing_tiny),
              ],
            ),
          ),
          Positioned(
              bottom: 20,
              child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(spacing_tiny),
                  child: _submitButton()))
        ],
      ),
    );
  }

  Widget _thinkAnimation() {
    var rProvider = context.read<TaskProvider>();
    if (rProvider.showAnimation) {
      return SizedBox(
          height: 100.0, child: Lottie.asset('assets/forgot_person.json'));
    } else {
      return const SizedBox();
    }
  }

  Widget _chipItems() {
    if (context.read<TaskProvider>().selectedTask !=null) {
      selectedChips.addAll(context.read<TaskProvider>().selectedTask!.categories.split(','));
    }
    return Wrap(
        alignment: WrapAlignment.start,
        spacing: 2.0,
        runAlignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        direction: Axis.horizontal,
        children: chipCategories
            .map((i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: ChoiceChip(
                      backgroundColor: kGrey,
                      selectedColor: kPrimary,
                      labelStyle: TextStyle(
                          color: selectedChips.contains(i)
                              ? Colors.white
                              : kPrimary),
                      label: Text(i),
                      onSelected: (value) {
                        if (selectedChips.contains(i)) {
                          selectedChips.remove(i);
                          setState(() {});
                          return;
                        }
                        if (selectedChips.length > 2) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content:
                                  Text('Please select only 3 categories')));
                          return;
                        }
                        selectedChips.add(i);

                        setState(() {});
                      },
                      selected: selectedChips.contains(i)),
                ))
            .toList());
  }

  Widget _submitButton() {
    return SafeArea(
      child: SizedBox(
        width: 200.0,
        child: ElevatedButton(
            onPressed: () async {
              var isValid = validateInputs();
              if (isValid) {
                await addTask();
              }
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

  bool validateInputs() {
    bool isValid = false;
    if (titleTextController.text.isEmpty) {
      showDialog('Title Cannot be Empty');
      return isValid;
    }
    if (descriptionController.text.isEmpty) {
      showDialog('Description Cannot be Empty');
      return isValid;
    }

    isValid = true;

    return isValid;
  }

  void showDialog(String message) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        // we set up a container inside which
        // we create center column and display text
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(message),
                ElevatedButton(
                  child: const Text('Ok', style: TextStyle(fontSize: 14)),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(kPrimary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> addTask() async {
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    var task = TaskModel(
        id: 0.toString(),
        title: titleTextController.text,
        description: descriptionController.text,
        dateCreated:
            BaseUtils.convertDateTimeDisplay(DateTime.now().toString()),
        dateTarget: BaseUtils.convertDateTimeDisplay(selectedDate.toString()),
        timeCreated: timeController.text,
        currentStatus:getSelectedPriority(),
        colorCode: selectedColor.toHex(),
        categories:  selectedChips.isNotEmpty ? selectedChips.join(',') : 'General');
    //TaskDbManger().addTask(val: tasks[0]);
    await taskProvider.addItem(task);
    //Future.delayed(const Duration(seconds: 1), () {
    Navigator.of(context).pop();
    //});
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
  String getSelectedPriority()
  {
    switch(context.read<TaskProvider>().selectedButtonIndex)
    {
      case 0:
        return status.Basic.name;
      case 1:
        return status.Urgent.name;
      case 2:
        return status.Important.name;

    }
    return status.Basic.name;


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
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: spacing_small, vertical: 0),
            decoration: BoxDecoration(
                border: Border.all(color: kGrey),
                borderRadius: BorderRadius.circular(spacing_small)),
            child: TextField(
              style: TextStyle(
                  color: kPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  fontFamily: 'Poppins'),
              enabled: false,
              onTap: () {
                _selectDate(context);
              },
              controller: dateController,
              decoration: const InputDecoration(
                  hintStyle: TextStyle(
                    height: 1.0, // sets the distance between label and input
                  ),
                  hintText: '',
                  // needed to create space between label and input
                  border: InputBorder.none,
                  labelText: 'Deadline',
                  labelStyle: TextStyle(color: Colors.grey)),
            ),
          ),
        ),
        const HSpace(size: spacing_tiny),
        InkWell(
          child: const Icon(CupertinoIcons.calendar_today),
          onTap: () {
            _selectDate(context);
          },
        ),
        const HSpace(size: spacing_small),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: spacing_small, vertical: 0),
            decoration: BoxDecoration(
                border: Border.all(color: kGrey),
                borderRadius: BorderRadius.circular(spacing_small)),
            child: TextField(
              style: TextStyle(
                  color: kPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  fontFamily: 'Poppins'),
              enabled: false,
              onTap: () {
                _selectDate(context);
              },
              controller: timeController,
              decoration: const InputDecoration(
                  hintStyle: TextStyle(
                    height: 1.0, // sets the distance between label and input
                  ),
                  hintText: '',
                  // needed to create space between label and input
                  border: InputBorder.none,
                  labelText: 'Time',
                  labelStyle: TextStyle(color: Colors.grey)),
            ),
          ),
        ),
        const HSpace(size: spacing_tiny),
        InkWell(
          child: const Icon(Icons.access_time),
          onTap: () {
            _showTimePicker();
          },
        ),
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
    context.read<TaskProvider>().showAnimation = false;
    Navigator.pop(context);
  }

  void _showTimePicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      selectedTime = value!;
      timeController.text = selectedTime.format(context).toString();
      setState(() {});
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.black, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      context: context,
    );
    if (picked != null && picked != selectedDate) {
      //setState(() {
      selectedDate = picked;
      dateController.text =
          BaseUtils.convertDateTimeDisplay(selectedDate.toString());
      // });
    }
  }

  ///Toggle Buttons
  Widget _toggleButtons() {
    return SizedBox(
      height: 50,
      child: ToggleButtons(
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        selectedColor: kPrimary,
        disabledColor: Colors.transparent,
        color: Colors.transparent,
        fillColor: Colors.transparent,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                  color: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: spacing_micro),
                  width: MediaQuery.of(context).size.width / 3 - 12,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(kPrimary),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                      onPressed: () {},
                      child: Text('Basic')))),
          Expanded(
              flex: 1,
              child: Container(
                  color: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: spacing_micro),
                  width: MediaQuery.of(context).size.width / 3 - 12,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(kPrimary),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                      onPressed: () {},
                      child: Text('Basic')))),
          Expanded(
              flex: 1,
              child: Container(
                  color: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: spacing_micro),
                  width: MediaQuery.of(context).size.width / 3 - 12,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(kPrimary),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                      onPressed: () {},
                      child: Text('Basic')))),
        ],
        onPressed: (int index) {
          setState(() {
            isSelectedButton[index] = !isSelectedButton[index];
          });
        },
        isSelected: isSelectedButton,
      ),
    );
  }

  Widget _taskPriorityWidget() {
    // if (widget.selectedTask!=null)
    //   {
    //     var currentItem=  status.values.where((element) => element.name == widget.selectedTask.currentStatus).first.index;
    //     context.read<TaskProvider>().setSelectedButtonIndex = currentItem;
    //   }
    var selectedButton = context.read<TaskProvider>().selectedButtonIndex;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
              onPressed: () {context.read<TaskProvider>().setSelectedButtonIndex = 0;setState(() {

              });},
              style: ButtonStyle(
                  backgroundColor: selectedButton == 0
                      ? MaterialStateProperty.all<Color>(kPrimary)
                      : MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              child: Text('Basic',style: TextStyle(color: selectedButton==0 ? Colors.white :kPrimary ),)),
        ),
        HSpace(size: spacing_tiny),
        Expanded(
          child: ElevatedButton(
              onPressed: () {context.read<TaskProvider>().setSelectedButtonIndex = 1;setState(() {

              });},
              style: ButtonStyle(
                  backgroundColor: selectedButton == 1
                      ? MaterialStateProperty.all<Color>(kPrimary)
                      : MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              child: Text('Urgent', style: TextStyle(color: selectedButton==1 ? Colors.white :kPrimary ))),
        ),
        HSpace(size: spacing_tiny),
        Expanded(
          child: ElevatedButton(
              onPressed: () {context.read<TaskProvider>().setSelectedButtonIndex = 2;setState(() {

              });},
              style: ButtonStyle(
                  backgroundColor: selectedButton == 2
                      ? MaterialStateProperty.all<Color>(kPrimary)
                      : MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              child: Text(
                'Important',
                style: TextStyle(color: selectedButton==2 ? Colors.white :kPrimary )
              )),
        ),
      ],
    );
  }
}
