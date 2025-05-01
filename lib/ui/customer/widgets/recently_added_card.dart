import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Data/recently_added_dish_data_model.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../core/utils/snack_bar_services.dart';
class RecentlyAddedCard extends StatelessWidget {
  RecentlyAddedDishDataModel dishData;

  RecentlyAddedCard({required this.dishData});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.40,
      width: width * 0.40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child:Image.network(
              dishData.dishImage ?? 'https://your-default-image-link.com',
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(AppAssets.recentlyAddedImg); // fallback
              },
              height: height * 0.12,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            dishData.dishName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Row(
            children: [
               Text(
                 "${(dishData.dishPrice ).toStringAsFixed(0)} L.E",
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),),
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
          )
        ],
      ),
    );
  }

}
