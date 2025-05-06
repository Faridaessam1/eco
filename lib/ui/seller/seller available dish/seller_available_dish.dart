import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_eaters_app_3/ui/seller/seller%20available%20dish/widgets/custom_available_dish_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Data/seller_available_dish_data_model.dart';
import '../../../core/seller services/seller_available_dish_services.dart';

class SellerAvailableDish extends StatefulWidget {
  const SellerAvailableDish({super.key});

  @override
  State<SellerAvailableDish> createState() => _SellerAvailableDishState();
}

class _SellerAvailableDishState extends State<SellerAvailableDish> {
  late Future<List<SellerAvailableDishDataModel>> _dishesFuture;

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

  Future<void> updateDishAvailability(String dishId, bool isAvailable) async {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('dishes')
        .doc(dishId)
        .update({'isAvailable': isAvailable});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EcoEaters"),
      ),
      body: FutureBuilder<List<SellerAvailableDishDataModel>>(
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
            itemBuilder: (context, index) {
              final dish = dishes[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
    );
  }
}
