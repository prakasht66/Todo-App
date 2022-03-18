import 'package:flutter/material.dart';

const double spacing_micro = 4.0;
const double spacing_tiny = 8.0;
const double spacing_small = 16.0;
const double spacing_standard= 24.0;
const double spacing_x_large = 32.0;
const double spacing_xx_large = 64.0;

class VSpace extends StatelessWidget {
  const VSpace({Key? key, required this.size}) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Space(width: 0, height: size);
  }
}

class HSpace extends StatelessWidget {
  const HSpace({Key? key, required this.size}) : super(key: key);

  // static double spacing_micro = 4.0;
  // static double spacing_tiny = 8.0;
  // static double spacing_small = 16.0;
  // static double spacing_standard = 32.0;
  // static double spacing_large= 64.0;

  final double size;

  @override
  Widget build(BuildContext context) {
    return Space(width: size, height: 0);
  }
}

class Space extends StatelessWidget {
  const Space({Key? key, required this.width, required this.height})
      : super(key: key);

  final double width;

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
