import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor ?? AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text!,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: fontWeight,
            fontSize: fontSize,
            fontFamily: fontFamily,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
