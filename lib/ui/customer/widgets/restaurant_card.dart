import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Data/restaurant_card_data.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/favorite_provider.dart';

class RestaurantCard extends StatelessWidget {
  RestaurantCardData restaurantCardData;

  RestaurantCard({super.key, required this.restaurantCardData});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // Responsive sizing
    bool isTablet = width >= 768;
    double cardHeight = isTablet ? height * 0.3 : height * 0.35;
    double imageHeight = isTablet ? height * 0.18 : height * 0.22;

    return SizedBox(
      height: cardHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Image with Favorite Button
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Image.network(
                  restaurantCardData.sellerProfileImage ??
                      AppAssets.restaurantsCardImg,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: imageHeight,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      AppAssets.restaurantsCardImg,
                      height: imageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),

                // Favorite Button (Bottom Right)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Consumer<FavoritesProvider>(
                    builder: (context, favoritesProvider, _) {
                      final isFav =
                          favoritesProvider.isFavorite(restaurantCardData);
                      return GestureDetector(
                        onTap: () {
                          favoritesProvider.toggleFavorite(restaurantCardData);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Restaurant Name and Category
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurantCardData.restaurantName,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  restaurantCardData.restaurantCategory,
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: isTablet ? 17 : 16,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Location and Delivery Icon
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.primaryColor,
                      size: isTablet ? 20 : 18,
                    ),
                    Text(
                      restaurantCardData.location,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: isTablet ? 16 : 16,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width:15),
                    Icon(
                      restaurantCardData.hasDelivery
                          ? Icons.delivery_dining
                          : Icons.store,
                      color: AppColors.primaryColor,
                      size: isTablet ? 20 : 18,
                    ),
    Text(
    " ${restaurantCardData.hasDelivery ? "Delivery" : "Pickup"}",
    style: TextStyle(
    color: AppColors.primaryColor,
    fontSize: isTablet ? 16 : 16,
    fontWeight: FontWeight.w400,
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
