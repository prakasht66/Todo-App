import 'package:flutter/material.dart';
import 'package:iostest/constants.dart';

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color: kGrey,height: 1.0,);
  }
}

class VerticalDivider extends StatelessWidget {
  const VerticalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color: kGrey,  width: 1.0,);
  }
}
