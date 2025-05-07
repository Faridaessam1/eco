import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Data/food_card_in_cart_tab_data.dart';
import '../../Data/order_data_model.dart';
import 'package:uuid/uuid.dart';

class OrderService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String usersCollection = 'users';
  static const String ordersCollection = 'orders';

  // Create a new order and save it to both customer and seller subcollections
  static Future<String> createOrder({
    required String customerId,
    required String sellerId,
    required String customerName,
    required String? customerAddress,
    required List<FoodCardInCartTabData> orderItems,
    required double subtotal,
    required double serviceFees,
    required double tax,
    required double totalAmount,
    required String paymentMethod,
  }) async {
    try {
      // Generate a unique order ID
      final String orderId = const Uuid().v4();
      final Timestamp timestamp = Timestamp.now();
      final String formattedTime = _formatTimestamp(timestamp);

      // Count total items
      int totalItemCount = 0;
      for (var item in orderItems) {
        totalItemCount += item.foodQuantity;
      }

      // Create the order model
      final OrderDataModel orderData = OrderDataModel(
        orderNumber: orderId,
        orderStatus: "Pending",
        orderStatusColor: Colors.orange,
        orderItemCount: totalItemCount.toString(),
        orderDetails: _generateOrderDetails(orderItems),
        orderAmount: totalAmount.toStringAsFixed(2),
        customerName: customerName,
        customerAddress: customerAddress,
        time: formattedTime,
      );

      // Convert order data to Map
      final Map<String, dynamic> orderMap = orderData.toFireStore();

      // Add additional order information
      final Map<String, dynamic> extendedOrderData = {
        ...orderMap,
        'customerId': customerId,
        'sellerId': sellerId,
        'orderItems': _convertOrderItemsToMap(orderItems),
        'subtotal': subtotal,
        'serviceFees': serviceFees,
        'tax': tax,
        'totalAmount': totalAmount,
        'paymentMethod': paymentMethod,
        'createdAt': timestamp,
      };

      // Save to customer's orders subcollection
      await _firestore
          .collection("users")
          .doc(customerId)
          .collection("orders")
          .doc(orderId)
          .set(extendedOrderData);

      // Save to seller's orders subcollection
      await _firestore
          .collection("users")
          .doc(sellerId)
          .collection("orders")
          .doc(orderId)
          .set(extendedOrderData);

      return orderId;
    } catch (e) {
      print('Error creating order: $e');
      throw Exception('Failed to create order: $e');
    }
  }

  // Get orders for a specific user (works for both customer and seller)
  static Stream<QuerySnapshot> getOrders(String userId) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(ordersCollection)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Update order status (will update in both customer and seller subcollections)
  static Future<void> updateOrderStatus({
    required String orderId,
    required String customerId,
    required String sellerId,
    required String newStatus,
    required Color newStatusColor,
  }) async {
    try {
      final Map<String, dynamic> updateData = {
        'orderStatus': newStatus,
        'orderStatusColor': newStatusColor.value,
        'updatedAt': Timestamp.now(),
      };

      // Update in customer's subcollection
      await _firestore
          .collection(usersCollection)
          .doc(customerId)
          .collection(ordersCollection)
          .doc(orderId)
          .update(updateData);

      // Update in seller's subcollection
      await _firestore
          .collection(usersCollection)
          .doc(sellerId)
          .collection(ordersCollection)
          .doc(orderId)
          .update(updateData);
    } catch (e) {
      print('Error updating order status: $e');
      throw Exception('Failed to update order status: $e');
    }
  }

  // Helper method to format timestamp to a readable string
  static String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Helper method to generate order details summary
  static String _generateOrderDetails(List<FoodCardInCartTabData> items) {
    List<String> details = [];
    for (var item in items) {
      details.add('${item.foodQuantity}x ${item.foodName}');
    }
    return details.join(', ');
  }

  // Helper method to convert order items to a map for Firestore
  static List<Map<String, dynamic>> _convertOrderItemsToMap(List<FoodCardInCartTabData> items) {
    return items.map((item) => {
      'foodName': item.foodName,
      'foodPrice': item.foodPrice,
      'foodQuantity': item.foodQuantity,
      'foodImgPath': item.foodImgPath,
      'totalItemPrice': item.foodPrice * item.foodQuantity,
    }).toList();
  }
}