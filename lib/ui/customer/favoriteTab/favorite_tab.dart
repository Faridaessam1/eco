import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Data/restaurant_card_data.dart';
import '../../../core/constants/app_assets.dart';

import '../../../core/providers/favorite_provider.dart';
import '../widgets/restaurant_card.dart';

class FavoriteTab extends StatelessWidget{
  List<RestaurantCardData> restaurantsData=[];
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final favorites = Provider.of<FavoritesProvider>(context).favorites;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          AppAssets.appLogo,
          height: height * 0.03,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: favorites.isEmpty
            ? const Center(child: Text("No favorites yet."))
            : ListView.separated(
          itemBuilder: (context, index) => RestaurantCard(
            restaurantCardData: favorites[index],
          ),
          separatorBuilder: (context, index) => const SizedBox(width: 16),
          itemCount: favorites.length,
        ),
      ),
    );
  }
  }

