import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Data/complete_order_data_model.dart';
import '../../Data/food_card_in_cart_tab_data.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new order and save it to both customer and seller subcollections
  Future<String> createOrder({
    required String customerId,
    required String sellerId,
    required String customerName,
    String? customerAddress,
    String? customerPhone,
    required List<FoodCardInCartTabData> cartItems,
    required Map<String, String> dishIdMap, // Map of dishName to dishId
    required double subtotal,
    required double serviceFee,
    required double tax,
    required double totalAmount,
    required String paymentMethod,
    required String orderType,
  }) async {
    try {
      // Generate a unique order ID
      final String orderId = _firestore.collection('orders').doc().id;

      // Convert cart items to order items
      List<OrderItemModel> orderItems = cartItems.map((item) {
        return OrderItemModel.fromCartItem(
            item,
            dishIdMap[item.foodName] ?? '' // Get dishId from the map
        );
      }).toList();

      // Create the order model
      final CompleteOrderDataModel order = CompleteOrderDataModel(
        orderId: orderId,
        customerId: customerId,
        sellerId: sellerId,
        customerName: customerName,
        customerAddress: customerAddress,
        customerPhone: customerPhone,
        items: orderItems,
        subtotal: subtotal,
        serviceFee: serviceFee,
        tax: tax,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        orderStatus: 'pending',
        orderType: orderType,
        createdAt: Timestamp.now(),
      );

      // Save order to customer's orders subcollection
      await _firestore
          .collection('users')
          .doc(customerId)
          .collection('orders')
          .doc(orderId)
          .set(order.toFirestore());

      // Save the same order to seller's orders subcollection
      await _firestore
          .collection('users')
          .doc(sellerId)
          .collection('orders')
          .doc(orderId)
          .set(order.toFirestore());
      print("Creating order with sellerId: $sellerId");
      // Optional: Create a general orders collection for admin purposes
      await _firestore
          .collection('orders')
          .doc(orderId)
          .set(order.toFirestore());

      return orderId;
    } catch (e) {
      debugPrint('Error creating order: $e');
      throw Exception('Failed to create order: $e');
    }
  }

  // Update order status - Updates in both customer and seller subcollections
  Future<void> updateOrderStatus({
    required String orderId,
    required String customerId,
    required String sellerId,
    required String newStatus,
  }) async {
    final Timestamp now = Timestamp.now();

    try {
      // Update in customer's subcollection
      await _firestore
          .collection('users')
          .doc(customerId)
          .collection('orders')
          .doc(orderId)
          .update({
        'orderStatus': newStatus,
        'updatedAt': now,
      });

      // Update in seller's subcollection
      await _firestore
          .collection('users')
          .doc(sellerId)
          .collection('orders')
          .doc(orderId)
          .update({
        'orderStatus': newStatus,
        'updatedAt': now,
      });

      // Update in main orders collection
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({
        'orderStatus': newStatus,
        'updatedAt': now,
      });
    } catch (e) {
      debugPrint('Error updating order status: $e');
      throw Exception('Failed to update order status: $e');
    }
  }

  // Get customer orders as a stream
  Stream<List<CompleteOrderDataModel>> getCustomerOrders(String customerId) {
    return _firestore
        .collection('users')
        .doc(customerId)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CompleteOrderDataModel.fromFirestore(doc))
        .toList());
  }

  // Get seller orders as a stream
  Stream<List<CompleteOrderDataModel>> getSellerOrders(String sellerId) {
    return _firestore
        .collection('users')
        .doc(sellerId)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CompleteOrderDataModel.fromFirestore(doc))
        .toList());
  }

  // Get a specific order
  Future<CompleteOrderDataModel?> getOrder(String userId, String orderId, {required String userType}) async {
    // Based on userType, we'll fetch from the appropriate subcollection
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('orders')
        .doc(orderId)
        .get();

    if (doc.exists) {
      return CompleteOrderDataModel.fromFirestore(doc);
    }
    return null;
  }

  // Get orders by status for a customer
  Stream<List<CompleteOrderDataModel>> getCustomerOrdersByStatus(String customerId, String status) {
    return _firestore
        .collection('users')
        .doc(customerId)
        .collection('orders')
        .where('orderStatus', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CompleteOrderDataModel.fromFirestore(doc))
        .toList());
  }

  // Get orders by status for a seller
  Stream<List<CompleteOrderDataModel>> getSellerOrdersByStatus(String sellerId, String status) {
    return _firestore
        .collection('users')
        .doc(sellerId)
        .collection('orders')
        .where('orderStatus', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CompleteOrderDataModel.fromFirestore(doc))
        .toList());
  }
}