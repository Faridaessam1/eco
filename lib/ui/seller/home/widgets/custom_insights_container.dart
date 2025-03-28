import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';


class CustomInsightsContainer extends StatelessWidget {
  IconData icon;
  String text;
  String number;

  CustomInsightsContainer(
      {super.key,
     required this.icon,
    required this.text,
     required this.number
  });

  @override
  Widget build(BuildContext context) {

    var mediaQuery= MediaQuery.of(context);

    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(8),
      width: mediaQuery.size.width * 0.423,
      height: mediaQuery.size.height * 0.123,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.lightMint,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
          size: 25,
          ),
          Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.black
            ),
          ),
          Text(
           number,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.black
            ),
          ),
        ],
      ),
    );
  }
}
