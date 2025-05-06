class RestaurantCardData {
  String? sellerProfileImage;
  String restaurantName;
  String restaurantCategory;
  String location;
  String deliveryEstimatedTime;

  RestaurantCardData({
    required this.sellerProfileImage,
    required this.restaurantName,
    required this.restaurantCategory,
    required this.location,
    required this.deliveryEstimatedTime,
  });


  factory RestaurantCardData.fromFireStore(Map<String, dynamic> data) {
    return RestaurantCardData(
      sellerProfileImage: data['sellerProfileImage'] ?? 'assets/images/restaurantsCardImg.png', // استخدم اسم الحقل الصحيح
      restaurantName: data['businessName'] ?? 'No Name',
      restaurantCategory:
      data['businessType'] ?? '', // استخدم businessType كـ restaurantCategory
      location: data['city'] ?? '',
      deliveryEstimatedTime: data['deliveryTime'] ?? '30 Min',
    );
  }
}