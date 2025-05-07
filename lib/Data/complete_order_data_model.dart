import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'food_card_in_cart_tab_data.dart';

class CompleteOrderModel {
  final String orderId;
  final String customerId;
  final String sellerId;
  final String customerName;
  final String? customerAddress;
  final List<FoodCardInCartTabData> orderItems;
  final String orderStatus;
  final Color orderStatusColor;
  final double subtotal;
  final double serviceFees;
  final double tax;
  final double totalAmount;
  final String paymentMethod;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  CompleteOrderModel({
    required this.orderId,
    required this.customerId,
    required this.sellerId,
    required this.customerName,
    this.customerAddress,
    required this.orderItems,
    required this.orderStatus,
    required this.orderStatusColor,
    required this.subtotal,
    required this.serviceFees,
    required this.tax,
    required this.totalAmount,
    required this.paymentMethod,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'sellerId': sellerId,
      'customerName': customerName,
      'customerAddress': customerAddress,
      'orderItems': orderItems.map((item) => {
        'foodName': item.foodName,
        'foodPrice': item.foodPrice,
        'foodQuantity': item.foodQuantity,
        'foodImgPath': item.foodImgPath,
        'totalItemPrice': item.foodPrice * item.foodQuantity,
      }).toList(),
      'orderStatus': orderStatus,
      'orderStatusColor': orderStatusColor.value,
      'subtotal': subtotal,
      'serviceFees': serviceFees,
      'tax': tax,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory CompleteOrderModel.fromFirestore(Map<String, dynamic> data, String docId) {
    List<FoodCardInCartTabData> items = [];
    if (data['orderItems'] != null) {
      for (var item in data['orderItems']) {
        items.add(FoodCardInCartTabData(
          foodImgPath: item['foodImgPath'] ?? 'assets/images/recentlyAddedImg.png',
          foodName: item['foodName'] ?? 'Unknown Item',
          foodPrice: (item['foodPrice'] ?? 0).toDouble(),
          foodQuantity: item['foodQuantity'] ?? 1,
        ));
      }
    }

    return CompleteOrderModel(
      orderId: docId,
      customerId: data['customerId'] ?? '',
      sellerId: data['sellerId'] ?? '',
      customerName: data['customerName'] ?? '',
      customerAddress: data['customerAddress'],
      orderItems: items,
      orderStatus: data['orderStatus'] ?? 'Pending',
      orderStatusColor: Color(data['orderStatusColor'] ?? Colors.orange.value),
      subtotal: (data['subtotal'] ?? 0).toDouble(),
      serviceFees: (data['serviceFees'] ?? 0).toDouble(),
      tax: (data['tax'] ?? 0).toDouble(),
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      paymentMethod: data['paymentMethod'] ?? 'Cash',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'],
    );
  }
}