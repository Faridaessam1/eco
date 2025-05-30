// lib/Data/recently_added_dish_data_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class RecentlyAddedDishDataModel {
  String dishId;
  final String dishName;
  final String? dishImage;
  final int dishQuantity;
  final double dishPrice;
  final String dishCategory;
  final String? dishAdditionalInfo;
  final Timestamp? createdAt;
  final String? sellerId;
  final bool isAvailable;

  RecentlyAddedDishDataModel({
    required this.dishName,
    this.dishId = "",
    required this.dishImage,
    required this.dishQuantity,
    required this.dishPrice,
    required this.dishCategory,
    required this.dishAdditionalInfo,
    this.createdAt,
    this.sellerId,
    this.isAvailable = true,
  });

  Map<String, dynamic> toFireStore() {
    return {
      "dishId": dishId,
      "dishName": dishName,
      "dishImage": dishImage,
      "dishQuantity": dishQuantity,
      "dishPrice": dishPrice,
      "dishCategory": dishCategory,
      "dishAdditionalInfo": dishAdditionalInfo,
      "createdAt": Timestamp.now(),
      "sellerId": sellerId, // Consistent naming with the model
      "isAvailable": isAvailable,
    };
  }

  factory RecentlyAddedDishDataModel.fromFireStore(Map<String, dynamic> data, String id) {
    return RecentlyAddedDishDataModel(
      dishId: id, // Set the document ID
      dishName: data['dishName'] ?? 'Unknown Dish',
      dishAdditionalInfo: data['dishAdditionalInfo'] ?? "No additional info",
      dishPrice: (data['dishPrice'] is int)
          ? (data['dishPrice'] as int).toDouble()
          : data['dishPrice'] ?? 0.0,
      dishImage: data['dishImage'] ?? 'assets/images/recentlyAddedImg.png',
      dishQuantity: data['dishQuantity'] ?? 1,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      dishCategory: data['dishCategory'] ?? "hotels",
      sellerId: data['sellerId'] ?? data['uid'], // Handle both field names for backward compatibility
      isAvailable: data['isAvailable'] ?? true,
    );
  }
}