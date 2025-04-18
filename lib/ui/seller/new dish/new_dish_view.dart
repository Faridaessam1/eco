import 'dart:convert';
import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_eaters_app_3/core/FirebaseServices/firebase_firestore.dart';
import 'package:eco_eaters_app_3/core/data/dish_data_model.dart';
import 'package:eco_eaters_app_3/core/extentions/padding_ext.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import '../widgets/custom_status_container.dart';


class NewDishView extends StatefulWidget {
  const NewDishView({super.key});

  @override
  State<NewDishView> createState() => _NewDishViewState();
}

class _NewDishViewState extends State<NewDishView> {
  File? _image;
  String? _imageUrl;
  final formKey = GlobalKey<FormState>();
  final _dishNameController = TextEditingController();
  final _dishQuantityController = TextEditingController();
  final _dishPriceController = TextEditingController();
  final SingleSelectController<String?> _dishCategoryController = SingleSelectController(null);
  final _dishAdditionalInfoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final List<String> _sellerCategoriesList = [
      "Restaurant",
      "Hotel",
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          "Add New Item",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.green,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              var dishData = DishDataModel(
                  dishName: _dishNameController.text,
                  dishImage: _imageUrl,
                  dishQuantity: _dishQuantityController.text,
                  dishPrice: _dishPriceController.text,
                  dishCategory: _dishCategoryController.value?? 'Uncategorized',
                  dishAdditionalInfo: _dishAdditionalInfoController.text
              );
              if (formKey.currentState!.validate()){
                EasyLoading.show();
                FireBaseFirestoreServices.createNewDish(dishData).then(
                   (value) {
                     EasyLoading.dismiss();
                   }
                );
              }
            },
            child: CustomStatusContainer(
              orderStatus: "Save",
              isNewDishTab: true,
              orderStatusColor: AppColors.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: mediaQuery.size.width * 0.948,
                height: mediaQuery.size.height * 0.228,
                decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    image: _image != null
                        ? DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    border: Border.all(
                      color: AppColors.grey,
                      width: 2,
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.insert_photo_outlined),
                    Text(
                      "Upload food image",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textGreyColor),
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Text(
                        "Choose image",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.green),
                      ),
                    ),
                    GestureDetector(
                      onTap: _uploadImage,
                      child: Text(
                        "Upload image",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.green),
                      ),
                    ),
                    SizedBox(height: 10),
                    _imageUrl != null
                        ? Text(
                            "Image uploaded successfully!",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white),
                          )
                        : Text(
                            "No image uploaded yet",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Dish Name",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                hintText: "Enter Dish Name",
                hintTextColor: AppColors.textGreyColor,
                filledColor: AppColors.white,
                borderColor: AppColors.grey,
                controller: _dishNameController,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Quantity",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                hintText: "Enter quantity",
                hintTextColor: AppColors.textGreyColor,
                filledColor: AppColors.white,
                borderColor: AppColors.grey,
                controller: _dishQuantityController,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Price",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                hintText: "Enter price",
                hintTextColor: AppColors.textGreyColor,
                filledColor: AppColors.white,
                borderColor: AppColors.grey,
                controller: _dishPriceController,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Category",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black),
              ),
              SizedBox(
                height: 10,
              ),
              CustomDropdown<String>(
                hintText: 'Select Category',
                items: _sellerCategoriesList,
                initialItem: null,
                onChanged: (value) {},
                controller: _dishCategoryController,
                decoration: CustomDropdownDecoration(
                  closedBorder: Border.all(
                    color: AppColors.grey,
                    width: 1.8,
                  ),
                  closedBorderRadius: BorderRadius.circular(18),
                  closedSuffixIcon: Icon(
                    Icons.arrow_drop_down_rounded,
                    color: AppColors.green,
                    size: 28,
                  ),
                  expandedSuffixIcon: Icon(
                    Icons.arrow_drop_up_rounded,
                    color: AppColors.green,
                    size: 28,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Additional information",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                minLines: 1,
                maxLines: 5,
                hintText: "Enter additional details",
                hintTextColor: AppColors.textGreyColor,
                filledColor: AppColors.white,
                borderColor: AppColors.grey,
                controller: _dishAdditionalInfoController,
              ),
            ],
          ).setPadding(context, vertical: 0.01, horizontal: 0.04),
        ),
      ),
    );
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dbdwuvc3w/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'ml_default'
      ..files.add(await http.MultipartFile.fromPath('file', _image!.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);

      setState(() {
        _imageUrl = jsonMap['url'];
      });
    } else {
      print("Upload failed: ${response.reasonPhrase}");
    }
  }
}
