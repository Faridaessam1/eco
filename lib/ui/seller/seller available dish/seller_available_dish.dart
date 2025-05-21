import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_eaters_app_3/core/routes/app_routes.dart';
import 'package:eco_eaters_app_3/ui/seller/seller%20available%20dish/widgets/custom_available_dish_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Data/seller_available_dish_data_model.dart';
import '../../../core/routes/page_route_names.dart';
import '../../../core/seller services/seller_available_dish_services.dart';
import '../../../core/constants/app_colors.dart';

class SellerAvailableDish extends StatefulWidget {
  const SellerAvailableDish({super.key});

  @override
  State<SellerAvailableDish> createState() => _SellerAvailableDishState();
}

class _SellerAvailableDishState extends State<SellerAvailableDish> {
  late Future<List<SellerAvailableDishDataModel>> _dishesFuture;
  int totalOrders = 156; // Sample data for total orders
  int activeDishes = 24; // Sample data for active dishes

  @override
  void initState() {
    super.initState();
    _dishesFuture = SellerDishesServices.fetchDishesWithImages();
  }

  Future<List<SellerAvailableDishDataModel>> fetchDishesWithImages() async {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    print("👤 Current UID: $uid");

    List<SellerAvailableDishDataModel> finalDishes = [];

    try {
      final userDishesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('dishes')
          .get();

      for (var doc in userDishesSnapshot.docs) {
        final dishData = doc.data();
        final dishImage = dishData['dishImage'] ?? '';

        if (dishImage.toString().trim().isNotEmpty) {
          final dishModel = SellerAvailableDishDataModel(
            id: doc.id,
            dishImage: dishImage,
            dishName: dishData['dishName'] ?? 'No name',
            dishPrice: dishData['dishPrice']?.toString() ?? '0',
            isAvailable: dishData['isAvailable'] ?? true,
          );
          finalDishes.add(dishModel);
        }
      }
    } catch (e) {
      print("❌ Error fetching dishes: $e");
    }

    return finalDishes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Eco Eaters",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_upward, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats section
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Active Dishes stats
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Active Dishes",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$activeDishes",
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Total Orders stats
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Total Orders",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$totalOrders",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Your Dishes section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Your Dishes",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context,PagesRouteName.sellerNewDishScreen);
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("Add New", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Dishes list
          Expanded(
            child: FutureBuilder<List<SellerAvailableDishDataModel>>(
              future: _dishesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No available dishes"));
                }

                final dishes = snapshot.data!;

                return ListView.builder(
                  itemCount: dishes.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final dish = dishes[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CustomAvailableDishWidget(
                        availableDishDataModel: dish,
                        isAvailable: dish.isAvailable,
                        onToggle: (newValue) async {
                          setState(() {
                            dish.isAvailable = newValue;
                          });
                          await SellerDishesServices.updateDishAvailability(
                              dish.id, newValue);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Bottom navigation bar
        ],
      ),
    );
  }

}