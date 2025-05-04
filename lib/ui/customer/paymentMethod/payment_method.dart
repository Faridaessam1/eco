import 'package:eco_eaters_app_3/core/constants/app_assets.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/payment/payment_services.dart';
import '../../../core/utils/snack_bar_services.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: AppColors.black),
        title: const Text(
          "Payment Method",
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Icon(Icons.account_balance_wallet, size: 50, color: AppColors.primaryColor),
          const SizedBox(height: 10),
          const Text(
            "Choose Payment Method",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            "Select how you’d like to pay for your order",
            style: TextStyle(fontSize: 14, color: AppColors.grey),
          ),
          const SizedBox(height: 30),


          _buildPaymentOption(
            label: "Pay Online",
            subLabel: "Credit or Debit Card",
            iconPath: AppAssets.payOnline,
            value: "online",
          ),
          const SizedBox(height: 16),


          _buildPaymentOption(
            label: "Cash on Delivery",
            subLabel: "Pay when you receive",
            iconPath: AppAssets.cashPayment,
            value: "cod",
          ),

          const Spacer(),


          Padding(
            padding: const EdgeInsets.all(50.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: selectedMethod != null
                    ? () async {
                        print("Confirmed: $selectedMethod");
                        if (selectedMethod == "online") {
                          await PaymentService.payWithPaypal(
                              context); // استدعاء دالة PayPal
                        } else if (selectedMethod == "cod") {
                          SnackBarServices.showSuccessMessage(
                              "Cash On Delivery Selected");
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "Confirm Payment Method",
                  style: TextStyle(fontSize: 16, color: AppColors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String label,
    required String subLabel,
    required String iconPath,
    required String value,
  }) {
    final isSelected = selectedMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Image.asset(iconPath, width: 36, height: 36),
            const SizedBox(width: 12),
            // Texts
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(subLabel,
                    style: const TextStyle(fontSize: 14, color:AppColors.grey)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16,  color:AppColors.grey),
          ],
        ),
      ),
    );
  }
}
