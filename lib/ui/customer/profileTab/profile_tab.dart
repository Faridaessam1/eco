
import 'package:flutter/material.dart';

import '../../../core/FirebaseServices/firebase_auth.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/page_route_names.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../core/widgets/custom_text_form_field.dart';


class ProfileTab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                " Hello ,\n Farida Essam",
                style: TextStyle(
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
                hintText: "Phone Number",
                filledColor: AppColors.white,
                borderColor: AppColors.black,
                hintTextColor: AppColors.grey,
              ),
              SizedBox(height: height * 0.03,),

              const Text("Password" ,
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                ), ),
              SizedBox(height: height * 0.02,),
              CustomTextFormField(
                hintText: "Password",
                filledColor: AppColors.white,
                borderColor: AppColors.black,
                hintTextColor: AppColors.grey,
              ),
              SizedBox(height: height * 0.03,),
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: (){print("");},
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
                        FirebaseFunctions.logOut();
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
    );
  }

}