import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../Data/insights_data_model.dart';
import '../../../Data/order_data_model.dart';
import '../../../core/constants/app_colors.dart';

class SellerHomeServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Fetches recent orders from the last 48 hours
  static Future<List<OrderDataModel>> fetchRecentOrders() async {
    try {
      final userId = _auth.currentUser!.uid;
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      final now = DateTime.now();
      final filteredDocs = querySnapshot.docs.where((doc) {
        final createdAt = (doc['createdAt'] as Timestamp).toDate();
        return now.difference(createdAt).inHours <= 48;
      }).toList();

      return filteredDocs.asMap().entries.map((entry) {
        final index = entry.key;
        final doc = entry.value;
        final data = doc.data();
        final createdAt = (data['createdAt'] as Timestamp).toDate();
        final formattedDate = "${createdAt.day}/${createdAt.month}/${createdAt.year}";

        return OrderDataModel(
          orderNumber: (index + 1).toString(),
          orderStatus: data['orderStatus'] ?? '',
          orderStatusColor: getStatusColor(data['orderStatus']),
          orderItemCount: data['items']?.length.toString() ?? '0',
          orderAmount: data['totalAmount']?.toString() ?? '0.0',
          customerName: data['customerName'] ?? '',
          time: formattedDate,
          id: data['orderId'] ?? '',
          items: [],
        );
      }).toList();
    } catch (e) {
      print('Error fetching recent orders: $e');
      return [];
    }
  }

  /// Fetches business insights including orders, revenue, dishes, and pending orders
  static Future<List<InsightsDataModel>> fetchInsights() async {
    try {
      final userId = _auth.currentUser!.uid;

      // Fetch orders data
      final ordersSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .get();

      final totalOrders = ordersSnapshot.size;
      double revenue = 0;
      int pendingOrders = 0;

      // Calculate revenue and pending orders
      for (var doc in ordersSnapshot.docs) {
        final data = doc.data();
        final amount = data['totalAmount'] ?? 0;
        final status = data['orderStatus'] ?? '';

        revenue += amount is int ? amount.toDouble() : amount;
        if (status.toLowerCase() == 'pending') {
          pendingOrders++;
        }
      }

      // Fetch dishes data
      final dishesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dishes')
          .get();
      final availableDishes = dishesSnapshot.size;

      return [
        InsightsDataModel(
          icon: Icons.shopping_basket_rounded,
          title: "Total Orders",
          value: totalOrders.toString(),
        ),
        InsightsDataModel(
          icon: Icons.attach_money,
          title: "Revenue",
          value: revenue.toStringAsFixed(2),
        ),
        InsightsDataModel(
          icon: Icons.restaurant,
          title: "Available Dishes",
          value: availableDishes.toString(),
        ),
        InsightsDataModel(
          icon: Icons.access_time_filled_rounded,
          title: "Pending Orders",
          value: pendingOrders.toString(),
        ),
      ];
    } catch (e) {
      print("Error fetching insights: $e");
      return [];
    }
  }

  /// Returns color based on order status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.red;
      case 'completed':
        return AppColors.green;
      default:
        return AppColors.grey;
    }
  }

  /// Handles notification button press
  static void handleNotificationPress() {
    // TODO: Implement notification functionality
    print('Notification button pressed');
  }

  /// Handles theme toggle button press
  static void handleThemeToggle() {
    // TODO: Implement theme toggle functionality
    print('Theme toggle button pressed');
  }

}