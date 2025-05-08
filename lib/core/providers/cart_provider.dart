// lib/core/providers/cart_provider.dart
import 'package:flutter/foundation.dart';
import '../../Data/food_card_in_cart_tab_data.dart';
import '../../Data/recently_added_dish_data_model.dart';

class CartProvider with ChangeNotifier {
  List<FoodCardInCartTabData> _cartItems = [];
  String _currentSellerId = '';
  Map<String, String> _dishIdMap = {}; // Map to store dish names to dish IDs

  List<FoodCardInCartTabData> get cartItems => _cartItems;
  String get currentSellerId => _currentSellerId;
  Map<String, String> get dishIdMap => _dishIdMap;

  double get subtotal {
    double total = 0;
    for (var item in _cartItems) {
      total += (item.foodPrice * item.foodQuantity);
    }
    return total;
  }

  // Method to add item to cart with seller ID
  void addToCart(RecentlyAddedDishDataModel dish, {int quantity = 1}) {
    // Check if cart has items from a different seller
    if (_cartItems.isNotEmpty && dish.sellerId != _currentSellerId) {
      // Clear cart if adding item from a different seller
      _cartItems = [];
      _dishIdMap = {};
    }

    // Set current seller ID
    _currentSellerId = dish.sellerId ?? '';

    // Check if the item already exists in the cart
    final existingItemIndex = _cartItems.indexWhere(
          (element) => element.foodName == dish.dishName,
    );

    if (existingItemIndex >= 0) {
      // Increment quantity if item already exists
      _cartItems[existingItemIndex].foodQuantity += quantity;
    } else {
      // Add new item if it doesn't exist
      _cartItems.add(
        FoodCardInCartTabData(
          foodName: dish.dishName,
          foodPrice: dish.dishPrice,
          foodImgPath: dish.dishImage ?? 'assets/images/recentlyAddedImg.png',
          foodQuantity: quantity,
        ),
      );

      // Store dish ID in the map
      _dishIdMap[dish.dishName] = dish.dishId;
    }

    notifyListeners();
  }

  void increment(int index) {
    if (index < _cartItems.length) {
      _cartItems[index].foodQuantity++;
      notifyListeners();
    }
  }

  void decrement(int index) {
    if (index < _cartItems.length && _cartItems[index].foodQuantity > 1) {
      _cartItems[index].foodQuantity--;
      notifyListeners();
    }
  }

  void removeFromCart(int index) {
    if (index < _cartItems.length) {
      // Remove from the dishIdMap as well
      final dishName = _cartItems[index].foodName;
      _dishIdMap.remove(dishName);

      _cartItems.removeAt(index);

      // Reset seller ID if cart is empty
      if (_cartItems.isEmpty) {
        _currentSellerId = '';
      }

      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems = [];
    _currentSellerId = '';
    _dishIdMap = {};
    notifyListeners();
  }
}