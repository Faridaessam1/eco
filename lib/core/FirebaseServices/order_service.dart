import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

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
      // Validate customer name - apply fallback if null or empty
      if (customerName.isEmpty) {
        print("WARNING: Customer name is empty, using 'Unknown Customer'");
        customerName = "Unknown Customer";
      }

      // Fetch seller name if not already provided
      String sellerName = "Unknown Restaurant";
      try {
        // Try sellers collection first
        final sellerDoc = await _firestore.collection('sellers').doc(sellerId).get();
        if (sellerDoc.exists) {
          final sellerData = sellerDoc.data() as Map<String, dynamic>;
          sellerName = sellerData['businessName'] ?? sellerData['name'] ?? sellerName;
          print("Fetched seller name from sellers collection: $sellerName");
        } else {
          // Try users collection as fallback
          final userDoc = await _firestore.collection('users').doc(sellerId).get();
          if (userDoc.exists) {
            final userData = userDoc.data() as Map<String, dynamic>;
            sellerName = userData['businessName'] ?? userData['name'] ?? sellerName;
            print("Fetched seller name from users collection: $sellerName");
          } else {
            print("WARNING: Seller document not found in either collection");
          }
        }
      } catch (e) {
        print("Error fetching seller name: $e");
        // Continue with default seller name
      }

      // Generate a unique order ID
      final String orderId = _firestore.collection('orders').doc().id;
      print("Generated Order ID: $orderId");

      // Convert cart items to order items
      List<OrderItemModel> orderItems = cartItems.map((item) {
        String dishId = dishIdMap[item.foodName] ?? '';
        print("Mapping cart item: ${item.foodName} -> Dish ID: $dishId");
        return OrderItemModel.fromCartItem(item, dishId);
      }).toList();

      print("Converted ${orderItems.length} items to OrderItemModel");

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
        sellerName: sellerName,
      );

      print("Created order model with ID: ${order.orderId}");

      final Map<String, dynamic> orderData = order.toFirestore();
      print("Order data for Firestore - sellerId value: ${orderData['uid']}");
      print("Order data for Firestore - all keys: ${orderData.keys.toList()}");

      // Save to customer's orders subcollection
      try {
        await _firestore.collection('users').doc(customerId).collection('orders').doc(orderId).set(orderData);
        print("Successfully saved to customer's orders subcollection");
      } catch (e) {
        print("ERROR saving to customer's orders subcollection: $e");
        throw Exception('Failed to save order to customer data: $e');
      }

      // Save to seller's orders subcollection
      try {
        await _firestore.collection('users').doc(sellerId).collection('orders').doc(orderId).set(orderData);
        print("Successfully saved to seller's orders subcollection");
      } catch (e) {
        print("ERROR saving to seller's orders subcollection: $e");
        // Don't throw here, we'll try to save to main collection anyway
      }

      // Save to main orders collection
      try {
        await _firestore.collection('orders').doc(orderId).set(orderData);
        print("Successfully saved to main orders collection");
      } catch (e) {
        print("ERROR saving to main orders collection: $e");
        throw Exception('Failed to save order to main collection: $e');
      }

      print("===== ORDER SERVICE: COMPLETED CREATE ORDER =====");
      return orderId;
    } catch (e) {
      print("CRITICAL ERROR in createOrder: $e");
      debugPrint('Error creating order: $e');
      throw Exception('Failed to create order: $e');
    }
  }

  // Rest of the code remains the same...
  // Update order status - Updates in both customer and seller subcollections
  Future<void> updateOrderStatus({
    required String orderId,
    required String customerId,
    required String sellerId,
    required String newStatus,
  }) async {
    final Timestamp now = Timestamp.now();
    print("===== UPDATE ORDER STATUS =====");
    print("Order ID: $orderId");
    print("Customer ID: $customerId");
    print("Seller ID: $sellerId");
    print("New Status: $newStatus");

    try {
      // Update in customer's subcollection
      print("Updating in customer subcollection");
      await _firestore
          .collection('users')
          .doc(customerId)
          .collection('orders')
          .doc(orderId)
          .update({
        'orderStatus': newStatus,
        'updatedAt': now,
      });
      print("Successfully updated in customer subcollection");

      // Update in seller's subcollection
      print("Updating in seller subcollection");
      try {
        await _firestore
            .collection('users')
            .doc(sellerId)
            .collection('orders')
            .doc(orderId)
            .update({
          'orderStatus': newStatus,
          'updatedAt': now,
        });
        print("Successfully updated in seller subcollection");
      } catch (e) {
        print("ERROR updating seller subcollection: $e");
      }

      // Update in main orders collection
      print("Updating in main orders collection");
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({
        'orderStatus': newStatus,
        'updatedAt': now,
      });
      print("Successfully updated in main orders collection");
      print("===== UPDATE ORDER STATUS COMPLETED =====");
    } catch (e) {
      print("CRITICAL ERROR in updateOrderStatus: $e");
      debugPrint('Error updating order status: $e');
      throw Exception('Failed to update order status: $e');
    }
  }

  // Get customer orders as a stream
  Stream<List<CompleteOrderDataModel>> getCustomerOrders(String customerId) {
    print("Getting customer orders for: $customerId");
    return _firestore
        .collection('users')
        .doc(customerId)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      print("Customer orders snapshot size: ${snapshot.docs.length}");
      return snapshot.docs
          .map((doc) => CompleteOrderDataModel.fromFirestore(doc))
          .toList();
    });
  }

  // Get seller orders as a stream
  Stream<List<CompleteOrderDataModel>> getSellerOrders(String sellerId) {
    print("Getting seller orders for: $sellerId");
    return _firestore
        .collection('users')
        .doc(sellerId)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      print("Seller orders snapshot size: ${snapshot.docs.length}");
      return snapshot.docs
          .map((doc) => CompleteOrderDataModel.fromFirestore(doc))
          .toList();
    });
  }

  // Get a specific order
  Future<CompleteOrderDataModel?> getOrder(String userId, String orderId, {required String userType}) async {
    print("Getting order: $orderId for $userType with ID: $userId");
    // Based on userType, we'll fetch from the appropriate subcollection
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('orders')
        .doc(orderId)
        .get();

    if (doc.exists) {
      print("Order document exists");
      return CompleteOrderDataModel.fromFirestore(doc);
    }
    print("Order document does NOT exist");
    return null;
  }

  // Get orders by status for a customer
  Stream<List<CompleteOrderDataModel>> getCustomerOrdersByStatus(String customerId, String status) {
    print("Getting customer orders by status: $status for customer: $customerId");
    return _firestore
        .collection('users')
        .doc(customerId)
        .collection('orders')
        .where('orderStatus', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      print("Customer orders by status snapshot size: ${snapshot.docs.length}");
      return snapshot.docs
          .map((doc) => CompleteOrderDataModel.fromFirestore(doc))
          .toList();
    });
  }

  // Get orders by status for a seller
  Stream<List<CompleteOrderDataModel>> getSellerOrdersByStatus(String sellerId, String status) {
    print("Getting seller orders by status: $status for seller: $sellerId");
    return _firestore
        .collection('users')
        .doc(sellerId)
        .collection('orders')
        .where('orderStatus', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      print("Seller orders by status snapshot size: ${snapshot.docs.length}");
      return snapshot.docs
          .map((doc) => CompleteOrderDataModel.fromFirestore(doc))
          .toList();
    });
  }

  // Add a repair function to check and fix missing seller orders
  Future<void> repairMissingSellerOrders(String sellerId) async {
    print("===== REPAIRING MISSING SELLER ORDERS =====");
    print("Seller ID: $sellerId");

    try {
      // First, get all orders from the main orders collection that have this sellerId
      print("Querying main orders collection for this seller");
      final querySnapshot = await _firestore
          .collection('orders')
          .where('uid', isEqualTo: sellerId)
          .get();

      print("Found ${querySnapshot.docs.length} orders in main collection for seller");

      // For each order, ensure it exists in the seller's subcollection
      int fixedCount = 0;
      for (var doc in querySnapshot.docs) {
        final orderId = doc.id;
        final orderData = doc.data();

        print("Checking order $orderId in seller's subcollection");

        // Check if this order exists in seller's subcollection
        final sellerOrderDoc = await _firestore
            .collection('users')
            .doc(sellerId)
            .collection('orders')
            .doc(orderId)
            .get();

        // If it doesn't exist, copy it from the main collection
        if (!sellerOrderDoc.exists) {
          print("Order $orderId NOT found in seller subcollection - repairing");
          await _firestore
              .collection('users')
              .doc(sellerId)
              .collection('orders')
              .doc(orderId)
              .set(orderData);
          print("Repaired order $orderId for seller $sellerId");
          fixedCount++;
        } else {
          print("Order $orderId already exists in seller subcollection");
        }
      }

      print("Repair complete. Fixed $fixedCount orders for seller $sellerId");
      print("===== REPAIR COMPLETED =====");
    } catch (e) {
      print("ERROR repairing seller orders: $e");
      throw Exception('Failed to repair seller orders: $e');
    }
  }
}