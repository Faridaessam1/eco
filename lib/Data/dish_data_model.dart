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
  final bool isAvailable;

  DishDataModel({
    required this.dishId,
    required this.dishName,
    required this.dishImage,
    required this.dishQuantity,
    required this.dishPrice,
    required this.dishCategory,
    required this.dishAdditionalInfo,
    this.createdAt,
    this.isAvailable = true,
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
      "isAvailable": isAvailable,
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
      isAvailable: data["isAvailable"],

    );
  }
}

