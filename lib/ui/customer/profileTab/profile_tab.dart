
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../core/FirebaseServices/firebas_firestore_customer.dart';
import '../../../core/FirebaseServices/firebase_auth.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/page_route_names.dart';
import '../../../core/utils/snack_bar_services.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../core/widgets/custom_text_form_field.dart';


class ProfileTab extends StatefulWidget{
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    FireBaseFirestoreServicesCustomer.getCustomerProfileData(
      nameController: _fullNameController,
      phoneController: _phoneController,
      emailController: _emailController,
      onDataLoaded: () {
        setState(() {});
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          AppAssets.appLogo,
          height: height * 0.02,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Text(
                "Hello,\n ${_fullNameController.text.trim()}",
                style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: height * 0.06,),
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: (){
                          Navigator.pushNamed(context,PagesRouteName.customerOrdersScreen);
                        },
                        text: "Your Orders ",
                        buttonColor: AppColors.primaryColor,
                        textColor: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        borderRadius: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.03,),
                const Text("Account Information" ,
                  style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ), ),
                SizedBox(height: height * 0.03,),


                const Text("FullName" ,
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                  ), ),
                SizedBox(height: height * 0.02,),
                CustomTextFormField(
                  controller: _fullNameController ,
                  hintText: "FullName",
                  filledColor: AppColors.white,
                  borderColor: AppColors.black,
                  hintTextColor: AppColors.grey,
                ),
                SizedBox(height: height * 0.03,),

                const Text("Email" ,
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                  ), ),
                SizedBox(height: height * 0.02,),
                CustomTextFormField(
                  controller: _emailController,
                  hintText: "Email",
                  filledColor: AppColors.white,
                  borderColor: AppColors.black,
                  hintTextColor: AppColors.grey,
                ),
                SizedBox(height: height * 0.03,),

                const Text("Phone Number" ,
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                  ), ),
                SizedBox(height: height * 0.02,),
                CustomTextFormField(
                  controller: _phoneController,
                  hintText: "Phone Number",
                  filledColor: AppColors.white,
                  borderColor: AppColors.black,
                  hintTextColor: AppColors.grey,
                ),
                SizedBox(height: height * 0.03,),

                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false){
                            bool success = await FireBaseFirestoreServicesCustomer
                                .updateCustomerProfile(
                              name: _fullNameController.text,
                              phone: _phoneController.text,
                              email: _emailController.text,
                            );
                            if (success) {
                              EasyLoading.show();
                              SnackBarServices.showSuccessMessage("Account Updated Successfully");
                              EasyLoading.dismiss();
                            } else {
                              EasyLoading.show();
                              SnackBarServices.showErrorMessage("Failed to update profile. Try again.");
                            EasyLoading.dismiss();
                            }
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
                        onPressed: (){
                          FirebaseFunctions.logout();
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
                ),
                SizedBox(height: height * 0.03,),


              ],
            ),
          ),
        ),
      ),
    );
  }
}