import 'package:cloud_firestore/cloud_firestore.dart';

class DishDataModel{
  static const String collectionName = "dishDataCollection";
  String dishId;
  final String dishName;
  final String? dishImage;
  final int dishQuantity;
  final double dishPrice;
  final String dishCategory;
  final String? dishAdditionalInfo;
  final Timestamp? createdAt;

   DishDataModel({
    required this.dishName,
     this.dishId ="",
    required this.dishImage,
    required this.dishQuantity,
    required this.dishPrice,
    required this.dishCategory,
    required this.dishAdditionalInfo,
     this.createdAt,
});


  Map <String, dynamic> toFireStore(){
    return {
      "dishName" : dishName,
      "dishImage":dishImage,
      "dishQuantity": dishQuantity,
      "dishPrice": dishPrice,
      "dishCategory": dishCategory,
      "dishAdditionalInfo" :dishAdditionalInfo,
      "createdAt": Timestamp.now(),
    };
  }

  factory DishDataModel.fromFireStore(Map<String, dynamic> data) {
    return DishDataModel(
      dishName: data['dishName'] ?? 'Unknown Dish',  // تأكد من أن القيمة ليست null
      dishAdditionalInfo: data['dishAdditionalInfo'] ?? 'No description available',  // إذا كانت null، ضع وصف افتراضي
      dishPrice: data['dishPrice'] ?? 0.0,  // إذا كانت null، ضع سعر افتراضي
      dishImage: data['dishImage'] ?? 'assets/images/recentlyAddedImg.png',  // صورة افتراضية إذا كانت null
      dishQuantity: data['dishQuantity'] ?? 1,  // إذا كانت null، ضع كمية افتراضية
      createdAt: data['createdAt'] ?? Timestamp.now(),
      dishCategory: data['dishCategory'] ?? "Hotel",
    );
  }
}