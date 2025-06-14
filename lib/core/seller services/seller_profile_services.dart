import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../FirebaseServices/firebase_auth.dart';
import '../FirebaseServices/firebase_firestore_seller.dart';
import '../routes/page_route_names.dart';
import '../utils/snack_bar_services.dart';

class SellerProfileServices {
  static final ImagePicker _picker = ImagePicker();

  /// Load seller profile data from Firebase
  static Future<void> loadSellerProfileData({
    required TextEditingController businessNameController,
    required TextEditingController contactPersonController,
    required TextEditingController phoneController,
    required TextEditingController emailController,
    required Function(String?) onAddressSelected,
    required Function(String?) onBusinessTypeSelected,
    required Function(String?) onOperatingHoursSelected,
    required Function(bool) onDeliveryAvailabilitySelected,
  }) async {
    try {
      await FireBaseFirestoreServicesSeller.getSellerProfileData(
        businessNameController: businessNameController,
        contactPersonController: contactPersonController,
        phoneController: phoneController,
        emailController: emailController,
        onAddressSelected: onAddressSelected,
        onBusinessTypeSelected: onBusinessTypeSelected,
        onOperatingHoursSelected: onOperatingHoursSelected,
        onDeliveryAvailabilitySelected: onDeliveryAvailabilitySelected,
      );
    } catch (e) {
      print("Error loading seller profile data: $e");
      SnackBarServices.showErrorMessage("Failed to load profile data");
    }
  }

  /// Pick image from gallery or camera
  static Future<File?> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print("Error picking image: $e");
      SnackBarServices.showErrorMessage("Failed to pick image");
      return null;
    }
  }

  /// Upload image to Firebase Storage
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


  /// Update seller profile in Firebase
  static Future<void> updateProfile({
    required GlobalKey<FormState> formKey,
    required String businessName,
    required String contactPerson,
    required String phone,
    required String email,
    required String city,
    required String operatingHours,
    required String? businessType,
    required bool deliveryAvailability,
  }) async {
    try {
      // Validate the form before updating
      if (!(formKey.currentState?.validate() ?? false)) {
        SnackBarServices.showWarningMessage('Please fill in all fields correctly.');
        return;
      }

      // Show loading
      EasyLoading.show(status: 'Updating...');

      // Update profile in Firebase
      bool success = await FireBaseFirestoreServicesSeller.updateSellerProfile(
        businessName: businessName,
        contactPerson: contactPerson,
        phone: phone,
        email: email,
        city: city,
        operatingHours: operatingHours,
        businessType: businessType,
        deliveryAvailability: deliveryAvailability,
      );

      EasyLoading.dismiss();

      if (success) {
        SnackBarServices.showSuccessMessage("Profile Updated Successfully");
      } else {
        SnackBarServices.showErrorMessage("Failed to update profile. Try again.");
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Error updating profile: $e");
      SnackBarServices.showErrorMessage("Failed to update profile. Try again.");
    }
  }

  /// Logout user
  static Future<void> logout(BuildContext context) async {
    try {
      EasyLoading.show(status: 'Logging out...');
      await FirebaseFunctions.logout();
      EasyLoading.dismiss();
      Navigator.pushReplacementNamed(context, PagesRouteName.login);
    } catch (e) {
      EasyLoading.dismiss();
      print("Error during logout: $e");
      SnackBarServices.showErrorMessage("Failed to logout. Try again.");
    }
  }

  /// Get predefined seller categories
  static List<String> getSellerCategories() {
    return [
      'Bakeries',
      'Hotels',
      'Patisserie',
    ];
  }

  /// Get predefined operating hours
  static List<String> getOperatingHours() {
    return [
      '9:00 AM - 5:00 PM',
      '10:00 AM - 6:00 PM',
      '12:00 PM - 8:00 PM',
    ];
  }

  /// Get Cairo cities list
  static List<String> getCairoCities() {
    return [
      'Nasr City',
      'Heliopolis',
      'Maadi',
      'Zamalek',
      'New Cairo',
      '6th of October',
      'Mohandessin',
      'El Abbasia',
      'Shubra',
      'Downtown',
    ];
  }

  /// Validate form fields
  static bool validateFormFields({
    required String businessName,
    required String contactPerson,
    required String phone,
    required String email,
    String? businessType,
    String? address,
    String? operatingHours,
  }) {
    if (businessName.isEmpty ||
        contactPerson.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        businessType == null ||
        address == null ||
        operatingHours == null) {
      return false;
    }
    return true;
  }

  /// Show validation error message
  static void showValidationError() {
    SnackBarServices.showWarningMessage('Please fill in all fields correctly.');
  }

  /// Handle image selection with error handling
  static Future<File?> handleImageSelection() async {
    try {
      return await pickImage();
    } catch (e) {
      print("Error handling image selection: $e");
      SnackBarServices.showErrorMessage("Failed to select image");
      return null;
    }
  }

  /// Handle image upload with comprehensive error handling
  static Future<String?> handleImageUpload(File image) async {
    try {
      String? downloadUrl;

      await uploadAndSaveImage(
        image: image,
        onSuccess: (url) {
          downloadUrl = url;
        },
        onError: (error) {
          throw Exception(error);
        },
      );
      return downloadUrl;
    } catch (e) {
      print("Error handling image upload: $e");
      SnackBarServices.showErrorMessage("Failed to upload image");
      return null;
    }
  }
}
