import 'package:flutter/material.dart';

class OrderDataModel {
  final String orderNumber;
  final String orderStatus;
  final String? orderItemCount;
  final Color orderStatusColor;
  final String? orderDetails;
  final String orderAmount;
  final String customerName;
  final String? customerAddress;
  final String time;

  const OrderDataModel({
    required this.orderNumber,
    required this.orderStatus,
    this.orderItemCount = "",
    required this.orderStatusColor,
    this.orderDetails = "",
    required this.orderAmount,
    required this.customerName,
    this.customerAddress = "",
    required this.time,
  });


  Map <String, dynamic> toFireStore(){
    return {
      "orderNumber": orderNumber,
      "orderStatus": orderStatus,
      "orderItemCount": orderItemCount,
      "orderDetails": orderDetails,
      "orderStatusColor": orderStatusColor.value, // نحول الـ Color إلى int
      "orderAmount": orderAmount,
      "customerName": customerName,
      "customerAddress": customerAddress,
      "time": time,
    };
  }

  factory OrderDataModel.fromFireStore( Map <String, dynamic > json ){
    return OrderDataModel(
      orderNumber: json["orderNumber"],
      orderStatus: json["orderStatus"],
      orderItemCount : json["orderItemCount"] ?? "",
      orderDetails : json["orderDetails"] ?? "",
      orderStatusColor: Color(json["orderStatusColor"]),
      orderAmount: json["orderAmount"],
      customerName: json["customerName"],
      customerAddress : json["customerAddress"] ?? "",
      time: json["time"],
    );
  }

}
