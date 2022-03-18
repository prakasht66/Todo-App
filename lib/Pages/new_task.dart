import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iostest/designComponents/base_template.dart';
import 'package:iostest/designComponents/divider.dart';
import 'package:iostest/extensions/extension_color.dart';
import 'package:iostest/designComponents/space.dart';

import '../constants.dart';

class NewTaskWidget extends StatefulWidget {
  NewTaskWidget({Key? key}) : super(key: key);

  @override
  State<NewTaskWidget> createState() => _NewTaskWidgetState();
}

class _NewTaskWidgetState extends State<NewTaskWidget> {
  var dateController = TextEditingController();
  var placeController = TextEditingController();
  DateTime selectedDate = DateTime.now();

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
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VSpace(size: spacing_tiny),
              _titleWidget(),
              const VSpace(size: spacing_small),
              _colorsRow(),
              const VSpace(size: spacing_small),
              const HorizontalDivider(),
              const VSpace(size: spacing_tiny),
              _dateSelector(),
              const HorizontalDivider(),
              const VSpace(size: spacing_tiny),
              _placeEntry(),
              const HorizontalDivider(),
              const VSpace(size: spacing_tiny),
              _taskTypeWidget()
            ],
          ),
          Positioned(bottom: 60, child: bottomButton())
        ],
      ),
    );
  }

  Widget bottomButton() {
    return SizedBox(
      width: 200.0,
      child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(kPrimary),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(18.0),
              ))),
          child: Text('Save Task')),
    );
  }

  Widget _colorsRow() {
    return Wrap(
      spacing: 16.0,
      runSpacing: 8.0,
      children: List<Widget>.generate(
          customColors.length, // place the length of the array here
          (int index) {
        return InkWell(
          child: CircleAvatar(radius: 16, backgroundColor: customColors[index]),
        );
      }).toList(),
    );
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
        HSpace(size: spacing_tiny),
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
      setState(() {
        selectedDate = picked;
        dateController.text = selectedDate.toIso8601String();
      });
    }
  }

  Widget _taskTypeWidget() {
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
                        side: BorderSide(color: Colors.grey, width: 0.5),
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
                    side: BorderSide(color: Colors.grey, width: 0.5),
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
