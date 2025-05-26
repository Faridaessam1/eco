import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_eaters_app_3/Data/dish_data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../../Data/order_data_model.dart';

abstract class FireBaseFirestoreServicesSeller {

  Future<void> addDishSubCollection(String sellerId, DishDataModel dish) async {
    DocumentReference sellerDocRef = FirebaseFirestore.instance.collection('users').doc(sellerId);
    await sellerDocRef.collection('dishes').add(dish.toFireStore());
  }

  Future<void> createOrderSubCollection(String sellerId, String customerId, OrderDataModel order) async {
    DocumentReference sellerDocRef = FirebaseFirestore.instance.collection('users').doc(sellerId);
    DocumentReference customerDocRef = FirebaseFirestore.instance.collection('users').doc(customerId);

    // إضافة الطلب في مجموعة "orders" الخاصة بـ Seller
    await sellerDocRef.collection('orders').add(order.toFireStore());

    // إضافة الطلب في مجموعة "orders" الخاصة بـ Customer
    await customerDocRef.collection('orders').add(order.toFireStore());
  }

  static Stream<QuerySnapshot<DishDataModel>> getSellerDishesStream(
      String userId) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection('dishes')
        .withConverter<DishDataModel>(
      fromFirestore: (snapshot, _) => DishDataModel.fromFirestore(snapshot),
      toFirestore: (model, _) => model.toFireStore(),
    )
        .snapshots();
  }

  static Future<void> getSellerProfileData({
    required TextEditingController businessNameController,
    required TextEditingController contactPersonController,
    required TextEditingController phoneController,
    required TextEditingController emailController,
    required Function(String) onAddressSelected,
    required Function(String?) onBusinessTypeSelected,
    required Function(String?) onOperatingHoursSelected,
    required Function(bool) onDeliveryAvailabilitySelected,  // إضافة جديدة
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    try{
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;

        businessNameController.text = data['businessName'] ;
        contactPersonController.text = data['contactPerson'];
        phoneController.text = data['phone'] ;
        emailController.text = data['email'] ;

        onAddressSelected(data['city']?.toString().trim() ?? 'No address available');
        onBusinessTypeSelected(data['businessType']?.toString().trim());
        onOperatingHoursSelected(data['operatingHours']?.toString().trim());
        // Handle both field names for backward compatibility
        bool deliveryAvail = false;
        if (data.containsKey('deliveryAvailability')) {
          deliveryAvail = data['deliveryAvailability'] ?? false;
        } else if (data.containsKey('deliveryAvailable')) {
          String? deliveryStr = data['deliveryAvailable']?.toString();
          deliveryAvail = deliveryStr?.toLowerCase() == 'yes' || deliveryStr?.toLowerCase() == 'true';
        }
        onDeliveryAvailabilitySelected(deliveryAvail);

      }
    } catch(e){
      print("Error fetching seller data: $e");
    }
  }

  // update function
  static Future<bool> updateSellerProfile({
    required String businessName,
    required String contactPerson,
    required String phone,
    required String email,
    required String city,
    required String operatingHours,
    String? businessType,
    required bool deliveryAvailability,  // إضافة جديدة
  }) async {
    try {
      var userId =
          FirebaseAuth.instance.currentUser?.uid; // Get the current user's ID

      if (userId != null) {
        // Reference to the user document
        var userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

        // Check if the document exists
        var docSnapshot = await userDocRef.get();
        if (!docSnapshot.exists) {
          print("No document found for the current user.");
          return false;
        }

        // Update the fields inside the user document
        await userDocRef.update({
          'businessName': businessName,
          'contactPerson': contactPerson,
          'phone': phone,
          'email': email,
          'city': city,
          'operatingHours': operatingHours,
          'businessType': businessType ?? docSnapshot.data()?['businessType'],
          'deliveryAvailability': deliveryAvailability,  // إضافة جديدة
          // Retains old value if businessType is null
        });

        return true;
      }
      return false;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  // دالة جديدة للحصول على delivery availability للسيلر معين
  static Future<bool> getSellerDeliveryAvailability(String sellerId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(sellerId)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;

        // Handle both field names for backward compatibility
        if (data.containsKey('deliveryAvailability')) {
          return data['deliveryAvailability'] ?? false;
        } else if (data.containsKey('deliveryAvailable')) {
          String? deliveryStr = data['deliveryAvailable']?.toString();
          return deliveryStr?.toLowerCase() == 'yes' || deliveryStr?.toLowerCase() == 'true';
        }

        return false;
      }
      return false;
    } catch (e) {
      print("Error fetching seller delivery availability: $e");
      return false;
    }
  }
}