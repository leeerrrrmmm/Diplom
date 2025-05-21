import 'package:flutter/material.dart';

class BuildButton extends StatefulWidget {
  final VoidCallback onTap;
  final Color btnColor;
  final String text;
  final double textSize;
  final FontWeight textFontWeight;
  final Color textColor;

  const BuildButton({
    super.key,
    required this.onTap,
    required this.btnColor,
    required this.text,
    required this.textSize,
    required this.textFontWeight,
    required this.textColor,
  });

  @override
  State<BuildButton> createState() => _BuildButtonState();
}

class _BuildButtonState extends State<BuildButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        width: double.infinity,
        height: 60,
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: _isPressed ? darken(widget.btnColor, 0.15) : widget.btnColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: widget.textSize,
              fontWeight: widget.textFontWeight,
              color: widget.textColor,
            ),
          ),
        ),
      ),
    );
  }

  // функция затемнения цвета
  Color darken(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
