import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Data/recently_added_dish_data_model.dart';
import '../../../core/FirebaseServices/firebas_firestore_customer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../core/utils/snack_bar_services.dart';
import '../cartTab/cart_tab.dart';

class RestaurantFoodItem extends StatefulWidget {
  const RestaurantFoodItem({Key? key}) : super(key: key);

  @override
  State<RestaurantFoodItem> createState() => _RestaurantFoodItemState();
}

class _RestaurantFoodItemState extends State<RestaurantFoodItem> {
  late String restaurantName;
  late Future<List<Map<String, dynamic>>> futureDishes;
  bool isFavorite = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get restaurant name from route arguments
    restaurantName = ModalRoute.of(context)?.settings.arguments as String;
    futureDishes = FireBaseFirestoreServicesCustomer.getDishesForSpecificRestaurant(restaurantName);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  // Header with back button and favorite
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black12, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              restaurantName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Menu items grid
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: futureDishes,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("No dishes available"));
                        } else {
                          var dishes = snapshot.data!;
                          return GridView.builder(
                            padding: const EdgeInsets.all(8),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: dishes.length,
                            itemBuilder: (context, index) {
                              final dishData = RecentlyAddedDishDataModel.fromFireStore(
                                dishes[index],
                                dishes[index]['dishId'] ?? '',
                              );

                              return _buildFoodItemCard(dishData, cartProvider);
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Cart button at bottom
          if (cartProvider.cartItems.isNotEmpty)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartTab()),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "View Cart (${cartProvider.cartItems.length} items)",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "\$${cartProvider.subtotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFoodItemCard(RecentlyAddedDishDataModel dish, CartProvider cartProvider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: (dish.dishImage != null && dish.dishImage!.isNotEmpty)
                ? Image.network(
              dish.dishImage!,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print("Error loading image: $error");
                return Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
            )
                : Container(
              height: 100,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(Icons.restaurant, color: Colors.grey),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Text(
              dish.dishName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              dish.dishAdditionalInfo ?? '',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const Spacer(),

          // Price and Add button
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${dish.dishPrice} L.E",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Add to cart
                    if (dish.sellerId == null || dish.sellerId!.isEmpty) {
                      SnackBarServices.showErrorMessage("Error: This item has no seller information");
                      return;
                    }

                    cartProvider.addToCart(
                      dish,
                      quantity: 1,
                    );

                    SnackBarServices.showSuccessMessage("${dish.dishName} added to cart");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 18,
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