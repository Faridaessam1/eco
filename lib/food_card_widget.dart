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
            // Food image and other elements would be here...

            // Add to cart button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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