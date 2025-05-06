import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Data/seller_available_dish_data_model.dart';

class SellerDishesServices {
  static Future<List<SellerAvailableDishDataModel>>
      fetchDishesWithImages() async {
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

  static Future<void> updateDishAvailability(
      String dishId, bool isAvailable) async {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('dishes')
        .doc(dishId)
        .update({'isAvailable': isAvailable});
  }
}
