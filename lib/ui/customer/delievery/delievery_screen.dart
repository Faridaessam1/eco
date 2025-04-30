import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class DeliveryHelpScreen extends StatelessWidget {
  const DeliveryHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Spacer(flex: 3),

            const Text(
              "Call us here for delivery order option",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.lightMint,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.black,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),

              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    'assets/icons/call_icon.png',
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(width: 30),
                  const Text(
                      "19043",
                      style: TextStyle(
                        fontSize: 30,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 4),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "Proceed to Checkout",
                  style: TextStyle(fontSize: 16, color: AppColors.white),
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Available 24/7 for your convenience",
              style: TextStyle(fontSize: 13, color: AppColors.black),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
