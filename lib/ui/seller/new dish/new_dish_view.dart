import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:eco_eaters_app_3/core/extentions/padding_ext.dart';
import 'package:eco_eaters_app_3/core/routes/page_route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../Data/dish_data_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/seller services/new_dish_services.dart';
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
  final SingleSelectController<String?> _dishCategoryController =
      SingleSelectController(null);
  final _dishAdditionalInfoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final List<String> _sellerCategoriesList = [
      "Restaurant",
      "Hotel",
      "Fast Food",
      "Desserts",
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Add New Item",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.green,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              if (!formKey.currentState!.validate()) return;
              final dish = DishDataModel(
                dishName: _dishNameController.text.trim(),
                dishQuantity: int.parse(_dishQuantityController.text.trim()),
                dishPrice: double.parse(_dishPriceController.text.trim()),
                dishCategory: _dishCategoryController.value ?? "",
                dishAdditionalInfo: _dishAdditionalInfoController.text.trim(),
                dishImage: _imageUrl ?? "",
                dishId: '',
              );

              try {
                await NewDishServices.addDishToFirestore(dish);
                EasyLoading.showSuccess("Dish Added Successfully!");
                Navigator.pushNamed(context, PagesRouteName.sellerHomeLayout);
              } catch (e) {
                print("❌ Failed to save dish: $e");
                EasyLoading.showError("Failed to add dish");
              }
            },
            child: CustomStatusContainer(
              orderStatus: "Save",
              isNewDishTab: true,
              orderStatusColor: AppColors.white,
            ),
          ),
          const SizedBox(width: 10),
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
                    const Icon(Icons.insert_photo_outlined),
                    const Text(
                      "Upload food image",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textGreyColor),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final image = await NewDishServices.pickImage();
                        if (image != null) {
                          setState(() {
                            _image = image;
                          });
                        }
                      },
                      child: const Text(
                        "Choose image",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.green),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_image == null) return;
                        final url = await NewDishServices.uploadImage(_image!);
                        if (url != null) {
                          setState(() {
                            _imageUrl = url;
                          });
                        }
                      },
                      child: const Text(
                        "Upload image",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.green),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _imageUrl != null
                        ? const Text(

                      "Image uploaded successfully!",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white),
                    )

                        : const Text(
                      "No image uploaded yet",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text("Dish Name",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black)),
              const SizedBox(height: 10),
              CustomTextFormField(
                hintText: "Enter Dish Name",
                hintTextColor: AppColors.textGreyColor,
                filledColor: AppColors.white,
                borderColor: AppColors.grey,
                controller: _dishNameController,
              ),
              const SizedBox(height: 20),
              const Text("Quantity",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black)),
              const SizedBox(height: 10),
              CustomTextFormField(
                hintText: "Enter quantity",
                hintTextColor: AppColors.textGreyColor,
                filledColor: AppColors.white,
                borderColor: AppColors.grey,
                controller: _dishQuantityController,
              ),
              const SizedBox(height: 20),
              const Text("Price",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black)),
              const SizedBox(height: 10),
              CustomTextFormField(
                hintText: "Enter price",
                hintTextColor: AppColors.textGreyColor,
                filledColor: AppColors.white,
                borderColor: AppColors.grey,
                controller: _dishPriceController,
              ),
              const SizedBox(height: 20),
              const Text("Category",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black)),
              const SizedBox(height: 10),
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
                  closedSuffixIcon: const Icon(
                    Icons.arrow_drop_down_rounded,
                    color: AppColors.green,
                    size: 28,
                  ),
                  expandedSuffixIcon: const Icon(
                    Icons.arrow_drop_up_rounded,
                    color: AppColors.green,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Additional information",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black)),
              const SizedBox(height: 10),
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
}