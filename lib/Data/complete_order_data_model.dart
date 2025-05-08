import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItemModel {
  final String dishId;
  final String name;
  final double price;
  final int quantity;
  final String? image;

  OrderItemModel({
    required this.dishId,
    required this.name,
    required this.price,
    required this.quantity,
    this.image,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      dishId: map['dishId'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 0,
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dishId': dishId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'image': image,
    };
  }

  // Create from cart item
  factory OrderItemModel.fromCartItem(dynamic cartItem, String dishId) {
    return OrderItemModel(
      dishId: dishId,
      name: cartItem.foodName,
      price: cartItem.foodPrice,
      quantity: cartItem.foodQuantity,
      image: cartItem.foodImgPath,
    );
  }
}

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
  final String paymentMethod;
  final String orderStatus;
  final String orderType;
  final Timestamp createdAt;
  final Timestamp? updatedAt;
  final String? sellerName;

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
    required this.sellerName,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'uid': sellerId, // Compatibility
      'sellerId': sellerId,
      'customerName': customerName,
      'customerAddress': customerAddress,
      'customerPhone': customerPhone,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'serviceFee': serviceFee,
      'tax': tax,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'orderStatus': orderStatus,
      'orderType': orderType,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? Timestamp.now(),
      'sellerName': sellerName,
    };
  }

  factory CompleteOrderDataModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CompleteOrderDataModel(
      orderId: doc.id,
      customerId: data['customerId'] ?? '',
      sellerId: data['sellerId'] ?? data['uid'] ?? '',
      customerName: data['customerName'] ?? '',
      customerAddress: data['customerAddress'],
      customerPhone: data['customerPhone'],
      items: (data['items'] as List?)
          ?.map((item) => OrderItemModel.fromMap(item as Map<String, dynamic>))
          .toList() ??
          [],
      subtotal: (data['subtotal'] as num? ?? 0).toDouble(),
      serviceFee: (data['serviceFee'] as num? ?? 0).toDouble(),
      tax: (data['tax'] as num? ?? 0).toDouble(),
      totalAmount: (data['totalAmount'] as num? ?? 0).toDouble(),
      paymentMethod: data['paymentMethod'] ?? 'cod',
      orderStatus: data['orderStatus'] ?? 'pending',
      orderType: data['orderType'] ?? 'pickup',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'],
      sellerName: data['sellerName'] ?? '',
    );
  }
}
