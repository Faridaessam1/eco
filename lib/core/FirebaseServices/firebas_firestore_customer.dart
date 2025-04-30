import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Data/restaurant_card_data.dart';

abstract class FireBaseFirestoreServicesCustomer{

  static Future<void> getCustomerProfileData({
    required TextEditingController nameController,
    required TextEditingController phoneController,
    required TextEditingController emailController,
    required VoidCallback onDataLoaded,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;

        nameController.text = data['name'] ;
        phoneController.text = data['phone'];
        emailController.text = data['email'];
        onDataLoaded();
      }
    } catch (e) {
      print("Error fetching customer data: $e");
    }
  }


  static Future<bool> updateCustomerProfile({
    required String name,
    required String phone,
    required String email,
  }) async {
    try {
      var userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        var userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

        var docSnapshot = await userDocRef.get();
        if (!docSnapshot.exists) {
          print("No document found for the current customer.");
          return false;
        }

        await userDocRef.update({
          'name': name,
          'phone': phone,
          'email': email,
        });

        return true;
      }
      return false;
    } catch (e) {
      print('Error updating customer profile: $e');
      return false;
    }
  }

  static Future<List<RestaurantCardData>> getAllRestaurants() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userType', isEqualTo: 'seller')
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return RestaurantCardData.fromFireStore(data);
      }).toList();
    } catch (e) {
      print('Error in getAllRestaurants: $e');
      return [];
    }
  }

  static List<RestaurantCardData> filterRestaurantsByCategory(int selectedIndex, List<RestaurantCardData> restaurantsData) {
    switch (selectedIndex) {
      case 1: // Fast Food tab
        return restaurantsData.where((restaurant) => restaurant.restaurantCategory.contains('Fast Food')).toList();
      case 2: // Hotel tab
        return restaurantsData.where((restaurant) => restaurant.restaurantCategory.contains('Hotel')).toList();
      case 3: // Restaurants tab
        return restaurantsData.where((restaurant) => restaurant.restaurantCategory.contains('Restaurants')).toList();
     case 4: // Desserts tab
        return restaurantsData.where((restaurant) => restaurant.restaurantCategory.contains('Desserts')).toList();
      default: // All tab
        return restaurantsData;
    }
  }

  static Future<List<Map<String, dynamic>>> getDishesForSpecificRestaurant(String restaurantName) async {
    List<Map<String, dynamic>> restaurantDishes = [];

    try {
      // الحصول على جميع البائعين
      var usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userType', isEqualTo: 'seller')
          .get();

      for (var userDoc in usersSnapshot.docs) {
        // التحقق من اسم المطعم
        String fetchedRestaurantName = userDoc['businessName'] ?? 'Unknown Restaurant';

        if (fetchedRestaurantName != restaurantName) continue;

        // الحصول على أطباق هذا المطعم فقط
        var dishesSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .collection('dishes')
            .get();

        for (var dishDoc in dishesSnapshot.docs) {
          if (dishDoc.data().containsKey('dishName') && dishDoc.data().containsKey('dishPrice')) {
            restaurantDishes.add({
              'restaurantId': userDoc.id,
              'restaurantName': fetchedRestaurantName,
              'dishName': dishDoc['dishName'],
              'dishAdditionalInfo': dishDoc['dishAdditionalInfo'],
              'dishPrice': dishDoc['dishPrice'],
              'dishImage': dishDoc['dishImage'] ?? "assets/images/recentlyAddedImg.png",
              'dishQuantity': dishDoc['dishQuantity'],
              'createdAt': dishDoc['createdAt'] ?? Timestamp.now(),
              'dishCategory': dishDoc['dishCategory']
            });

          }
        }
      }
    } catch (e) {
      print("Error fetching dishes: $e");
    }

    return restaurantDishes;
  }


  static Future<List<Map<String, dynamic>>> getRecentlyAddedDishes() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DateTime threeHoursAgo = DateTime.now().subtract(const Duration(hours: 24));
    List<Map<String, dynamic>> recentlyAddedDishes = [];

    try {
      final usersSnapshot = await firestore.collection('users').get();

      for (var userDoc in usersSnapshot.docs) {
        if (userDoc.data()['userType'] == 'seller') {
          final dishesSnapshot = await firestore
              .collection('users')
              .doc(userDoc.id)
              .collection('dishes')
              .where('createdAt', isGreaterThan: Timestamp.fromDate(threeHoursAgo))
              .get();

          for (var dishDoc in dishesSnapshot.docs) {
            recentlyAddedDishes.add(dishDoc.data());
          }
        }
      }

      return recentlyAddedDishes;
    } catch (e) {
      print('Error fetching recently added dishes: $e');
      return [];
    }
  }


}