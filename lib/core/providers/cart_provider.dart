import 'package:flutter/material.dart';
import '../../../Data/food_card_in_cart_tab_data.dart';
import '../../Data/recently_added_dish_data_model.dart';

class CartProvider extends ChangeNotifier {
  List<FoodCardInCartTabData> _cartItems = [];

  List<FoodCardInCartTabData> get cartItems => _cartItems;

  void addToCart(RecentlyAddedDishDataModel dish) {
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
    notifyListeners();
  }

  double get subtotal => _cartItems.fold(0, (sum, item) => sum + (item.foodQuantity * item.foodPrice));
}