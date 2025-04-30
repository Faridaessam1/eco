import 'package:cloud_firestore/cloud_firestore.dart';

class DishDataModel {


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
    required this.dishId,
    required this.dishName,
    required this.dishImage,
    required this.dishQuantity,
    required this.dishPrice,
    required this.dishCategory,
    required this.dishAdditionalInfo,
    this.createdAt,
  });

  Map<String, dynamic> toFireStore() {
    return {
      "dishName": dishName,
      "dishImage": dishImage,
      "dishQuantity": dishQuantity,
      "dishPrice": dishPrice,
      "dishCategory": dishCategory,
      "dishAdditionalInfo": dishAdditionalInfo,
      "createdAt": createdAt ?? Timestamp.now(),
    };
  }

  factory DishDataModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DishDataModel(
      dishId: doc.id,
      dishName: data["dishName"] ?? "",
      dishImage: data["dishImage"],
      dishQuantity: data["dishQuantity"] ?? 0,
      dishPrice: (data["dishPrice"] as num).toDouble(),
      dishCategory: data["dishCategory"] ?? "",
      dishAdditionalInfo: data["dishAdditionalInfo"],
      createdAt: data["createdAt"],

    );
  }
}
