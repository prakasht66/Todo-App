import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Test',style:AppTextStyle.sofiaProBold(Colors.accents,16.0),),);
  }

}
class CustomTextStyle {
  static TextStyle? display5(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 18.0);
  }
}

class AppTextStyle {
  static Function sofiaProRegular = ({required Color color, required double size}) =>
      _sofiaPro(color, size, FontWeight.w400);

  static Function sofiaProMedium = ({required Color color, required double size}) =>
      _sofiaPro(color, size, FontWeight.w500);

  static Function sofiaProBold = ({required Color color, required double size}) =>
      _sofiaPro(color, size, FontWeight.w700);

  static Function latoRegular = ({required Color color, required double size}) => _lato(color, size, FontWeight.w400);

  static TextStyle _sofiaPro(Color color, double size, FontWeight fontWeight) {
    return _textStyle("SofiaPro", color, size, fontWeight);
  }
  static TextStyle _lato(Color color, double size, FontWeight fontWeight) {
    return _textStyle("LatoRegular", color, size, fontWeight);
  }
  static TextStyle _textStyle(
      String fontFamily, Color color, double size, FontWeight fontWeight) {
    return TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontSize: size,
        fontWeight: fontWeight);
  }
}

