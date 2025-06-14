import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? text;
  final Color? buttonColor;
  final Color? textColor;
  final Function()? onPressed;
  final Widget? child;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final double borderRadius;
  final double width;
  final double height;
  final IconData? icon;

  CustomElevatedButton({
    super.key,
    this.text,
    this.buttonColor,
    this.textColor,
    this.onPressed,
    this.child,
    this.fontFamily,
    this.fontWeight,
    this.fontSize = 20,
    this.borderRadius = 16,
    this.width = 310,
    this.height = 310,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor),
            const SizedBox(width: 8),
          ],
          Text(
            text!,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}
