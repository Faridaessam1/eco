import 'package:flutter/material.dart';

import '../../../Data/restaurant_card_data.dart';
import '../../../core/constants/app_colors.dart';


class RestaurantCard extends StatelessWidget{
  RestaurantCardData restaurantCardData;

  RestaurantCard({super.key, required this.restaurantCardData});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.35,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(restaurantCardData.imgPath),
          ),
          SizedBox(height: 3,),
          Row(
            children: [
              Column(
                children: [
                  Text(
                    restaurantCardData.restaurantName,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    restaurantCardData.restaurantCategory,
                    style: TextStyle(
                      color: AppColors.darkGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Text("4.4" ,style: TextStyle(color:AppColors.primaryColor,),),
                  Icon(Icons.star , color: AppColors.primaryColor,)
                ],
              )
            ],
          ),

          Row(
            children: [
              Icon(Icons.location_on ,color: AppColors.black,),
              Text(restaurantCardData.location,
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),),
              Icon(Icons.timelapse_outlined ,color: AppColors.black,),
              Text(restaurantCardData.deliveryEstimatedTime,
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),),
            ],
          )
        ],
      ),
    );
  }
  
}