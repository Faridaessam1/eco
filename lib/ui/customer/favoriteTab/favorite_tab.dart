import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Data/restaurant_card_data.dart';
import '../../../core/constants/app_assets.dart';

import '../widgets/restaurant_card.dart';

class FavoriteTab extends StatelessWidget{
  List<RestaurantCardData> restaurantsData=[
    RestaurantCardData(
      imgPath: AppAssets.restaurantsCardImg,
      restaurantName: "Green Kitchen",
      restaurantCategory: "Organic - Vegan",
      location: "2.1 KM away ",
      deliveryEstimatedTime:" 25 - 35 min ",
    ),
    RestaurantCardData(
      imgPath: AppAssets.restaurantsCardImg,
      restaurantName: "Green Kitchen",
      restaurantCategory: "Organic - Vegan",
      location: "2.1 KM away ",
      deliveryEstimatedTime:" 25 - 35 min ",
    ),
    RestaurantCardData(
      imgPath: AppAssets.restaurantsCardImg,
      restaurantName: "Green Kitchen",
      restaurantCategory: "Organic - Vegan",
      location: "2.1 KM away ",
      deliveryEstimatedTime:" 25 - 35 min ",
    ),
    RestaurantCardData(
      imgPath: AppAssets.restaurantsCardImg,
      restaurantName: "Green Kitchen",
      restaurantCategory: "Organic - Vegan",
      location: "2.1 KM away ",
      deliveryEstimatedTime:" 25 - 35 min ",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          AppAssets.appLogo,
          height: height * 0.02,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder:(context, index) => RestaurantCard(
                  restaurantCardData:restaurantsData[index] ,
                ),
                separatorBuilder: (context, index) => SizedBox(width:16 ,),
                itemCount: restaurantsData.length,
              ),
            ),

          ],
        ),
      ),
    );
  }

}