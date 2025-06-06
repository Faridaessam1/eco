import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../core/seller services/seller_home_services.dart';
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
  List<OrderItem> items;

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
    required this.items,
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
    List<OrderItem>? items,
  }) {
    return OrderDataModel(
      id: this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      orderStatus: this.orderStatus,
      orderStatusColor: this.orderStatusColor,
      orderAmount: this.orderAmount,
      customerName: this.customerName,
      customerAddress: this.customerAddress,
      time: this.time,
      orderItemCount: this.orderItemCount,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      "orderNumber": orderNumber,
      "orderStatus": orderStatus,
      "orderItemCount": orderItemCount,
      "orderDetails": orderDetails,
      "orderStatusColor": orderStatusColor.value,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "customerAddress": customerAddress,
      "time": time,
    };
  }

  factory OrderDataModel.fromFireStore(Map<String, dynamic> json, String docId) {
    final timestamp = json["createdAt"];
    final time = timestamp is Timestamp
        ? timestamp.toDate().toString()
        : DateTime.now().toString();

    // Convert items from List<dynamic> to List<OrderItem>
    final itemsJson = json["items"] as List<dynamic>? ?? [];
    final itemsList = itemsJson
        .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
        .toList();

    final orderStatus = json["orderStatus"] ?? "Pending";

    return OrderDataModel(
      id: docId,
      orderNumber: docId,
      orderStatus: orderStatus,
      orderItemCount: (json["items"] as List<dynamic>?)?.length.toString() ?? "0",
      orderDetails: "", // Not present in Firestore
      // THIS WORKS! Static method from HomeServices can be called in factory constructor
      orderStatusColor: SellerHomeServices.getStatusColor(orderStatus),
      orderAmount: json["totalAmount"]?.toString() ?? "0.0",
      customerName: json["customerName"] ?? "Unknown",
      customerAddress: json["customerAddress"] ?? "",
      time: time,
      items: itemsList,
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'] ?? 'Unknown',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}