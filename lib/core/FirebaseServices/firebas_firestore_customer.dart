import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Data/recently_added_dish_data_model.dart';
import '../../Data/restaurant_card_data.dart';

abstract class FireBaseFirestoreServicesCustomer {

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

        // Updated to handle both naming conventions for consistency
        nameController.text = data['name'] ?? data['fullName'] ?? '';
        phoneController.text = data['phone'] ?? '';
        emailController.text = data['email'] ?? '';
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
          'fullName': name, // Adding both field names for consistency
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

  static Future<List<RestaurantCardData>> getRestaurantsByCategory(
      String category) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userType', isEqualTo: 'seller')
          .where('businessType', isEqualTo: category)
          .get();

      print("Category being queried: $category");
      print("Number of documents found: ${snapshot.docs.length}");
      snapshot.docs.forEach((doc) {
        print("Document data: ${doc.data()}");
      });

      if (snapshot.docs.isEmpty) {
        print("No restaurants found in category: $category");
      }

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return RestaurantCardData.fromFireStore(data);
      }).toList();
    } catch (e) {
      print('Error fetching restaurants by category: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getDishesForSpecificRestaurant(String restaurantName) async {
    List<Map<String, dynamic>> restaurantDishes = [];

    try {
      // Get all sellers
      var usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userType', isEqualTo: 'seller')
          .get();

      for (var userDoc in usersSnapshot.docs) {
        // Check restaurant name
        String fetchedRestaurantName = userDoc['businessName'] ?? 'Unknown Restaurant';

        if (fetchedRestaurantName != restaurantName) continue;

        // Get dishes for this restaurant only
        var dishesSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .collection('dishes')
            .get();

        for (var dishDoc in dishesSnapshot.docs) {
          if (dishDoc.data().containsKey('dishName') && dishDoc.data().containsKey('dishPrice')) {
            restaurantDishes.add({
              'dishId': dishDoc.id, // Include the document ID as dishId
              'restaurantId': userDoc.id,
              'restaurantName': fetchedRestaurantName,
              'dishName': dishDoc['dishName'],
              'dishAdditionalInfo': dishDoc['dishAdditionalInfo'],
              'dishPrice': dishDoc['dishPrice'],
              'dishImage': dishDoc['dishImage'] ?? "assets/images/recentlyAddedImg.png",
              'dishQuantity': dishDoc['dishQuantity'],
              'createdAt': dishDoc['createdAt'] ?? Timestamp.now(),
              'dishCategory': dishDoc['dishCategory'],
              'sellerId': userDoc.id, // Include sellerId consistently
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching dishes: $e");
    }

    return restaurantDishes;
  }

  static Future<List<RecentlyAddedDishDataModel>> getRecentlyAddedDishes() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DateTime twoHoursAgo = DateTime.now().subtract(const Duration(hours: 48));
    List<RecentlyAddedDishDataModel> recentlyAddedDishes = [];

    try {
      final usersSnapshot = await firestore.collection('users').get();

      for (var userDoc in usersSnapshot.docs) {
        if (userDoc.data()['userType'] == 'seller') {
          final dishesSnapshot = await firestore
              .collection('users')
              .doc(userDoc.id)
              .collection('dishes')
              .where('createdAt', isGreaterThan: Timestamp.fromDate(twoHoursAgo))
              .get();

          for (var dishDoc in dishesSnapshot.docs) {
            Map<String, dynamic> dishData = dishDoc.data();
            // Make sure sellerId is included in the data
            if (!dishData.containsKey('sellerId') && !dishData.containsKey('uid')) {
              dishData['sellerId'] = userDoc.id;
            }
            // Create model with correct parameters
            recentlyAddedDishes.add(
                RecentlyAddedDishDataModel.fromFireStore(dishData, dishDoc.id)
            );
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