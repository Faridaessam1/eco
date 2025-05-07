import 'package:flutter/material.dart';

import '../../Data/food_card_in_cart_tab_data.dart';
import '../../Data/recently_added_dish_data_model.dart';

class CartProvider extends ChangeNotifier {
  List<FoodCardInCartTabData> _cartItems = [];
  // Store seller ID separately since it's not part of the food card data model
  String _currentSellerId = "";

  List<FoodCardInCartTabData> get cartItems => _cartItems;
  String get currentSellerId => _currentSellerId;

  void addToCart(RecentlyAddedDishDataModel dish) {
    // If this is the first item, set the seller ID
    if (_cartItems.isEmpty && dish.sellerId != null) {
      _currentSellerId = dish.sellerId!;
    }

    // Only allow adding items from the same seller
    if (_cartItems.isNotEmpty && dish.sellerId != null && dish.sellerId != _currentSellerId) {
      // In a real app, you might want to show a warning to the user
      return;
    }

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
    }
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cartItems.removeAt(index);

    // Reset seller ID if cart becomes empty
    if (_cartItems.isEmpty) {
      _currentSellerId = "";
    }

    notifyListeners();
  }

  // Clear all items from cart
  void clearCart() {
    _cartItems.clear();
    _currentSellerId = "";
    notifyListeners();
  }

  double get subtotal => _cartItems.fold(0, (sum, item) => sum + (item.foodQuantity * item.foodPrice));
}