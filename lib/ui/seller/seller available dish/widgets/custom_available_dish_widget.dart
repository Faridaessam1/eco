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
    return Opacity(
      opacity: isAvailable ? 1.0 : 0.5, // Make unavailable dishes semi-transparent
      child: Container(
        decoration: BoxDecoration(
          color: isAvailable ? Colors.white : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isAvailable ? Colors.grey[200]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dish image with overlay if unavailable
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          child: Image.network(
                            availableDishDataModel.dishImage,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (!isAvailable)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "UNAVAILABLE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    // Dish details
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    availableDishDataModel.dishName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: isAvailable ? Colors.black : Colors.grey[600],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      size: 18,
                                      color: isAvailable ? Colors.black : Colors.grey[400],
                                    ),
                                    onPressed: isAvailable ? () {
                                      // Edit functionality
                                    } : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${double.parse(availableDishDataModel.dishPrice).toStringAsFixed(2)} EGP",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isAvailable ? Colors.black : Colors.grey[600],
                                  ),
                                ),
                                Switch(
                                  value: isAvailable,
                                  onChanged: onToggle,
                                  activeColor: AppColors.primaryColor,
                                  activeTrackColor: Colors.green.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}