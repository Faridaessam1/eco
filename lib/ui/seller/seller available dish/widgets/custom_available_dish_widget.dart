import 'package:flutter/material.dart';

import '../../../../Data/seller_available_dish_data_model.dart';
import '../../../../core/constants/app_colors.dart';

class CustomAvailableDishWidget extends StatelessWidget {
  final SellerAvailableDishDataModel availableDishDataModel;
  final bool isAvailable;
  final Function(bool) onToggle;

  const CustomAvailableDishWidget({
    super.key,
    required this.availableDishDataModel,
    required this.isAvailable,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Container(
      width: mediaQuery.size.width * 0.917,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightMint,
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Space out the children
        children: [
          Image.network(
            availableDishDataModel.dishImage,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 15),
          Expanded(
            // Use Expanded to take available space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  availableDishDataModel.dishName,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${double.parse(availableDishDataModel.dishPrice).toStringAsFixed(2)} EGP",
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () {
                  // Add edit functionality here
                },
              ),
              Switch(
                value: isAvailable,
                onChanged: onToggle,
                activeColor: AppColors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
