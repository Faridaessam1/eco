import 'package:eco_eaters_app_3/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomerFeedbackScreen extends StatefulWidget {
  const CustomerFeedbackScreen({Key? key}) : super(key: key);

  @override
  State<CustomerFeedbackScreen> createState() => _CustomerFeedbackScreenState();
}

class _CustomerFeedbackScreenState extends State<CustomerFeedbackScreen> {
  double _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.white,
              AppColors.primaryColor.withOpacity(0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: screenHeight * 0.04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.08),
                const Icon(Icons.check_circle, color: AppColors.primaryColor, size: 60),
                const SizedBox(height: 18),
                const Text(
                  "Thank you for your order! 🎉",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  "We’d love to hear your feedback! How would you rate your experience with us today?",
                  style: TextStyle(fontSize: 18, color: AppColors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "Tap a star to rate! If you have any additional feedback, please share it with us below. Your opinion helps us improve!",
                  style: TextStyle(fontSize: 15, color: AppColors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _feedbackController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "Share your thoughts with us...",
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    print("Rating: $_rating");
                    print("Feedback: ${_feedbackController.text}");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(screenWidth, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      },
                    child: Text(
                      "Submit Feedback",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Maybe later",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
