import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Data/dish_data_model.dart';

class SaveDishResult {
  final bool success;
  final String message;

  SaveDishResult({required this.success, required this.message});
}

class NewDishServices {
  static Future<File?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  static Future<String?> uploadImage(File image) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dbdwuvc3w/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'ml_default'
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      return jsonMap['url'];
    } else {
      print("Upload failed: ${response.reasonPhrase}");
      return null;
    }
  }

  static Future<void> addDishToFirestore(DishDataModel dish) async {
    String sellerId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(sellerId)
        .collection("dishes")
        .add(dish.toFireStore());
  }

  static Future<SaveDishResult> saveDish({
    required GlobalKey<FormState> formKey,
    required String dishName,
    required String dishQuantity,
    required String dishPrice,
    required String dishCategory,
    required String dishAdditionalInfo,
    required String imageUrl,
  }) async {
    try {
      // Validate form
      if (!formKey.currentState!.validate()) {
        return SaveDishResult(
            success: false,
            message: "Please fill all required fields"
        );
      }

      // Parse and validate numeric values
      int? quantity = int.tryParse(dishQuantity);
      double? price = double.tryParse(dishPrice);

      if (quantity == null) {
        return SaveDishResult(
            success: false,
            message: "Please enter a valid quantity"
        );
      }

      if (price == null) {
        return SaveDishResult(
            success: false,
            message: "Please enter a valid price"
        );
      }

      // Create dish model
      final dish = DishDataModel(
        dishName: dishName,
        dishQuantity: quantity,
        dishPrice: price,
        dishCategory: dishCategory,
        dishAdditionalInfo: dishAdditionalInfo,
        dishImage: imageUrl,
        dishId: '',
      );

      // Save to Firestore
      await addDishToFirestore(dish);

      return SaveDishResult(
          success: true,
          message: "Dish Added Successfully!"
      );
    } catch (e) {
      print("❌ Failed to save dish: $e");
      return SaveDishResult(
          success: false,
          message: "Failed to add dish"
      );
    }
  }
}
