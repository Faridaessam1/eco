import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get customer details from Firestore
  Future<Map<String, dynamic>> getCustomerDetails(String customerId) async {
    try {
      print("Fetching customer details for ID: $customerId");
      final userDoc = await _firestore.collection('users').doc(customerId).get();

      if (!userDoc.exists) {
        print("Customer document does not exist");
        return {};
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      print("Fetched customer data: ${userData.toString()}");

      return {
        'name': userData['name'] ?? userData['fullName'] ?? userData['displayName'] ?? 'Unknown Customer',
        'phone': userData['phone'] ?? userData['phoneNumber'] ?? '',
        'address': userData['address'] ?? userData['deliveryAddress'] ?? '',
      };
    } catch (e) {
      print("Error fetching customer details: $e");
      return {
        'name': 'Unknown Customer',
        'phone': '',
        'address': '',
      };
    }
  }

  // Get seller details from Firestore
  Future<Map<String, dynamic>> getSellerDetails(String sellerId) async {
    try {
      print("Fetching seller details for ID: $sellerId");

      // First check in 'sellers' collection
      var sellerDoc = await _firestore.collection('sellers').doc(sellerId).get();

      // If not found in sellers collection, check in users collection
      if (!sellerDoc.exists) {
        sellerDoc = await _firestore.collection('users').doc(sellerId).get();
      }

      if (!sellerDoc.exists) {
        print("Seller document does not exist in either collection");
        return {};
      }

      final sellerData = sellerDoc.data() as Map<String, dynamic>;
      print("Fetched seller data: ${sellerData.toString()}");

      return {
        'name': sellerData['businessName'] ?? sellerData['name'] ?? 'Unknown Restaurant',
        'phone': sellerData['phone'] ?? sellerData['phoneNumber'] ?? '',
        'address': sellerData['address'] ?? sellerData['businessAddress'] ?? '',
      };
    } catch (e) {
      print("Error fetching seller details: $e");
      return {
        'name': 'Unknown Restaurant',
        'phone': '',
        'address': '',
      };
    }
  }
}