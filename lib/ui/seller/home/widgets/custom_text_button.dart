import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  IconData icon;
  String text;
  Color? buttonColor;
  Color? textColor;
  Color? iconColor;
  final Function()? onPressed;

  CustomTextButton({
    super.key,
    required this.text,
    required this.icon,
    this.buttonColor = Colors.white,
    this.textColor = Colors.black,
    this.iconColor = Colors.black,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ?? () {}, // إذا ما فيش دالة ممررة، هتنفذ دالة فارغة
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: buttonColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

