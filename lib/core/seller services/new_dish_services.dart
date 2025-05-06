import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../Data/dish_data_model.dart';

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
}
