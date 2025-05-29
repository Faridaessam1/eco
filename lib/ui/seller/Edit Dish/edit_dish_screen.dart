import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../Data/seller_available_dish_data_model.dart';
import '../../../core/FirebaseServices/firebase_firestore_seller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/snack_bar_services.dart';

class EditDishPage extends StatefulWidget {
  final SellerAvailableDishDataModel dish;

  const EditDishPage({
    super.key,
    required this.dish,
  });

  @override
  State<EditDishPage> createState() => _EditDishPageState();
}

class _EditDishPageState extends State<EditDishPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dishNameController = TextEditingController();
  final TextEditingController _dishPriceController = TextEditingController();

  File? _imageFile;
  String? _imageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _dishNameController.text = widget.dish.dishName;
    _dishPriceController.text = widget.dish.dishPrice;
    _imageUrl = widget.dish.dishImage;
  }

  Future<void> _updateDish() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      await FireBaseFirestoreServicesSeller.updateDish(
        sellerId: currentUserId,
        dishId: widget.dish.id,
        dishName: _dishNameController.text.trim(),
        dishPrice: double.parse(_dishPriceController.text.trim()),
      );
      EasyLoading.show();
      SnackBarServices.showSuccessMessage("Dish updated successfully!");
      EasyLoading.dismiss();
      Navigator.pop(context, true);
    } catch (e) {
      EasyLoading.show();
      SnackBarServices.showErrorMessage("Failed to update dish");
      EasyLoading.dismiss();
    }
  }

  Future<void> _deleteDish() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Dish'),
        content: const Text('Are you sure you want to delete this dish? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

        await FireBaseFirestoreServicesSeller.deleteDish(
          sellerId: currentUserId,
          dishId: widget.dish.id,
        );
        EasyLoading.show();
        SnackBarServices.showSuccessMessage("Dish Deleted successfully!");
        EasyLoading.dismiss();
        Navigator.pop(context, true);
      } catch (e) {
        EasyLoading.show();
        SnackBarServices.showErrorMessage("Failed to Delete dish");
        EasyLoading.dismiss();

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Dish',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _isLoading ? null : _deleteDish,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Image Section
            SizedBox(
              height: 200,
              width: double.infinity,
              child: _imageFile != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                ),
              )
                  : _imageUrl != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _imageUrl!,
                  fit: BoxFit.cover,
                ),
              )
                  : const Center(child: Text('No image selected')),
            ),

            const SizedBox(height: 24),

            // Dish Name
            TextFormField(
              controller: _dishNameController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'Dish Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Enter dish name' : null,
            ),

            const SizedBox(height: 16),

            // Dish Price
            TextFormField(
              controller: _dishPriceController,
              enabled: !_isLoading,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price (EGP)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Update Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateDish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Update Dish',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dishNameController.dispose();
    _dishPriceController.dispose();
    super.dispose();
  }
}
