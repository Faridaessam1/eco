import 'package:flutter/material.dart';
import '../../Data/restaurant_card_data.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<RestaurantCardData> _favorites = [];

  List<RestaurantCardData> get favorites => _favorites;

  void toggleFavorite(RestaurantCardData restaurant) {
    if (_favorites.contains(restaurant)) {
      _favorites.remove(restaurant);
    } else {
      _favorites.add(restaurant);
    }
    notifyListeners();
  }

  bool isFavorite(RestaurantCardData restaurant) {
    return _favorites.contains(restaurant);
  }
}
