import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Privacy Policy",
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
                    Icon(Icons.privacy_tip, color: AppColors.black, size: screenWidth * 0.06),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: Text(
                        "We value your privacy. Learn how we collect and protect your data.",
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

              buildSectionTitle("Data Collection", screenWidth),
              buildUser(Icons.person, "Personal Information", screenWidth),
              buildUser(Icons.location_on, "Location Data", screenWidth),
              buildUser(Icons.credit_card, "Payment Information", screenWidth),

              SizedBox(height: screenHeight * 0.02),

              // Usage of Data Section
              buildSectionTitle("Usage of Data", screenWidth),
              buildList("How we use your data to improve services and personalize experiences...", screenWidth),

              SizedBox(height: screenHeight * 0.02),

              // Data Security Section
              buildSectionTitle("Data Security", screenWidth),
              buildList("Our security measures and protocols to protect your information...", screenWidth),

              SizedBox(height: screenHeight * 0.02),

              // Contact Information Section
              buildSectionTitle("Contact Information", screenWidth),
              buildList("📧 support@ecoeaters.com", screenWidth),

              SizedBox(height: screenHeight * 0.02),


              Center(
                child: SizedBox(
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Back to Onboarding",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
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

  Widget buildUser(IconData icon, String title, double screenWidth) {
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
              child: Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}