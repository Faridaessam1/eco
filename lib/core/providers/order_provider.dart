import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Data/complete_order_data_model.dart';
import '../FirebaseServices/order_service.dart';
import 'cart_provider.dart';


class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<CompleteOrderDataModel> _customerOrders = [];
  List<CompleteOrderDataModel> _sellerOrders = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<CompleteOrderDataModel> get customerOrders => _customerOrders;
  List<CompleteOrderDataModel> get sellerOrders => _sellerOrders;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Create a new order
  Future<String?> placeOrder({
    required CartProvider cartProvider,
    required String sellerId,
    String? customerAddress,
    String? customerPhone,
    required String paymentMethod,
    required String orderType,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Get current user details
      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      final userData = userDoc.data() as Map<String, dynamic>;
      final customerName = userData['fullName'] ?? currentUser.displayName ?? 'Unknown User';

      // Calculate order totals
      final cartItems = cartProvider.cartItems;
      final subtotal = cartProvider.subtotal;

      // Calculate service fee based on subtotal
      double serviceFee;
      if (subtotal < 100) {
        serviceFee = 15;
      } else if (subtotal < 200) {
        serviceFee = 20;
      } else {
        serviceFee = 35;
      }

      final tax = subtotal * 0.14;
      final totalAmount = subtotal + serviceFee + tax;

      // Create a map of dish names to dish IDs
      // This requires fetching dish data from Firestore first
      Map<String, String> dishIdMap = {};
      for (final item in cartItems) {
        // Query Firestore to find the dish ID by name
        final dishQuerySnapshot = await _firestore
            .collection('dishes')
            .where('dishName', isEqualTo: item.foodName)
            .limit(1)
            .get();

        if (dishQuerySnapshot.docs.isNotEmpty) {
          dishIdMap[item.foodName] = dishQuerySnapshot.docs.first.id;
        }
      }

      // Create the order
      final orderId = await _orderService.createOrder(
        customerId: currentUser.uid,
        sellerId: sellerId,
        customerName: customerName,
        customerAddress: customerAddress,
        customerPhone: customerPhone,
        cartItems: cartItems,
        dishIdMap: dishIdMap,
        subtotal: subtotal,
        serviceFee: serviceFee,
        tax: tax,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        orderType: orderType,
      );

      // Clear cart after successful order
      cartProvider.clearCart();

      _isLoading = false;
      notifyListeners();
      return orderId;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Load customer orders
  void loadCustomerOrders() {
    final user = _auth.currentUser;
    if (user == null) return;

    _orderService.getCustomerOrders(user.uid).listen((orders) {
      _customerOrders = orders;
      notifyListeners();
    });
  }

  // Load seller orders
  void loadSellerOrders() {
    final user = _auth.currentUser;
    if (user == null) return;

    _orderService.getSellerOrders(user.uid).listen((orders) {
      _sellerOrders = orders;
      notifyListeners();
    });
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String customerId, String newStatus) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _orderService.updateOrderStatus(
        orderId: orderId,
        customerId: customerId,
        sellerId: user.uid, // Current seller user
        newStatus: newStatus,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}