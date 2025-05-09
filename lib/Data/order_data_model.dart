import 'package:flutter/material.dart';

class OrderDataModel {
  String id;
   String orderNumber;
   String orderStatus;
  final String? orderItemCount;
  final Color orderStatusColor;
  final String? orderDetails;
  final String orderAmount;
  final String customerName;
  final String? customerAddress;
  final String time;

   OrderDataModel({
    required this.id,
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

  OrderDataModel copyWith({
    String? id,
    String? orderNumber,
    String? orderStatus,
    String? customerName,
    String? customerAddress,
    String? time,
    String? orderItemCount,
    String? orderAmount,
    Color? orderStatusColor,
  }) {
    return OrderDataModel(
      id: this.id,
      orderNumber: orderNumber ?? this.orderNumber, // Use the passed orderNumber if provided
      orderStatus: this.orderStatus,
      orderStatusColor: this.orderStatusColor,
      orderAmount: this.orderAmount,
      customerName: this.customerName,
      customerAddress: this.customerAddress,
      time: this.time,
      orderItemCount: this.orderItemCount,
    );
  }

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

  factory OrderDataModel.fromFireStore(Map<String, dynamic> json, String docId) {
    return OrderDataModel(
      id: docId,
      orderNumber: " ",
      orderStatus: json["orderStatus"] ?? "Pending",
      orderItemCount: json["orderItemCount"]?.toString() ?? "",
      orderDetails: json["orderDetails"]?.toString() ?? "",
      orderStatusColor: _parseColor(json["orderStatusColor"]),
      orderAmount: json["orderAmount"]?.toString() ?? "0",
      customerName: json["customerName"] ?? "Unknown",
      customerAddress: json["customerAddress"] ?? "",
      time: json["time"] ?? DateTime.now().toString(),
    );
  }

  static Color _parseColor(dynamic value) {
    if (value is int) {
      return Color(value);
    }
    return Colors.grey; // fallback default
  }


}
