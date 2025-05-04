import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:eco_eaters_app_3/core/extentions/padding_ext.dart';
import 'package:eco_eaters_app_3/core/routes/page_route_names.dart';
import 'package:eco_eaters_app_3/core/utils/validation.dart';
import 'package:eco_eaters_app_3/core/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../core/FirebaseServices/firebase_auth.dart';
import '../../../core/FirebaseServices/firebase_firestore_seller.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/seller services/seller_profile_services.dart';
import '../../../core/utils/snack_bar_services.dart';
import '../../../core/widgets/custom_text_form_field.dart';

class SellerProfileView extends StatefulWidget {
  const SellerProfileView({super.key});

  @override
  State<SellerProfileView> createState() => _SellerProfileViewState();
}

class _SellerProfileViewState extends State<SellerProfileView> {
  String? selectedBusinessType;
  String? selectedOperatingHours;
  String? selectedAddress;
  File? _image;
  String? _imageUrl;

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // تحميل باقي البيانات
    FireBaseFirestoreServicesSeller.getSellerProfileData(
      businessNameController: _businessNameController,
      contactPersonController: _contactPersonController,
      phoneController: _phoneController,
      emailController: _emailController,
      onAddressSelected: (value) {
        setState(() {
          selectedAddress = value;
        });
      },
      onBusinessTypeSelected: (value) {
        setState(() {
          selectedBusinessType = value;
        });
      },
      onOperatingHoursSelected: (value) {
        setState(() {
          selectedOperatingHours = value;
        });
      },
    );

    // تحميل رابط صورة البائع من Firestore
    _loadSellerImage(); // دي فانكشن بسيطة تحت
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final List<String> sellerCategoriesList = [
      'Restaurant',
      'Hotel',
      'Patisserie',
      'Fast Food',
    ];
    final List<String> operatingHoursList = [
      '9:00 AM - 5:00 PM',
      '10:00 AM - 6:00 PM',
      '12:00 PM - 8:00 PM',
    ];
    final List<String> cairoCities = [
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

    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          leading: Image.asset(AppAssets.ecoEaterIcon),
          title: const Text(
            "EcoEaters",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.green,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: AppColors.green,
                weight: 1,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: mediaQuery.size.width * 0.948,
                height: mediaQuery.size.height * 0.228,
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  image: _imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(_imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : _image != null
                          ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            )
                          : null,
                  border: Border.all(
                    color: AppColors.grey,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.insert_photo_outlined),
                    const Text(
                      "Upload your restaurant image",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textGreyColor),
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: const Text(
                        "Choose image",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.green),
                      ),
                    ),
                    if (_image != null)
                      GestureDetector(
                      onTap: _uploadImage,
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
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.green,
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Basic information",
                      style: TextStyle(
                          color: AppColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Business Name",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      controller: _businessNameController,
                      hintText: "Enter business Name",
                      hintTextColor: AppColors.textGreyColor,
                      filledColor: AppColors.white,
                      borderColor: AppColors.grey,
                      validator:Validations.ValidateBusinessName,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Contact person",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      controller: _contactPersonController,
                      hintText: "Full name",
                      hintTextColor: AppColors.textGreyColor,
                      filledColor: AppColors.white,
                      borderColor: AppColors.grey,
                      validator:Validations.ValidateFullName,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                "Phone",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                controller: _phoneController,
                                hintText: "Phone number",
                                hintTextColor: AppColors.textGreyColor,
                                filledColor: AppColors.white,
                                borderColor: AppColors.grey,
                                validator: Validations.ValidatePhoneNumber,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                "Email",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                controller: _emailController,
                                hintText: "Email Address",
                                hintTextColor: AppColors.textGreyColor,
                                filledColor: AppColors.white,
                                borderColor: AppColors.grey,
                                validator: Validations.validateEmail,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.green,
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Business Details",
                      style: TextStyle(
                          color: AppColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Business type",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomDropdown<String>(
                      hintText: 'Select business type',
                      items: sellerCategoriesList,
                      initialItem: selectedBusinessType,
                      onChanged: (value) {
                        setState(() {
                          selectedBusinessType = value;
                        });
                      },
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
                    const SizedBox(
                      height: 20,
                    ),
                    CustomDropdown<String>(
                      hintText: 'Select location',
                      items: cairoCities,
                      initialItem: selectedAddress,
                      onChanged: (value) {
                        setState(() {
                          selectedAddress = value;
                        });
                      },
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


                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Operating hours",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomDropdown<String>(
                      hintText: 'Operating hours',
                      items: operatingHoursList,
                      initialItem:selectedOperatingHours,
                      onChanged: (value) {
                        setState(() {
                          selectedOperatingHours = value;
                        });

                      },
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
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: () async {
                        // Validate the form before updating
                        if (_formKey.currentState?.validate() ?? false) {
                          // If the form is valid, proceed with the update
                          bool success = await FireBaseFirestoreServicesSeller
                              .updateSellerProfile(
                            businessName: _businessNameController.text,
                            contactPerson: _contactPersonController.text,
                            phone: _phoneController.text,
                            email: _emailController.text,
                            city: selectedAddress ?? "",
                            operatingHours: selectedOperatingHours ?? '',
                            businessType: selectedBusinessType,
                          );

                          if (success) {
                            // Show a success message or navigate to another screen
                            EasyLoading.show();
                            SnackBarServices.showSuccessMessage("Account Updated Successfully");
                            EasyLoading.dismiss();
                          } else {
                            // Show an error message
                            EasyLoading.show();
                            SnackBarServices.showErrorMessage("Failed to update profile. Try again.");
                            EasyLoading.dismiss();
                          }
                        } else {
                          // If the form is not valid, show a message
                          EasyLoading.show();
                          SnackBarServices.showWarningMessage('Please fill in all fields correctly.');
                          EasyLoading.dismiss();
                        }
                      },
                      text: "Update Profile",
                      buttonColor: AppColors.primaryColor,
                      textColor: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      borderRadius: 18,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: () async {
                        await FirebaseFunctions.logout();
                        Navigator.pushReplacementNamed(context,PagesRouteName.login);
                      },
                      text: "Logout",
                      buttonColor: AppColors.primaryColor,
                      textColor: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      borderRadius: 18,
                    ),
                  ),
                ],
              )
            ],
          ).setPadding(context, vertical: 0.01, horizontal: 0.03),
        ),
      ),
    );
  }
  void _pickImage() async {
    final picked = await SellerProfileServices.pickImage();
    if (picked != null) {
      setState(() {
        _image = picked;
      });
    }
  }

  void _uploadImage() async {
    if (_image == null) return;
    await SellerProfileServices.uploadAndSaveImage(
      image: _image!,
      onSuccess: (url) {
        setState(() {
          _imageUrl = url;
        });
      },
      onError: (error) {
        print("Image upload error: $error");
        // Show a snackbar or alert if needed
      },
    );
  }

  void _loadSellerImage() async {
    final url = await SellerProfileServices.fetchSellerImageUrl();
    if (url != null) {
      setState(() {
        _imageUrl = url;
      });
    }
  }
}
