import 'package:cloud_firestore/cloud_firestore.dart';
import '../Data/food_card_in_cart_tab_data.dart';

class CompleteOrderDataModel {
  final String orderId;
  final String customerId;
  final String sellerId;
  final String customerName;
  final String? customerAddress;
  final String? customerPhone;
  final List<OrderItemModel> items;
  final double subtotal;
  final double serviceFee;
  final double tax;
  final double totalAmount;
  final String paymentMethod; // "online" or "cod"
  final String orderStatus; // "pending", "processing", "delivered", "cancelled"
  final String orderType; // "pickup" or "delivery"
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  CompleteOrderDataModel({
    required this.orderId,
    required this.customerId,
    required this.sellerId,
    required this.customerName,
    this.customerAddress,
    this.customerPhone,
    required this.items,
    required this.subtotal,
    required this.serviceFee,
    required this.tax,
    required this.totalAmount,
    required this.paymentMethod,
    required this.orderStatus,
    required this.orderType,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'uid': sellerId,
      'customerName': customerName,
      'customerAddress': customerAddress,
      'customerPhone': customerPhone,
      'items': items.map((item) => item.toFirestore()).toList(),
      'subtotal': subtotal,
      'serviceFee': serviceFee,
      'tax': tax,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'orderStatus': orderStatus,
      'orderType': orderType,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? Timestamp.now(),
    };
  }

  factory CompleteOrderDataModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CompleteOrderDataModel(
      orderId: doc.id,
      customerId: data['customerId'] ?? '',
      sellerId: data['uid'] ?? '',
      customerName: data['customerName'] ?? '',
      customerAddress: data['customerAddress'],
      customerPhone: data['customerPhone'],
      items: (data['items'] as List?)?.map((item) => OrderItemModel.fromFirestore(item)).toList() ?? [],
      subtotal: (data['subtotal'] as num).toDouble(),
      serviceFee: (data['serviceFee'] as num).toDouble(),
      tax: (data['tax'] as num).toDouble(),
      totalAmount: (data['totalAmount'] as num).toDouble(),
      paymentMethod: data['paymentMethod'] ?? 'cod',
      orderStatus: data['orderStatus'] ?? 'pending',
      orderType: data['orderType'] ?? 'pickup',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'],
    );
  }
}

class OrderItemModel {
  final String dishId;
  final String dishName;
  final String? dishImage;
  final int quantity;
  final double price;
  final double totalPrice;

  OrderItemModel({
    required this.dishId,
    required this.dishName,
    this.dishImage,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'dishId': dishId,
      'dishName': dishName,
      'dishImage': dishImage,
      'quantity': quantity,
      'price': price,
      'totalPrice': totalPrice,
    };
  }

  factory OrderItemModel.fromFirestore(Map<String, dynamic> data) {
    return OrderItemModel(
      dishId: data['dishId'] ?? '',
      dishName: data['dishName'] ?? '',
      dishImage: data['dishImage'],
      quantity: data['quantity'] ?? 0,
      price: (data['price'] as num).toDouble(),
      totalPrice: (data['totalPrice'] as num).toDouble(),
    );
  }

  factory OrderItemModel.fromCartItem(FoodCardInCartTabData cartItem, String dishId) {
    return OrderItemModel(
      dishId: dishId,
      dishName: cartItem.foodName,
      dishImage: cartItem.foodImgPath,
      quantity: cartItem.foodQuantity,
      price: cartItem.foodPrice,
      totalPrice: cartItem.foodPrice * cartItem.foodQuantity,
    );
  }
}