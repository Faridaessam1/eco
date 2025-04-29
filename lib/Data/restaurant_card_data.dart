class RestaurantCardData {
  String imgPath;
  String restaurantName;
  String restaurantCategory;
  String location;
  String deliveryEstimatedTime;

  RestaurantCardData({
    required this.imgPath,
    required this.restaurantName,
    required this.restaurantCategory,
    required this.location,
    required this.deliveryEstimatedTime,
  });

  factory RestaurantCardData.fromFireStore(Map<String, dynamic> data) {
    return RestaurantCardData(
      imgPath: data['imgPath'] ?? '',
      restaurantName: data['businessName'] ?? 'No Name',
      restaurantCategory: data['businessType'] ?? '',
      location: data['city'] ?? '',
      deliveryEstimatedTime: data['deliveryTime'] ?? '30 Min',
    );
  }
}