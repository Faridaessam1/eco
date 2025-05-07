import 'package:eco_eaters_app_3/core/constants/app_assets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/FirebaseServices/order_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/payment/payment_services.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../core/utils/snack_bar_services.dart';

class PaymentMethodScreen extends StatefulWidget {
  final String sellerId;
  final String? customerAddress;

  const PaymentMethodScreen({
    Key? key,
    required this.sellerId,
    this.customerAddress,
  }) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? selectedMethod;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    // Calculate order totals
    double subtotal = cartProvider.subtotal;
    double serviceFees;
    if (subtotal < 100) {
      serviceFees = 15;
    } else if (subtotal < 200) {
      serviceFees = 20;
    } else {
      serviceFees = 35;
    }
    double tax = subtotal * 0.14;
    double totalPrice = subtotal + serviceFees + tax;

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
            "Select how you'd like to pay for your order",
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
                onPressed: _isProcessing || selectedMethod == null
                    ? null
                    : () => _processOrder(
                    cartProvider, subtotal, serviceFees, tax, totalPrice),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
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

  Future<void> _processOrder(
      CartProvider cartProvider,
      double subtotal,
      double serviceFees,
      double tax,
      double totalPrice,
      ) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      // Process payment if online payment method is selected
      if (selectedMethod == "online") {
        final paymentResult = await PaymentService.payWithPaypal(context);
        if (paymentResult != true) {
          setState(() {
            _isProcessing = false;
          });
          SnackBarServices.showErrorMessage("Payment canceled or failed");
          return;
        }
      }

      // Create the order
      final String orderId = await OrderService.createOrder(
        customerId: user.uid,
        sellerId: widget.sellerId,
        customerName: user.displayName ?? "Customer",
        customerAddress: widget.customerAddress,
        orderItems: cartProvider.cartItems,
        subtotal: subtotal,
        serviceFees: serviceFees,
        tax: tax,
        totalAmount: totalPrice,
        paymentMethod: selectedMethod == "online" ? "Online Payment" : "Cash on Delivery",
      );

      // Clear the cart after successful order creation
      cartProvider.clearCart();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order placed successfully! Order ID: $orderId'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to the home screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
      );
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      SnackBarServices.showErrorMessage("Failed to place order: $e");
    }
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(subLabel,
                    style: const TextStyle(fontSize: 14, color: AppColors.grey)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}