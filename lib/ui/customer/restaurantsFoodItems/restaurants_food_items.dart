import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/food_item_card.dart';

class RestaurantFoodItem extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Green Kitchen Menu",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.green,
        ),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 9),
        child: Column(
          children: [
            Expanded(
                child : ListView.separated(
                  itemCount: (10 / 2).ceil(),
                  separatorBuilder: (context, index) => SizedBox(height: height *  0.05 ), // مسافة بين الصفوف
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: FoodItemCard()), // العنصر الأول
                        SizedBox(width: width * 0.08 ),
                        Expanded(child: FoodItemCard()), // العنصر الثاني
                      ],
                    );
                  },
                )
            )

          ],
        ),
      ),
    );
  }
}

