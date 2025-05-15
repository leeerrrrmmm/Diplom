import 'package:flutter/material.dart';

class BuildText extends StatelessWidget {
  const BuildText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.textColor,
  });

  final String text;
  final double fontSize;
  final Color textColor;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
