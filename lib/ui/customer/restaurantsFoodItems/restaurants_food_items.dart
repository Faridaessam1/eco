import 'package:flutter/material.dart';
import '../../../Data/dish_data_model.dart';
import '../../../core/FirebaseServices/firebas_firestore_customer.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/food_item_card.dart';

class RestaurantFoodItem extends StatefulWidget {

  @override
  State<RestaurantFoodItem> createState() => _RestaurantFoodItemState();
}

class _RestaurantFoodItemState extends State<RestaurantFoodItem> {
  late String restaurantName;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    restaurantName = ModalRoute.of(context)?.settings.arguments as String;  // استقبال اسم المطعم
    futureDishes = FireBaseFirestoreServicesCustomer.getDishesForSpecificRestaurant(restaurantName);

  }
  late Future<List<Map<String, dynamic>>> futureDishes;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantName,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.green,
        ),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: futureDishes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator()); // انتظار البيانات
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}")); // في حال حدوث خطأ
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No dishes available")); // في حال مفيش أطباق
            } else {
              var dishes = snapshot.data!;
              print(dishes);
              return ListView.separated(
                itemCount: dishes.length, // العدد الكلي للأطباق
                separatorBuilder: (context, index) => SizedBox(height: height * 0.05), // المسافة بين كل طبق
                itemBuilder: (context, index) {
                  return FoodItemCard(
                    dishData: DishDataModel.fromFireStore(dishes[index]), // عرض الطبق
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


