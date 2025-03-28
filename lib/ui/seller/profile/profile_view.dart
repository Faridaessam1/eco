import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:eco_eaters_app_3/core/extentions/padding_ext.dart';

import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_text_form_field.dart';


class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

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

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: Image.asset(AppAssets.ecoEaterIcon),
        title: Text(
          "EcoEaters",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.green,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: AppColors.green,
              weight: 1,
            ),
            onPressed: () {},
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.green,
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Basic information",
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Business Name",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    hintText: "Enter business Name",
                    hintTextColor: AppColors.textGreyColor,
                    filledColor: AppColors.white,
                    borderColor: AppColors.grey,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Contact person",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    hintText: "Full name",
                    hintTextColor: AppColors.textGreyColor,
                    filledColor: AppColors.white,
                    borderColor: AppColors.grey,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Phone",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              hintText: "Phone number",
                              hintTextColor: AppColors.textGreyColor,
                              filledColor: AppColors.white,
                              borderColor: AppColors.grey,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Email",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              hintText: "Email Address",
                              hintTextColor: AppColors.textGreyColor,
                              filledColor: AppColors.white,
                              borderColor: AppColors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.green,
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Business Details",
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Business type",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomDropdown<String>(
                    hintText: 'Select business type',
                    items: _sellerCategoriesList,
                    initialItem: null,
                    onChanged: (value) {},
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
                    "Location",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    hintText: "Enter location",
                    hintTextColor: AppColors.textGreyColor,
                    filledColor: AppColors.white,
                    borderColor: AppColors.grey,
                    iconPath: AppAssets.locationIcon,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Operating hours",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomDropdown<String>(
                    hintText: 'Operating hours',
                    items: _operatingHoursList,
                    initialItem: null,
                    onChanged: (value) {},
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
                ],
              ),
            )
          ],
        ).setPadding(context, vertical: 0.01, horizontal: 0.03),
      ),
    );
  }
}
