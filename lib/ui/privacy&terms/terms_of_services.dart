import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class TermsOfServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Terms of Service",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: screenWidth * 0.06),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.eco, color: AppColors.black, size: screenWidth * 0.06),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: Text(
                        "Welcome to EcoEaters. Please read these terms carefully before using our services.",
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // User Responsibilities Section
              buildSectionTitle("User Responsibilities", screenWidth),
              buildUser(Icons.shopping_bag, "Buyers",
                  "Users must provide accurate information and maintain account security...", screenWidth),
              buildUser(Icons.store, "Sellers",
                  "Sellers must ensure product quality and accurate descriptions...", screenWidth),
              buildUser(Icons.local_shipping, "Delivery Partners",
                  "Partners must follow delivery guidelines and maintain service standards...", screenWidth),

              SizedBox(height: screenHeight * 0.02),


              buildSectionTitle("Order & Refund Policies", screenWidth),
              buildList("Details about order processing, cancellations, and refund procedures...", screenWidth),

              SizedBox(height: screenHeight * 0.02),


              buildSectionTitle("Service Fees & Subscriptions", screenWidth),
              buildList("Information about pricing, subscription plans, and payment terms...", screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth * 0.045,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildList(String subtitle, double screenWidth) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.02),
      ),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02),
        child: Text(
          subtitle,
          style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.black54),
        ),
      ),
    );
  }

  Widget buildUser(IconData icon, String title, String subtitle, double screenWidth) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.02),
      ),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: screenWidth * 0.06, color: AppColors.black),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    subtitle,
                    style: TextStyle(fontSize: screenWidth * 0.038, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}