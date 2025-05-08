import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Data/recently_added_dish_data_model.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../core/utils/snack_bar_services.dart';

class FoodItemWidget extends StatelessWidget {
  final RecentlyAddedDishDataModel foodData;

  const FoodItemWidget({
    Key? key,
    required this.foodData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get CartProvider from Provider
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.white,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16), // زيادة المسافة العمودية
                ),
                onPressed: () {
                  // Check if seller ID exists in the food data
                  if (foodData.sellerId == null || foodData.sellerId!.isEmpty) {
                    SnackBarServices.showErrorMessage("Error: This item has no seller information");
                    print("ERROR: Dish ${foodData.dishName} has no seller ID");
                    return;
                  }

                  // Add the dish directly to cart using the updated CartProvider method
                  cartProvider.addToCart(
                    foodData,
                    quantity: 1,
                  );

                  // Show success message
                  SnackBarServices.showSuccessMessage("${foodData.dishName} added to cart");
                },
                child: const Text("Add to Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}