import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

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
  static Future<void> uploadImage({
    required File image,
    required Function(String) onSuccess,
  }) async {
    try {
      EasyLoading.show(status: 'Uploading image...');

      await uploadAndSaveImage(
        image: image,
        onSuccess: (url) {
          onSuccess(url);
          EasyLoading.dismiss();
          SnackBarServices.showSuccessMessage("Image uploaded successfully!");
        },
        onError: (error) {
          EasyLoading.dismiss();
          print("Image upload error: $error");
          SnackBarServices.showErrorMessage("Failed to upload image. Try again.");
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
      print("Error in uploadImage: $e");
      SnackBarServices.showErrorMessage("Failed to upload image");
    }
  }

  /// Upload and save image to Firebase (wrapper for your existing method)
  static Future<void> uploadAndSaveImage({
    required File image,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    // This should call your existing upload method
    // Replace this with your actual implementation
    try {
      // Your existing upload logic here
      // Example:
      // String downloadUrl = await FirebaseStorageService.uploadImage(image);
      // onSuccess(downloadUrl);
    } catch (e) {
      onError(e.toString());
    }
  }

  /// Fetch seller image URL from Firebase
  static Future<String?> fetchSellerImageUrl() async {
    try {
      // Replace this with your actual implementation
      // return await FirebaseStorageService.getSellerImageUrl();
      return null; // Placeholder
    } catch (e) {
      print("Error fetching seller image URL: $e");
      return null;
    }
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

      await uploadImage(
        image: image,
        onSuccess: (url) {
          downloadUrl = url;
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
