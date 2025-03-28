import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/food_item_card.dart';

class RestaurantFoodItem extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          AppAssets.appLogo,
          height: height * 0.02,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 9),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(
                        AppAssets.restaurantsCardImg,
                        fit: BoxFit.cover,
                      )),
                ),
                Container(

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Green Kitchen",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height * 0.03,),
                      Row(children: [
                        Icon(Icons.star , color: AppColors.white,),
                        Text("4.4",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),),
                        Spacer(),
                        Text("Organic - Vegan ",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),)

                      ],)
                    ],
                  ),
                )

              ],
            ),
            SizedBox(height: height * 0.02,),
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

