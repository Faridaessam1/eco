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
    print("===== ORDER MODEL toFirestore =====");
    print("Converting order ID: $orderId to Firestore");
    print("customerId: $customerId");
    print("sellerId: $sellerId");

    final result = {
      'orderId': orderId,
      'customerId': customerId,
      'sellerId': sellerId,  // NOTE: This is a key issue - using 'uid' instead of 'sellerId'
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

    print("Firestore map keys: ${result.keys.toList()}");
    print("uid value in result: ${result['uid']}");
    print("===== ORDER MODEL toFirestore END =====");

    return result;
  }

  factory CompleteOrderDataModel.fromFirestore(DocumentSnapshot doc) {
    print("===== ORDER MODEL fromFirestore =====");
    print("Converting document ID: ${doc.id} from Firestore");

    final data = doc.data() as Map<String, dynamic>;
    print("Document data keys: ${data.keys.toList()}");

    final customerId = data['customerId'] ?? '';
    final sellerId = data['sellerId'] ?? '';  // NOTE: Reading 'uid' as sellerId

    print("customerId from Firestore: $customerId");
    print("sellerId from Firestore (uid field): $sellerId");

    final result = CompleteOrderDataModel(
      orderId: doc.id,
      customerId: customerId,
      sellerId: sellerId,
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

    print("Created CompleteOrderDataModel with orderId: ${result.orderId}");
    print("===== ORDER MODEL fromFirestore END =====");

    return result;
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
    print("Creating OrderItemModel from cart item: ${cartItem.foodName}, dishId: $dishId");
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