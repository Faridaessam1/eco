import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Data/restaurant_card_data.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/favorite_provider.dart';


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
            child: Stack(
              children: [
            Image.network(
            restaurantCardData.sellerProfileImage ?? AppAssets.restaurantsCardImg ,
              height: height * 0.22,
              width: double.infinity,
              fit: BoxFit.cover,
              ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Consumer<FavoritesProvider>(
                    builder: (context, favoritesProvider, _) {
                      final isFav = favoritesProvider.isFavorite(restaurantCardData);
                      return GestureDetector(
                        onTap: () {
                          favoritesProvider.toggleFavorite(restaurantCardData);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 3,),
          Row(
            children: [
              Column(
                children: [
                  Text(
                    restaurantCardData.restaurantName,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    restaurantCardData.restaurantCategory,
                    style: const TextStyle(
                      color: AppColors.darkGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Row(
                children: [
                  Text("4.4" ,style: TextStyle(color:AppColors.primaryColor,),),
                  Icon(Icons.star , color: AppColors.primaryColor,)
                ],
              )
            ],
          ),

          Row(
            children: [
              const Icon(Icons.location_on ,color: AppColors.black,),
              Text(restaurantCardData.location,
                style: const TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),),
              const Icon(Icons.timelapse_outlined ,color: AppColors.black,),
              Text(restaurantCardData.deliveryEstimatedTime,
                style: const TextStyle(
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