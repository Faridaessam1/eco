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

  factory DishDataModel.fromFireStore( Map <String, dynamic > json ){
    return DishDataModel(
        dishName: json["dishName"],
        dishId:  json["dishId"],
        dishImage: json["dishImage"],  //mtnsesh t3dleha
        dishQuantity: json["dishQuantity"],
        dishPrice: json["dishPrice"],
        dishCategory: json["dishCategory"],
        dishAdditionalInfo: json["dishAdditionalInfo"],
        createdAt: json["createdAt"],
    );
  }
}