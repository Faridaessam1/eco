class RestaurantDataModel {
  static const String collectionName = "EcoEatersRestaurants";
  String restaurantId;
  String restaurantName;
  String restaurantImage;
  String contactPersonName;
  String restaurantCategory;
  String restaurantRating;
  String restaurantAddress;
  String phoneNumber;
  String operatingHours;
  String businessType;
  bool isFavorite;
  bool deliveryAvailability;

  RestaurantDataModel({
    this.restaurantId = "",
    required this.restaurantName,
    required this.restaurantImage,
    required this.contactPersonName,
    required this.restaurantCategory,
    required this.deliveryAvailability,
    required this.restaurantRating,
    required this.restaurantAddress,
    required this.phoneNumber,
    required this.operatingHours,
    required this.businessType,
     this.isFavorite = false,
  });

  Map<String, dynamic> toFireStore() {
    return {
      "restaurantId": restaurantId,
      "restaurantName": restaurantName,
      "restaurantImage": restaurantImage,
      "contactPersonName": contactPersonName,
      "restaurantCategory": restaurantCategory,
      "deliveryAvailability": deliveryAvailability,
      "restaurantRating": restaurantRating,
      "restaurantAddress": restaurantAddress,
      "phoneNumber": phoneNumber,
      "operatingHours": operatingHours,
      "businessType": businessType,
      "isFavorite": isFavorite,

    };
  }

  static RestaurantDataModel fromFireStore(Map<String, dynamic> json) {
    return RestaurantDataModel(
        restaurantId:json["restaurantId"] ,
        restaurantName: json["restaurantName"],
        restaurantImage:json["restaurantImage"],
        contactPersonName:json["contactPersonName"] ,
        restaurantCategory: json["restaurantCategory"],
        deliveryAvailability: json["deliveryAvailability"],
        restaurantRating: json["restaurantRating"],
        restaurantAddress: json["restaurantAddress"],
        phoneNumber: json["phoneNumber"],
        operatingHours: json["operatingHours"],
        businessType: json["businessType"],
        isFavorite: json["isFavorite"],
    );
  }
}
