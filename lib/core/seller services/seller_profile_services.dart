import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class SellerProfileServices {
  static Future<File?> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  static Future<void> uploadAndSaveImage({
    required File image,
    required Function(String imageUrl) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      final imageUrl = await uploadImageToCloudinary(image);
      if (imageUrl != null) {
        await saveImageUrlToFirestore(imageUrl);
        onSuccess(imageUrl);
      } else {
        onError('Upload failed');
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  static Future<String?> uploadImageToCloudinary(File imageFile) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dbdwuvc3w/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'ml_default'
      ..fields['folder'] = 'restaurant'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      return jsonMap['secure_url'];
    } else {
      print("Upload failed: ${response.reasonPhrase}");
      return null;
    }
  }

  static Future<void> saveImageUrlToFirestore(String imageUrl) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'sellerProfileImage': imageUrl,
    });
  }

  static Future<String?> fetchSellerImageUrl() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (doc.exists && doc.data()?['sellerProfileImage'] != null) {
      return doc['sellerProfileImage'];
    }
    return null;
  }
}
