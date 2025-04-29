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
      case 3: // Desserts tab
        return restaurantsData.where((restaurant) => restaurant.restaurantCategory.contains('Desserts')).toList();
      default: // All tab
        return restaurantsData;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllDishesForRestaurants() async {
    List<Map<String, dynamic>> allDishes = [];

    try {
      // الحصول على جميع المستخدمين الذين هم بائعين
      var usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userType', isEqualTo: 'seller') // تصفية البائعين فقط
          .get();

      for (var userDoc in usersSnapshot.docs) {
        String restaurantName = userDoc.exists ? userDoc['businessName'] : 'Unknown Restaurant'; // اسم المطعم من بيانات المستخدم

        // الحصول على dishes من الـ sub-collection لكل بائع
        var dishesSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .collection('dishes')
            .get();

        for (var dishDoc in dishesSnapshot.docs) {
          // تحقق من وجود الحقول الأساسية
          if (dishDoc.data().containsKey('dishName') && dishDoc.data().containsKey('dishPrice')) {
            allDishes.add({
              'restaurantId': userDoc.id,
              'restaurantName': restaurantName, // افترض أن اسم المطعم مخزن في حقل "name"
              'dishName': dishDoc['dishName'] ?? 'Unknown Dish', // اسم الطبق
              'dishDescription': dishDoc['dishAdditionalInfo'] ?? 'No description', // وصف الطبق (إذا كان موجودًا)
              'dishPrice': dishDoc['dishPrice'] ?? 0, // سعر الطبق (يجب التأكد أنه ليس null)
              'dishImage': dishDoc['dishImage'] ?? "assets/images/recentlyAddedImg.png", // صورة الطبق (إذا كانت موجودة أو فارغة)
              'dishQuantity': dishDoc['dishQuantity'] ?? 1, // كمية الطبق (افترض 1 إذا كانت فارغة)
              'createdAt': dishDoc['createdAt'] ?? Timestamp.now(), // تاريخ إنشاء الطبق (إذا كان فارغًا أضف الوقت الحالي
            });
          } else {
            print("Missing required field in dish document: ${dishDoc.id}");
          }
        }
      }
    } catch (e) {
      print("Error fetching dishes: $e");
    }

    return allDishes;
  }

}