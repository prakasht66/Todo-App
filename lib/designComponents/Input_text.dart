import 'package:flutter/material.dart';
import 'package:iostest/constants.dart';
import 'package:iostest/designComponents/space.dart';

class InputFieldWidget extends StatelessWidget {
  const InputFieldWidget({Key? key, required this.labelText, required this.trailingIcon, this.style, required this.controller, required this.onTapIcon, this.isTfEnabled, this.hint}) : super(key: key);

  final String labelText ;
  final Icon trailingIcon;
  final TextStyle? style;
  final TextEditingController controller;
  final VoidCallback onTapIcon;
  final bool? isTfEnabled;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            enabled: isTfEnabled ?? true,
            style: style ?? TextStyle(
                color: kPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                fontFamily: 'Poppins'),
            onTap: () {},
            controller: controller,
            decoration:  InputDecoration(
                hintStyle: const TextStyle(
                  height: 2.0, // sets the distance between label and input
                ),
                hintText: hint ?? '',
                // needed to create space between label and input
                border: InputBorder.none,
                labelText: labelText,
                labelStyle: const TextStyle(color: Colors.grey)),
          ),
        ),
        const HSpace(size: spacing_tiny),
        InkWell(
          child: trailingIcon,
          onTap: onTapIcon ,
        )
      ],
    );
  }

  void printSomething()
  {
    print('onTap called');
  }
}
