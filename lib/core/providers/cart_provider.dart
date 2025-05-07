import 'package:flutter/material.dart';
import '../../../Data/food_card_in_cart_tab_data.dart';
import '../../Data/recently_added_dish_data_model.dart';

class CartProvider extends ChangeNotifier {
  List<FoodCardInCartTabData> _cartItems = [];
  String? currentSellerId; // Track the seller ID for the current cart

  List<FoodCardInCartTabData> get cartItems => _cartItems;
  String? get sellerId => currentSellerId;

  void setSellerId(String sellerId) {
    currentSellerId = sellerId;
    notifyListeners();
  }

  void addToCart(RecentlyAddedDishDataModel dish, String sellerId) {
    // If adding items from a different seller, clear the cart first
    if (currentSellerId != null && currentSellerId != sellerId) {
      _cartItems.clear();
    }

    // Set the current seller ID
    currentSellerId = sellerId;

    final existingIndex = _cartItems.indexWhere((item) => item.foodName == dish.dishName);
    if (existingIndex != -1) {
      _cartItems[existingIndex].foodQuantity++;
    } else {
      _cartItems.add(FoodCardInCartTabData(
        foodImgPath: (dish.dishImage != null && dish.dishImage!.isNotEmpty)
            ? dish.dishImage!
            : 'assets/images/recentlyAddedImg.png',

        foodName: dish.dishName,
        foodPrice: dish.dishPrice,
        foodQuantity: 1,
      ));
    }
    notifyListeners();
  }

  void increment(int index) {
    _cartItems[index].foodQuantity++;
    notifyListeners();
  }

  void decrement(int index) {
    if (_cartItems[index].foodQuantity > 1) {
      _cartItems[index].foodQuantity--;
    } else {
      _cartItems.removeAt(index);
      // If cart is empty, reset the seller ID
      if (_cartItems.isEmpty) {
        currentSellerId = null;
      }
    }
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    // If cart is empty, reset the seller ID
    if (_cartItems.isEmpty) {
      currentSellerId = null;
    }
    notifyListeners();
  }

  // Clear the entire cart
  void clearCart() {
    _cartItems.clear();
    currentSellerId = null;
    notifyListeners();
  }

  double get subtotal => _cartItems.fold(0, (sum, item) => sum + (item.foodQuantity * item.foodPrice));

  bool get isEmpty => _cartItems.isEmpty;
}