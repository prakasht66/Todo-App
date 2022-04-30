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
  bool shouldPop = true;

  var titleFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
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
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
               NewTaskTopWidget(controller: titleTextController, title: 'My New Task', focusNode: titleFocus,),
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
          Positioned(bottom: 20, child: Container(color: Colors.transparent, padding: const EdgeInsets.all(spacing_tiny), child: _submitButton()))
        ],
      ),
    );
  }

  Widget _thinkAnimation()
  {
    var rProvider = context.read<TaskProvider>();
    if(rProvider.showAnimation)
      {
        return SizedBox(height:100.0,child: Lottie.asset('assets/forgot_person.json'));
      }
    else
      {
        return const SizedBox();
      }


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

              var isValid =  validateInputs();
          if (isValid)
            {
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

  bool validateInputs()
  {
   bool isValid = false;
    if (titleTextController.text.isEmpty)
      {
        showDialog('Title Cannot be Empty');
        return isValid;
      }
    if (descriptionController.text.isEmpty)
      {
        showDialog('Description Cannot be Empty');
        return isValid;
      }

    isValid =true;

    return isValid;


  }

  void showDialog(String message)
  {
    showModalBottomSheet(
      context: context,

      builder: (context) {        // we set up a container inside which
        // we create center column and display text
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 Text(message),
                ElevatedButton(
                    child: const Text(
                        'Ok',
                        style: TextStyle(fontSize: 14)
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(kPrimary),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                    onPressed: () {Navigator.pop(context);},
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> addTask() async {
    TaskProvider taskProvider = Provider.of<TaskProvider>(context, listen: false);
    var task = TaskModel(
        id: 0.toString(),
        title: titleTextController.text,
        description: descriptionController.text,
        dateCreated: DateTime.now().toString(),
        dateTarget: selectedDate.toString(),
        currentStatus: status.notStarted.toString(),
        colorCode: selectedColor.toHex(), categories: selectedChips.isNotEmpty ? selectedChips : ['General'].toList());
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
          child: const Icon(CupertinoIcons.calendar_today),
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
    context.read<TaskProvider>().showAnimation = false;
    Navigator.pop(context);
  }

  _selectDate(BuildContext context) async {

    final DateTime? picked= await showDatePicker(
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
      }, initialDate: DateTime.now(),
      firstDate: DateTime.now(),  lastDate:  DateTime(2025), context: context,
    );
    if (picked != null && picked != selectedDate) {
      //setState(() {
        selectedDate = picked;
        dateController.text = BaseUtils.convertDateTimeDisplay (selectedDate.toString());
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
