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
  }

  late Future<List<Map<String, dynamic>>> futureDishes;
  @override
  void initState() {
    super.initState();
    futureDishes = FireBaseFirestoreServicesCustomer.getAllDishesForRestaurants(); // استدعاء الـ function اللي بتجيب الأطباق
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
              return ListView.separated(
                itemCount: (dishes.length / 2).ceil(),
                separatorBuilder: (context, index) => SizedBox(height: height * 0.05),
                itemBuilder: (context, index) {
                  int firstIndex = index * 2;
                  int secondIndex = firstIndex + 1;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: FoodItemCard(
                          dishData: DishDataModel.fromFireStore(dishes[firstIndex]),// عرض الطبق الأول
                        ),
                      ),
                      SizedBox(width: width * 0.08),
                      if (secondIndex < dishes.length) // التحقق من وجود طبق ثاني
                        Expanded(
                          child: FoodItemCard(
                              dishData: DishDataModel.fromFireStore(dishes[secondIndex]), // عرض الطبق الثاني
                          ),
                        ),
                    ],
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


