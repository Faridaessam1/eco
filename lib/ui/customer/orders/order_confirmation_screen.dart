import 'package:eco_eaters_app_3/ui/customer/homeTab/customer_home_tab.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_elevated_button.dart';


class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;
  final String orderType;

  const OrderConfirmationScreen({
    Key? key,
    required this.orderId,
    required this.orderType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: AppColors.primaryColor,
                size: 100,
              ),
              const SizedBox(height: 24),
              const Text(
                "Order Placed Successfully!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Your order #$orderId has been confirmed.",
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.darkGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                orderType == "pickup"
                    ? "You can pick up your order from the restaurant."
                    : "Your order will be delivered to your address.",
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.darkGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              CustomElevatedButton(
                onPressed: () {
                  // Navigate back to home screen and clear all routes
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => CustomerHomeTab(),
                    ),
                        (route) => false,
                  );
                },
                text: "Back to Home",
                borderRadius: 20,
                textColor: AppColors.primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              )
            ],
          ),
        ),
      ),
    );
  }
}