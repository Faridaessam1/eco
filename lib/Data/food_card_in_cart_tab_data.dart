class FoodCardInCartTabData {
  String foodImgPath;
  String foodName;
  double foodPrice;
  int foodQuantity;
  String dishId;

  FoodCardInCartTabData({
    required this.foodImgPath,
    required this.foodName,
    required this.foodPrice,
    required this.foodQuantity,
    required this.dishId,

  });
  factory FoodCardInCartTabData.fromFirestore(Map<String, dynamic> data) {
    return FoodCardInCartTabData(
      foodImgPath: data['dishImage'] ?? 'assets/images/recentlyAddedImg.png',
      foodName: data['dishName'] ?? 'Unknown Dish',
      foodPrice: (data['dishPrice'] ?? 0).toDouble(),
      foodQuantity: data['dishQuantity'] ?? 1,
      dishId: data['dishId'] ?? 'null'
    );
  }
}
