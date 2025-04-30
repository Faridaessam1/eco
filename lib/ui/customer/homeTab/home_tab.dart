
import 'package:flutter/material.dart';

import '../../../Data/dish_data_model.dart';
import '../../../core/FirebaseServices/firebas_firestore_customer.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/food_item_card.dart';
import '../widgets/recently_added_card.dart';

class HomeTab extends StatefulWidget {
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Future<List<Map<String, dynamic>>>? _recentDishesFuture;

  @override
  void initState() {
    super.initState();
    _recentDishesFuture = FireBaseFirestoreServicesCustomer.getRecentlyAddedDishes(hours: 24); // أو أي رقم حسب ما تحبي
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(AppAssets.appLogo),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Image.asset(
                AppAssets.searchIcon,
                width: 20,
                height: 20,
              )),
          IconButton(
              onPressed: () {},
              icon: Image.asset(
                AppAssets.notificationsIcon,
                width: 20,
                height: 20,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(AppAssets.ad1),
            const Text(
              "Categories",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(AppAssets.fastFoodIcon , height: height * 0.07,),
                    Image.asset(AppAssets.restaurantIcon, height: height * 0.07,),

                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Fast Food",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),),
                    Text("Restaurants",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),),],
                ),


                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(AppAssets.dessertIcon, height: height * 0.07,),
                    Image.asset(AppAssets.hotelsIcon, height: height * 0.07,),

                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Desserts",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),),
                    Text("Hotels",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),),
                  ],
                ),


                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Recently Added",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 30,
            ),


            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _recentDishesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("An Error Occur"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No Recent Dishes"));
                  }
                  final dishes = snapshot.data!;
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: dishes.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      try {
                        final dishModel = DishDataModel.fromFireStore(dishes[index]);

                        // Print the fetched data for debugging
                        print('Fetched dish: ${dishModel.dishName}'); // يمكن طباعة اسم الطبق للتأكد من وصول البيانات

                        return RecentlyAddedCard(dishData: dishModel.toFireStore());
                      } catch (e) {
                        print("Error parsing dish at index $index: $e");
                        return const SizedBox(); // في حال حدوث خطأ، يتم تخطي العنصر
                      }
                    },
                  );

                },
              ),
            )

          ],
        ),
      ),
    );
  }
}
