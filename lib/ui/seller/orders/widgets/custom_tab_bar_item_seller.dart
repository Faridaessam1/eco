import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class CustomTabBarItemSeller extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Color tabColor;

  CustomTabBarItemSeller({
    super.key,
    required this.title,
    required this.tabColor,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? tabColor.withOpacity(0.2) : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: tabColor,
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: tabColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
