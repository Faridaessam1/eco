import 'package:eco_eaters_app_3/core/utils/snack_bar_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Data/recently_added_dish_data_model.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/cart_provider.dart';

class FoodItemCard extends StatelessWidget {
  final RecentlyAddedDishDataModel dishData;

  FoodItemCard({required this.dishData});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.35,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: (dishData.dishImage != null && dishData.dishImage!.isNotEmpty)
                ? Image.network(
              dishData.dishImage!,
              height: height * 0.18,
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : Image.asset(
              AppAssets.recentlyAddedImg,
              height: height * 0.18,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            dishData.dishName,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            dishData.dishCategory,
            style: const TextStyle(
              color: AppColors.textGreyColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            dishData.dishAdditionalInfo ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textGreyColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                "${dishData.dishPrice} L.E",
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false).addToCart(dishData);
                    SnackBarServices.showSuccessMessage('Added to cart');
                  },
                  icon: const Icon(
                    Icons.add,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
