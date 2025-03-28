import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class CustomStatusContainer extends StatelessWidget {
  final String orderStatus;
  final Color orderStatusColor;
  bool isNewDishTab;

  CustomStatusContainer({
    super.key,
    required this.orderStatus,
    required this.orderStatusColor,
    this.isNewDishTab = false,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Container(
      width: mediaQuery.size.width * 0.2,
      height: mediaQuery.size.height * 0.03,
      decoration: BoxDecoration(
        color:
            isNewDishTab ? AppColors.green : orderStatusColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        orderStatus,
        style: TextStyle(
          color: isNewDishTab ? AppColors.white : orderStatusColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
