import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Data/recently_added_dish_data_model.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../core/utils/snack_bar_services.dart';

class RecentlyAddedCard extends StatelessWidget {
  final RecentlyAddedDishDataModel dishData;

  const RecentlyAddedCard({super.key, required this.dishData});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.40,
      width: width * 0.40,
      padding: const EdgeInsets.all(8), // Add padding to prevent edge overflow
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Change from center to start
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section with flexible height
          Expanded(
            flex: 3, // Takes 3/5 of available space
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                dishData.dishImage ?? 'https://your-default-image-link.com',
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(AppAssets.recentlyAddedImg); // fallback
                },
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 8), // Fixed spacing

          // Dish name section
          Expanded(
            flex: 1, // Takes 1/5 of available space
            child: Text(
              dishData.dishName,
              maxLines: 2, // Allow 2 lines for longer names
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 14, // Slightly smaller font
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Price and add button section
          Expanded(
            flex: 1, // Takes 1/5 of available space
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${(dishData.dishPrice).toStringAsFixed(0)} L.E",
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 14, // Slightly smaller font
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8), // Space between price and button
                Container(
                  width: 32, // Fixed width for button
                  height: 32, // Fixed height for button
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero, // Remove default padding
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false).addToCart(dishData);
                      SnackBarServices.showSuccessMessage('Added to cart');
                    },
                    icon: const Icon(
                      Icons.add,
                      color: AppColors.black,
                      size: 18, // Smaller icon
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}