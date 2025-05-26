import 'package:eco_eaters_app_3/core/utils/snack_bar_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/page_route_names.dart';
import '../../core/utils/validation.dart';
import '../../core/widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SellerSignUpScreen extends StatefulWidget {
  @override
  State<SellerSignUpScreen> createState() => _SellerSignUpScreenState();
}
class _SellerSignUpScreenState extends State<SellerSignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  String selectedBusinessType = 'Hotels';
  String selectedOperatingHours = '9:00 AM - 5:00 PM';
  bool deliveryAvailability = true; // تغيير من String إلى bool
  String? selectedCity;

  final businessTypes = [
    'Hotels',
    'Patisserie',
    'Bakeries',
  ];
  final operatingHours = [
    '9:00 AM - 5:00 PM',
    '10:00 AM - 6:00 PM',
    '12:00 PM - 8:00 PM',
  ];
  final cairoCities = [
    'Giza' ,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final verticalSpacing = size.height * 0.02;
    final horizontalPadding = size.width * 0.05;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: verticalSpacing),
                Row(
                  children: [
                    Image.asset(AppAssets.appLogo, height: size.height * 0.04),
                    SizedBox(width: size.width * 0.02),
                  ],
                ),
                SizedBox(height: verticalSpacing),

                /// Basic Information
                buildSection(
                  size: size,
                  title: "Basic Information",
                  children: [
                    CustomTextFormField(
                      filledColor: Colors.white,
                      controller: businessNameController,
                      hintText: "Enter business name",
                      validator:  Validations.ValidateBusinessName,
                    ),
                    SizedBox(height: verticalSpacing * 1.2),
                    CustomTextFormField(
                      filledColor: Colors.white,
                      controller: contactPersonController,
                      hintText: "Full name",
                      validator:  Validations.ValidateFullName,
                    ),
                    SizedBox(height: verticalSpacing * 1.2),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            filledColor: Colors.white,
                            controller: phoneController,
                            hintText: "Phone number",
                            validator: Validations.ValidatePhoneNumber,
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        Expanded(
                          child: CustomTextFormField(
                            filledColor: Colors.white,
                            controller: emailController,
                            hintText: "Email address",
                            validator: Validations.validateEmail,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: verticalSpacing * 1.2),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            filledColor: Colors.white,
                            controller: passwordController,
                            hintText: "Password",
                            isPassword: true,
                            validator:  Validations.validatePassword,
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        Expanded(
                          child: CustomTextFormField(
                            isPassword: true,
                            filledColor: Colors.white,
                            controller: rePasswordController,
                            hintText: "Re Password ",
                            validator: (text) =>
                            text == null || text.isEmpty ? "Required" : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: verticalSpacing),

                /// Business Details
                buildSection(
                  size: size,
                  title: "Business Details",
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedCity,
                      items: cairoCities
                          .map((city) => DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() => selectedCity = value);
                      },
                      decoration: InputDecoration(
                        labelText: "Location ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                      ),
                      validator: (value) =>
                      value == null || value.isEmpty ? "Required" : null,
                    ),
                    SizedBox(height: verticalSpacing * 1.2),

                    /// Business Type Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedBusinessType,
                      items: businessTypes
                          .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() => selectedBusinessType = value!);
                      },
                      decoration: InputDecoration(
                        labelText: "Business Type",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 1.2),

                    /// Operating Hours Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedOperatingHours,
                      items: operatingHours
                          .map((time) => DropdownMenuItem(
                        value: time,
                        child: Text(time),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() => selectedOperatingHours = value!);
                      },
                      decoration: InputDecoration(
                        labelText: "Operating Hours",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 1.2),

                    /// Delivery Availability Switch - تحديث التصميم
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Delivery Available",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                deliveryAvailability
                                    ? "Customers can order for delivery"
                                    : "Pickup only available",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: deliveryAvailability,
                            onChanged: (value) {
                              setState(() {
                                deliveryAvailability = value;
                              });
                            },
                            activeColor: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: verticalSpacing * 0.8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        try {
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );

                          final uid = userCredential.user?.uid;
                          if (uid != null) {
                            await FirebaseFirestore.instance.collection('users').doc(uid).set({
                              'uid': uid,
                              'userType': 'seller',
                              'businessName': businessNameController.text.trim(),
                              'contactPerson': contactPersonController.text.trim(),
                              'phone': phoneController.text.trim(),
                              'email': emailController.text.trim(),
                              'city': selectedCity,
                              'businessType': selectedBusinessType,
                              'operatingHours': selectedOperatingHours,
                              'deliveryAvailability': deliveryAvailability,  // حفظ كـ boolean
                              'createdAt': FieldValue.serverTimestamp(),
                            });

                            SnackBarServices.showSuccessMessage("Account Created Successfully");
                            Navigator.pushNamed(context, PagesRouteName.login);
                          }
                        } catch (e) {
                          SnackBarServices.showErrorMessage("Failed to Create Account: ${e.toString()}");
                        }
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding:
                      EdgeInsets.symmetric(vertical: size.height * 0.018),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                          color: Colors.white, fontSize: size.width * 0.045),
                    ),
                  ),
                ),
                SizedBox(height: verticalSpacing * 1.5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSection({
    required Size size,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.04),
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: size.width * 0.045, fontWeight: FontWeight.bold)),
          SizedBox(height: size.height * 0.015),
          ...children,
        ],
      ),
    );
  }
}