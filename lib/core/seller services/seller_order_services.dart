import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../Data/order_data_model.dart';

class SellerOrderServices {
  static String? getSellerId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  static Stream<List<OrderDataModel>> getOrdersStream() {
    final sellerId = getSellerId();
    if (sellerId == null) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(sellerId)
        .collection('orders')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OrderDataModel.fromFireStore(data, doc.id);
      }).toList();
    });
  }

  static Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final sellerId = getSellerId();
    if (sellerId == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(sellerId)
        .collection('orders')
        .doc(orderId)
        .update({'orderStatus': newStatus});
  }

  static List<OrderDataModel> filterOrders(
      List<OrderDataModel> orders, int selectedIndex) {
    switch (selectedIndex) {
      case 1:
        return orders.where((order) => order.orderStatus == "Pending").toList();
      case 2:
        return orders.where((order) => order.orderStatus == "In Progress").toList();
      case 3:
        return orders.where((order) => order.orderStatus == "Completed").toList();
      default:
        return orders;
    }
  }
}
