import 'package:flutter/material.dart';
import '../../../Data/recently_added_dish_data_model.dart';
import '../../../core/FirebaseServices/firebas_firestore_customer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../food_card_widget.dart';

class RestaurantFoodItem extends StatefulWidget {
  const RestaurantFoodItem({Key? key}) : super(key: key);

  @override
  State<RestaurantFoodItem> createState() => _RestaurantFoodItemState();
}

class _RestaurantFoodItemState extends State<RestaurantFoodItem> {
  late String restaurantName;
  late Future<List<Map<String, dynamic>>> futureDishes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get restaurant name from route arguments
    restaurantName = ModalRoute.of(context)?.settings.arguments as String;
    futureDishes = FireBaseFirestoreServicesCustomer.getDishesForSpecificRestaurant(restaurantName);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          restaurantName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.green,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: futureDishes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator()); // Loading data
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}")); // Error handling
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No dishes available")); // No dishes available
            } else {
              var dishes = snapshot.data!;
              return ListView.separated(
                itemCount: dishes.length,
                separatorBuilder: (context, index) => SizedBox(height: height * 0.05),
                itemBuilder: (context, index) {
                
                  final dishData = RecentlyAddedDishDataModel.fromFireStore(
                    dishes[index],
                    dishes[index]['dishId'] ?? '',
                  );

                  // Return the food item widget with the dish data
                  return FoodItemWidget(
                    foodData: dishData,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}