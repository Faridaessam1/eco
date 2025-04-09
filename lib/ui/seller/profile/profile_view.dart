import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:eco_eaters_app_3/Data/restaurant_model.dart';
import 'package:eco_eaters_app_3/core/extentions/padding_ext.dart';
import 'package:eco_eaters_app_3/core/utils/validation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../core/FirebaseServices/firebase_firestore.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/snack_bar_services.dart';
import '../../../core/widgets/custom_text_form_field.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String? selectedBusinessType;
  String? selectedOperatingHours;
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final List<String> _sellerCategoriesList = [
      "Restaurant",
      "Hotel",
    ];
    final List<String> _operatingHoursList = [
      "8:00 AM - 4PM",
      "9:00 AM - 5:00 PM",
      "10:00 AM - 6:00 PM"
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
                Icons.add_circle_outlined,
                color: AppColors.green,
                weight: 1,
              ),
              onPressed: () {
                var restaurantData = RestaurantDataModel(
                  restaurantName: _businessNameController.text,
                  restaurantImage: "",
                  contactPersonName: _contactPersonController.text,
                  restaurantCategory: "",
                  deliveryAvailability: true,
                  restaurantRating: "4.4",
                  restaurantAddress: _addressController.text,
                  phoneNumber: _phoneController.text,
                  operatingHours: selectedOperatingHours ?? "",
                  businessType: selectedBusinessType ?? "",
                );

                  try{
                  if (_formKey.currentState!.validate()) {
                    EasyLoading.show();
                    FireBaseFirestoreServices.createNewRestaurant(restaurantData)
                        .then((value) {
                      EasyLoading.dismiss();
                      if(value == true){
                        SnackBarServices.showSuccessMessage("Restaurant Created Successfully");

                      }
                    });
                  }
                }catch(e){
                    EasyLoading.dismiss();
                    SnackBarServices.showErrorMessage("An error occurred");

                  }


              },
            ),
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
                      items: _sellerCategoriesList,
                      initialItem: null,
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
                    const Text(
                      "Location",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      controller: _addressController,
                      hintText: "Enter Address",
                      hintTextColor: AppColors.textGreyColor,
                      filledColor: AppColors.white,
                      borderColor: AppColors.grey,
                      iconPath: AppAssets.locationIcon,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
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
                      items: _operatingHoursList,
                      initialItem: null,
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
              )
            ],
          ).setPadding(context, vertical: 0.01, horizontal: 0.03),
        ),
      ),
    );
  }
}
