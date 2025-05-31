import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../Data/recently_added_dish_data_model.dart';
import '../../../../../../../core/providers/cart_provider.dart';
import '../../../../../../../core/utils/snack_bar_services.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';

class FoodItemWidget extends StatelessWidget {
  final RecentlyAddedDishDataModel foodData;

  const FoodItemWidget({
    Key? key,
    required this.foodData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Define responsive breakpoints
    final isTablet = width >= 768;
    final isDesktop = width >= 1024;
    final isMobile = width < 768;

    // Calculate responsive dimensions
    double imageHeight = _getImageHeight(height, width);
    double cardMargin = _getCardMargin(width);
    double cardPadding = _getCardPadding(width);
    double fontSize = _getFontSize(width);
    double titleFontSize = _getTitleFontSize(width);
    double priceFontSize = _getPriceFontSize(width);

    // Get CartProvider from Provider
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Container(
      constraints: BoxConstraints(
        maxWidth: isDesktop ? 400 : double.infinity,
        minHeight: isTablet ? 320 : 280,
      ),
      child: Card(
        elevation: 3,
        margin: EdgeInsets.all(cardMargin),
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Responsive image container
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: imageHeight,
                  width: double.infinity,
                  child: (foodData.dishImage != null && foodData.dishImage!.isNotEmpty)
                      ? Image.network(
                    foodData.dishImage!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AppAssets.recentlyAddedImg,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                      : Image.asset(
                    AppAssets.recentlyAddedImg,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: isMobile ? 8 : 12),

              // Food name with responsive font
              Text(
                foodData.dishName,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 4),

              // Category
              Text(
                foodData.dishCategory,
                style: TextStyle(
                  color: AppColors.textGreyColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: isMobile ? 5 : 8),

              // Description with responsive layout
              if (foodData.dishAdditionalInfo?.isNotEmpty == true)
                Text(
                  foodData.dishAdditionalInfo!,
                  maxLines: isTablet ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textGreyColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),

              // Flexible spacer to push price and button to bottom
              Flexible(child: SizedBox(height: isMobile ? 8 : 12)),

              // Price section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${foodData.dishPrice} L.E",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: priceFontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: isMobile ? 8 : 12),

              // Responsive button
              SizedBox(
                width: double.infinity,
                height: isTablet ? 50 : 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.white,
                    textStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 16 : 12,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Check if seller ID exists in the food data
                    if (foodData.sellerId == null || foodData.sellerId!.isEmpty) {
                      SnackBarServices.showErrorMessage("Error: This item has no seller information");
                      print("ERROR: Dish ${foodData.dishName} has no seller ID");
                      return;
                    }

                    // Add the dish directly to cart using the updated CartProvider method
                    cartProvider.addToCart(
                      foodData,
                      quantity: 1,
                    );

                    // Show success message
                    SnackBarServices.showSuccessMessage("${foodData.dishName} added to cart");
                  },
                  child: const Text("Add to Cart"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods for responsive sizing
  double _getImageHeight(double screenHeight, double screenWidth) {
    if (screenWidth >= 1024) return 200; // Desktop
    if (screenWidth >= 768) return 180;  // Tablet
    return screenHeight * 0.18;          // Mobile
  }

  double _getCardMargin(double screenWidth) {
    if (screenWidth >= 1024) return 12;  // Desktop
    if (screenWidth >= 768) return 10;   // Tablet
    return 8;                            // Mobile
  }

  double _getCardPadding(double screenWidth) {
    if (screenWidth >= 1024) return 16;  // Desktop
    if (screenWidth >= 768) return 14;   // Tablet
    return 12;                           // Mobile
  }

  double _getFontSize(double screenWidth) {
    if (screenWidth >= 1024) return 16;  // Desktop
    if (screenWidth >= 768) return 15;   // Tablet
    return 14;                           // Mobile
  }

  double _getTitleFontSize(double screenWidth) {
    if (screenWidth >= 1024) return 18;  // Desktop
    if (screenWidth >= 768) return 17;   // Tablet
    return 16;                           // Mobile
  }

  double _getPriceFontSize(double screenWidth) {
    if (screenWidth >= 1024) return 18;  // Desktop
    if (screenWidth >= 768) return 17;   // Tablet
    return 16;                           // Mobile
  }
}