import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class FireBaseFirestoreServicesCustomer{

  static Future<void> getCustomerProfileData({
    required TextEditingController nameController,
    required TextEditingController phoneController,
    required TextEditingController emailController,
    required VoidCallback onDataLoaded,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;

        nameController.text = data['name'] ;
        phoneController.text = data['phone'];
        emailController.text = data['email'];
        onDataLoaded();
      }
    } catch (e) {
      print("Error fetching customer data: $e");
    }
  }


  static Future<bool> updateCustomerProfile({
    required String name,
    required String phone,
    required String email,
  }) async {
    try {
      var userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        var userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

        var docSnapshot = await userDocRef.get();
        if (!docSnapshot.exists) {
          print("No document found for the current customer.");
          return false;
        }

        await userDocRef.update({
          'name': name,
          'phone': phone,
          'email': email,
        });

        return true;
      }
      return false;
    } catch (e) {
      print('Error updating customer profile: $e');
      return false;
    }
  }

}