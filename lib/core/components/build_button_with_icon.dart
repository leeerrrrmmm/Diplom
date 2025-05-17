import 'package:diplom/core/components/build_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BuildButtonWithIconOrImage extends StatelessWidget {
  const BuildButtonWithIconOrImage({
    super.key,
    required this.btnColor,
    required this.text,
    required this.textSize,
    required this.textFontWeight,
    required this.textColor,
    required this.onTap,
    required this.faIcons,
    required this.isIcon,
    this.assetName,
    this.iconColor,
  });

  final Color btnColor;
  final String text;
  final double textSize;
  final FontWeight textFontWeight;
  final Color textColor;
  final void Function()? onTap;
  final IconData? faIcons;
  final Color? iconColor;
  final bool isIcon;
  final String? assetName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 63,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffEBEAEC)),
          color: btnColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            isIcon
                ? FaIcon(faIcons, color: iconColor)
                : Image.asset(assetName ?? ''),
            BuildText(
              text: text,
              fontSize: textSize,
              fontWeight: textFontWeight,
              textColor: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
