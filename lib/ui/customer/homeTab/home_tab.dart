
import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/food_item_card.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(AppAssets.appLogo),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Image.asset(
                AppAssets.searchIcon,
                width: 20,
                height: 20,
              )),
          IconButton(
              onPressed: () {},
              icon: Image.asset(
                AppAssets.notificationsIcon,
                width: 20,
                height: 20,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(
                        AppAssets.ad,
                        fit: BoxFit.cover,
                      )),
                ),
                Container(
                  height: height * 0.09,
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
                  child: Center(
                    child: Text(
                      "30% Off on Your First Order",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )

              ],
            ),

            SizedBox(
              height: 30,
            ),
            Text(
              "Recently Added",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 30,
            ),

            // Expanded(
            //   child: ListView.separated(
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder:(context, index) => FoodItemCard(),
            //     separatorBuilder: (context, index) => SizedBox(width:16 ,),
            //     itemCount: 6,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
