import 'package:flutter/material.dart';
import 'package:iostest/designComponents/space.dart';

import '../constants.dart';

class CardTaskWidget extends StatelessWidget {
  const CardTaskWidget(
      {Key? key, this.cardBackground, this.chipItems, required this.title, this.date, required this.time, required this.status, this.onTapDelete})
      : super(key: key);

  final Color? cardBackground;

  final List<String>? chipItems;
  final String title;
  final String? date;
  final String time;
  final String status;
  final VoidCallback? onTapDelete;



  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.symmetric(vertical: spacing_tiny) ,
      padding: const EdgeInsets.all(spacing_tiny),
      height: 170.0,
      decoration: BoxDecoration(
          color: cardBackground ?? Colors.cyan,
          borderRadius: const BorderRadius.all(const Radius.circular(16.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Wrap(
                spacing: 4.0,
                runSpacing: 0.0,
                children: List<Widget>.generate(
                    chipItems!.length, // place the length of the array here
                        (int index) {
                      return Chip(
                          label: Text(chipItems![index])
                      );
                    }
                ).toList(),
              ),
              const Spacer(),
              const Icon(Icons.edit_note_rounded)
            ],
          ),
          const VSpace(size: spacing_tiny),
          subTitleWidget(),
          const Spacer(),
          dateWidget(),
          const VSpace(size: spacing_tiny),
          timeWidget(),
        ],
      ),
    );
  }

  Widget subTitleWidget() {
    return Text(
      title,
      style: TextStyle(
          color: kPrimary,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          fontSize: 18),
    );
  }

  Widget dateWidget() {
    return Row(children: [
      const Icon(Icons.calendar_today, size: 16,),
      const HSpace(size: spacing_micro),
      Text(
       date ?? DateTime.now().toString(),
        style: TextStyle(
            color: kPrimary,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 12),
      )
    ]);
  }

  Widget timeWidget() {
    return Row(children: [
      const Icon(Icons.access_time, size: 16,),
      const HSpace(size: spacing_micro),
      Text(
      time,
        style: TextStyle(
            color: kPrimary,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 12),
      ),
      const Spacer(),
      InkWell(child:  Icon(Icons.circle_outlined),onTap: onTapDelete,)
    ]);
  }
}
