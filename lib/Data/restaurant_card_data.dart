class RestaurantCardData {
  String? sellerProfileImage;
  String restaurantName;
  String restaurantCategory;
  String location;
  String deliveryEstimatedTime;
  bool hasDelivery; // Added delivery availability field

  RestaurantCardData({
    required this.sellerProfileImage,
    required this.restaurantName,
    required this.restaurantCategory,
    required this.location,
    required this.deliveryEstimatedTime,
    this.hasDelivery = true, // Default to true (most restaurants have delivery)
  });

  factory RestaurantCardData.fromFireStore(Map<String, dynamic> data) {
    return RestaurantCardData(
      sellerProfileImage: data['sellerProfileImage'] ?? 'assets/images/restaurantsCardImg.png',
      restaurantName: data['businessName'] ?? 'No Name',
      restaurantCategory: data['businessType'] ?? '',
      location: data['city'] ?? '',
      deliveryEstimatedTime: data['deliveryTime'] ?? '30 Min',
      hasDelivery: data['deliveryAvailability'] ?? true, // Get delivery status from Firestore
    );
  }

  // Helper method to get delivery status text
  String get deliveryStatusText {
    return hasDelivery ? deliveryEstimatedTime : "Pickup only";
  }

  // Helper method to check if delivery time should be shown
  bool get shouldShowDeliveryTime {
    return hasDelivery && deliveryEstimatedTime.isNotEmpty;
  }
}