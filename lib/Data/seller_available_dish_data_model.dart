class SellerAvailableDishDataModel {
  final String id;
  final String dishImage;
  final String dishName;
  final String dishPrice;
  bool isAvailable;

  SellerAvailableDishDataModel({
    required this.id,
    required this.dishImage,
    required this.dishName,
    required this.dishPrice,
    required this.isAvailable,
  });
}