import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Data/seller_available_dish_data_model.dart';


class AvailableDishServices {
  /// Fetches all dishes with images for the current user
  static Future<List<SellerAvailableDishDataModel>> fetchDishesWithImages() async {
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

  /// Fetches the count of active (available) dishes for the current user
  static Future<int> fetchActiveDishesCount() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (uid.isEmpty) return 0;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('dishes')
          .where('isAvailable', isEqualTo: true)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      print("❌ Error fetching active dishes count: $e");
      return 0;
    }
  }

  /// Fetches the total count of orders for the current user
  static Future<int> fetchTotalOrdersCount() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (uid.isEmpty) return 0;

    try {
      final ordersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('orders')
          .get();

      return ordersSnapshot.docs.length;
    } catch (e) {
      print("❌ Error fetching total orders count: $e");
      return 0;
    }
  }

  /// Fetches statistics including active dishes count and total orders count
  static Future<Map<String, int>> fetchStats() async {
    final activeCount = await fetchActiveDishesCount();
    final ordersCount = await fetchTotalOrdersCount();
    return {
      'activeDishes': activeCount,
      'totalOrders': ordersCount,
    };
  }

  /// Updates the availability status of a specific dish
  static Future<void> updateDishAvailability(String dishId, bool isAvailable) async {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('dishes')
          .doc(dishId)
          .update({'isAvailable': isAvailable});
    } catch (e) {
      print("❌ Error updating dish availability: $e");
      rethrow;
    }
  }
}