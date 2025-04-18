class DishDataModel{
  static const String collectionName = "dishDataCollection";
  final String dishName;
        String dishId;
  final String? dishImage;
  final String dishQuantity;
  final String dishPrice;
  final String dishCategory;
  final String? dishAdditionalInfo;

   DishDataModel({
    required this.dishName,
     this.dishId ="",
    required this.dishImage,
    required this.dishQuantity,
    required this.dishPrice,
    required this.dishCategory,
    required this.dishAdditionalInfo,
});


  Map <String, dynamic> toFireStore(){
    return {
      "dishName" : dishName,
      "dishId" : dishId,
      "dishImage":dishImage,
      "dishQuantity": dishQuantity,
      "dishPrice": dishPrice,
      "dishCategory": dishCategory,
      "dishAdditionalInfo" : dishCategory,
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
        dishAdditionalInfo: json["dishAdditionalInfo"]
    );
  }
}