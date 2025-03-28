import 'package:flutter/material.dart';

import '../../../../Data/food_card_in_cart_tab_data.dart';
import '../../../../core/constants/app_colors.dart';


class FoodCardWidget extends StatelessWidget {
  final FoodCardInCartTabData foodData;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const FoodCardWidget({
    Key? key,
    required this.foodData,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Image.asset(
          foodData.foodImgPath,
          height: height * 0.10,
        ),
        SizedBox(width: width * 0.02),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              foodData.foodName,
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            SizedBox(height: height * 0.01),
            Text(
              "${foodData.foodPrice} L.E",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Spacer(),
        Column(
          children: [
            Icon(
              Icons.delete_rounded,
              color: AppColors.black,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: AppColors.grey),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onDecrement,
                    icon: Icon(Icons.remove),
                    color: AppColors.primaryColor,
                  ),
                  Text(
                    foodData.foodQuantity.toString(),
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    onPressed: onIncrement,
                    icon: Icon(Icons.add),
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
