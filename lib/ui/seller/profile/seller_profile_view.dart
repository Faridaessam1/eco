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
  bool deliveryAvailability = false;
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
    _initializeData();
  }

  void _initializeData() async {
    await SellerProfileServices.loadSellerProfileData(
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
      onDeliveryAvailabilitySelected: (value) {
        setState(() {
          deliveryAvailability = value;
        });
      },
    );

    final imageUrl = await SellerProfileServices.fetchSellerImageUrl();
    if (imageUrl != null) {
      setState(() {
        _imageUrl = imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final List<String> sellerCategoriesList = [
      'Bakeries',
      'Hotels',
      'Patisserie',
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
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, PagesRouteName.sellerHomeLayout, (route) => false);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildImageUploadSection(mediaQuery),
              const SizedBox(height: 30),
              _buildBasicInformationSection(),
              const SizedBox(height: 30),
              _buildBusinessDetailsSection(sellerCategoriesList, cairoCities, operatingHoursList),
              const SizedBox(height: 15),
              _buildActionButtons(),
            ],
          ).setPadding(context, vertical: 0.01, horizontal: 0.03),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection(MediaQueryData mediaQuery) {
    return Container(
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
    );
  }

  Widget _buildBasicInformationSection() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.green,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Text(
            "Basic information",
            style: TextStyle(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          const Text(
            "Business Name",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.black),
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            controller: _businessNameController,
            hintText: "Enter business Name",
            hintTextColor: AppColors.textGreyColor,
            filledColor: AppColors.white,
            borderColor: AppColors.grey,
            validator: Validations.ValidateBusinessName,
          ),
          const SizedBox(height: 20),
          const Text(
            "Contact person",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.black),
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            controller: _contactPersonController,
            hintText: "Full name",
            hintTextColor: AppColors.textGreyColor,
            filledColor: AppColors.white,
            borderColor: AppColors.grey,
            validator: Validations.ValidateFullName,
          ),
          const SizedBox(height: 20),
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
                    const SizedBox(height: 10),
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
              const SizedBox(width: 20),
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
                    const SizedBox(height: 10),
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
    );
  }

  Widget _buildBusinessDetailsSection(List<String> sellerCategoriesList,
      List<String> cairoCities, List<String> operatingHoursList) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.green,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Text(
            "Business Details",
            style: TextStyle(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          const Text(
            "Business type",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.black),
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 20),
          const Text(
            "Location",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.black),
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 20),
          const Text(
            "Operating hours",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.black),
          ),
          const SizedBox(height: 10),
          CustomDropdown<String>(
            hintText: 'Operating hours',
            items: operatingHoursList,
            initialItem: selectedOperatingHours,
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
          const SizedBox(height: 20),
          const Text(
            "Delivery Service",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.black),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.grey,
                width: 1.8,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  deliveryAvailability ? "Delivery Available" : "No Delivery",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: deliveryAvailability ? AppColors.green : AppColors.textGreyColor,
                  ),
                ),
                Switch(
                  value: deliveryAvailability,
                  onChanged: (value) {
                    setState(() {
                      deliveryAvailability = value;
                    });
                  },
                  activeColor: AppColors.green,
                  inactiveThumbColor: AppColors.grey,
                  inactiveTrackColor: AppColors.grey.withOpacity(0.3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomElevatedButton(
            onPressed: _updateProfile,
            text: "Update Profile",
            buttonColor: AppColors.primaryColor,
            textColor: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            borderRadius: 18,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CustomElevatedButton(
            onPressed: _logout,
            text: "Logout",
            buttonColor: AppColors.primaryColor,
            textColor: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            borderRadius: 18,
          ),
        ),
      ],
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
    await SellerProfileServices.uploadImage(
      image: _image!,
      onSuccess: (url) {
        setState(() {
          _imageUrl = url;
        });
      },
    );
  }

  void _updateProfile() async {
    await SellerProfileServices.updateProfile(
      formKey: _formKey,
      businessName: _businessNameController.text,
      contactPerson: _contactPersonController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      city: selectedAddress ?? "",
      operatingHours: selectedOperatingHours ?? '',
      businessType: selectedBusinessType,
      deliveryAvailability: deliveryAvailability,
    );
  }

  void _logout() async {
    await SellerProfileServices.logout(context);
  }
}