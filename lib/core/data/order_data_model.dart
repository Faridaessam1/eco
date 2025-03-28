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
}
