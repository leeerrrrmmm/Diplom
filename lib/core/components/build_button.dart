import 'package:diplom/core/components/build_text.dart';
import 'package:flutter/material.dart';

class BuildButton extends StatelessWidget {
  const BuildButton({
    super.key,
    required this.btnColor,
    required this.text,
    required this.textSize,
    required this.textFontWeight,
    required this.textColor,
    required this.onTap,
  });

  final Color btnColor;
  final String text;
  final double textSize;
  final FontWeight textFontWeight;
  final Color textColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 63,
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: BuildText(
            text: text,
            fontSize: textSize,
            fontWeight: textFontWeight,
            textColor: textColor,
          ),
        ),
      ),
    );
  }
}
