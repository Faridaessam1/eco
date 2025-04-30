import 'package:cloud_firestore/cloud_firestore.dart';

class DishDataModel{
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
      dishName: data['dishName'] ?? 'Unknown Dish',
      dishAdditionalInfo: data['dishAdditionalInfo'] ?? "No additional info" ,
      dishPrice: data['dishPrice'] ?? 0,
      dishImage: data['dishImage'] ?? 'assets/images/recentlyAddedImg.png',
      dishQuantity: data['dishQuantity'] ?? 1,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      dishCategory: data['dishCategory'] ?? "hotels",
    );
  }
}