import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
class RecentlyAddedCard extends StatelessWidget {
  final Map<String, dynamic> dishData;

  RecentlyAddedCard({required this.dishData});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.15,
      width: width * 0.30,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(AppAssets.recentlyAddedImg,
              height: height * 0.10,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            dishData["dishName"] ?? "no name",
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
                 "${(dishData["dishPrice"] as double).toStringAsFixed(0)} L.E",
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
                    // Provider.of<CartProvider>(context, listen: false).addToCart(dishData as DishDataModel);
                    // SnackBarServices.showSuccessMessage('Added to cart');
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
