import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../Data/complete_order_data_model.dart';
import '../FirebaseServices/order_service.dart';
import '../FirebaseServices/user_service.dart';
import './cart_provider.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  final UserService _userService = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<CompleteOrderDataModel> _orders = [];
  List<CompleteOrderDataModel> _customerOrders = [];
  String _errorMessage = '';
  bool _isLoading = false;
  String _userType = 'customer'; // Default user type

  List<CompleteOrderDataModel> get orders => _orders;
  List<CompleteOrderDataModel> get customerOrders => _customerOrders;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Set user type (customer or seller)
  void setUserType(String userType) {
    _userType = userType;
    notifyListeners();
  }

  // Reset error message
  void resetError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Place a new order
  Future<String?> placeOrder({
    required CartProvider cartProvider,
    required String sellerId,
    String? customerAddress,
    String? customerPhone,
    required String paymentMethod,
    required String orderType,
  }) async {
    try {
      resetError();

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        _errorMessage = 'You must be logged in to place an order';
        notifyListeners();
        return null;
      }

      // Create a map of dish names to dish IDs
      final Map<String, String> dishIdMap = {};
      for (var item in cartProvider.cartItems) {
        dishIdMap[item.foodName] = item.dishId ?? '';
      }

      // Get customer details from Firestore instead of just using currentUser
      final customerDetails = await _userService.getCustomerDetails(currentUser.uid);

      // Get seller details from Firestore
      final sellerDetails = await _userService.getSellerDetails(sellerId);

      // Use the retrieved data or fall back to parameters/defaults
      final String customerName = customerDetails['name'] ?? currentUser.displayName ?? 'Unknown Customer';
      final String finalCustomerPhone = customerPhone ?? customerDetails['phone'] ?? '';
      final String finalCustomerAddress = customerAddress ?? customerDetails['address'] ?? '';
      final String sellerName = sellerDetails['name'] ?? 'Unknown Restaurant';

      print("Placing order with:");
      print("Customer Name: $customerName");
      print("Customer Phone: $finalCustomerPhone");
      print("Customer Address: $finalCustomerAddress");
      print("Seller Name: $sellerName");

      // Calculate order totals
      final double subtotal = cartProvider.subtotal;
      double serviceFee;
      if (subtotal < 100) {
        serviceFee = 15;
      } else if (subtotal < 200) {
        serviceFee = 20;
      } else {
        serviceFee = 35;
      }
      final double tax = subtotal * 0.14;
      final double totalAmount = subtotal + serviceFee + tax;

      // Create the order
      final orderId = await _orderService.createOrder(
        customerId: currentUser.uid,
        sellerId: sellerId,
        customerName: customerName,
        customerAddress: finalCustomerAddress,
        customerPhone: finalCustomerPhone,
        cartItems: cartProvider.cartItems,
        dishIdMap: dishIdMap,
        subtotal: subtotal,
        serviceFee: serviceFee,
        tax: tax,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        orderType: orderType,
      );

      // Clear the cart after successful order
      cartProvider.clearCart();

      return orderId;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  // General method to load orders based on user type
  Future<void> loadOrders() async {
    if (_userType == 'customer') {
      await loadCustomerOrders();
    } else if (_userType == 'seller') {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await loadSellerOrders(currentUser.uid);
      }
    }
  }

  // Load orders by status
  Future<void> loadOrdersByStatus(String status) async {
    try {
      _isLoading = true;
      notifyListeners();

      resetError();

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        _errorMessage = 'You must be logged in to view orders';
        _isLoading = false;
        notifyListeners();
        return;
      }

      if (_userType == 'customer') {
        _orderService.getCustomerOrdersByStatus(currentUser.uid, status).listen(
                (orders) {
              _customerOrders = orders;
              _isLoading = false;
              notifyListeners();
            },
            onError: (error) {
              _errorMessage = 'Failed to load orders: $error';
              _isLoading = false;
              notifyListeners();
            }
        );
      } else if (_userType == 'seller') {
        _orderService.getSellerOrdersByStatus(currentUser.uid, status).listen(
                (orders) {
              _orders = orders;
              _isLoading = false;
              notifyListeners();
            },
            onError: (error) {
              _errorMessage = 'Failed to load orders: $error';
              _isLoading = false;
              notifyListeners();
            }
        );
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load customer orders
  Future<void> loadCustomerOrders() async {
    try {
      _isLoading = true;
      notifyListeners();

      resetError();

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        _errorMessage = 'You must be logged in to view your orders';
        _isLoading = false;
        notifyListeners();
        return;
      }

      _orderService.getCustomerOrders(currentUser.uid).listen(
              (orders) {
            _customerOrders = orders;
            _isLoading = false;
            notifyListeners();
          },
          onError: (error) {
            _errorMessage = 'Failed to load orders: $error';
            _isLoading = false;
            notifyListeners();
          }
      );
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load seller orders
  Future<void> loadSellerOrders(String sellerId) async {
    try {
      _isLoading = true;
      notifyListeners();

      resetError();

      _orderService.getSellerOrders(sellerId).listen(
              (orders) {
            _orders = orders;
            _isLoading = false;
            notifyListeners();
          },
          onError: (error) {
            _errorMessage = 'Failed to load orders: $error';
            _isLoading = false;
            notifyListeners();
          }
      );
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String customerId, String sellerId, String newStatus) async {
    try {
      resetError();

      await _orderService.updateOrderStatus(
        orderId: orderId,
        customerId: customerId,
        sellerId: sellerId,
        newStatus: newStatus,
      );
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Repair missing seller orders
  Future<void> repairSellerOrders(String sellerId) async {
    try {
      resetError();
      await _orderService.repairMissingSellerOrders(sellerId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}