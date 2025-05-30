import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/payment/payment_services.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/utils/snack_bar_services.dart';
import '../../../core/providers/cart_provider.dart';
import '../orders/order_confirmation_screen.dart';


class PaymentMethodScreen extends StatefulWidget {
  final String sellerId;
  final String orderType; // "pickup" or "delivery"
  final String? deliveryAddress;
  final String? phoneNumber;

  const PaymentMethodScreen({
    Key? key,
    required this.sellerId,
    required this.orderType,
    this.deliveryAddress,
    this.phoneNumber,
  }) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? selectedMethod;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

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

          if (orderProvider.errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                orderProvider.errorMessage,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(50.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: (selectedMethod != null && !_isProcessing)
                    ? () => _processPayment(context, cartProvider, orderProvider)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: AppColors.white)
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

  // Verify seller ID is valid
  bool _verifySellerID() {
    if (widget.sellerId.isEmpty || widget.sellerId == "unknown") {
      SnackBarServices.showErrorMessage(
          "Could not identify the seller. Please return to the cart and try again.");
      return false;
    }
    return true;
  }

  // Moved the payment processing logic to a separate method
  Future<void> _processPayment(
      BuildContext context, CartProvider cartProvider, OrderProvider orderProvider) async {

    if (selectedMethod == null) return;

    // Verify seller ID before proceeding
    if (!_verifySellerID()) {
      return;
    }

    try {
      setState(() {
        _isProcessing = true;
      });

      if (selectedMethod == "online") {
        try {
          await PaymentService.payWithPaypal(context);
          // After successful payment, create the order
        } catch (e) {
          // Only show error if the widget is still mounted
          if (mounted) {
            SnackBarServices.showErrorMessage(
                "Payment failed: ${e.toString()}");
          }
        }
      } else if (selectedMethod == "cod") {
        await _placeOrder(context, cartProvider, orderProvider);
      }
    } finally {
      // Only update state if widget is still mounted
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _placeOrder(
      BuildContext context, CartProvider cartProvider, OrderProvider orderProvider) async {

    // Check if cart has items
    if (cartProvider.cartItems.isEmpty) {
      SnackBarServices.showErrorMessage("Your cart is empty");
      return;
    }

    // Double-check seller ID matches the cart provider's
    if (widget.sellerId != cartProvider.currentSellerId) {
      SnackBarServices.showErrorMessage(
          "Order data mismatch. Please try again from the cart screen.");
      return;
    }

    final orderId = await orderProvider.placeOrder(
      cartProvider: cartProvider,
      sellerId: widget.sellerId,
      customerAddress: widget.deliveryAddress,
      customerPhone: widget.phoneNumber,
      paymentMethod: selectedMethod!,
      orderType: widget.orderType,
    );

    if (orderId != null) {
      // Order placed successfully
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => OrderConfirmationScreen(
              orderId: orderId,
              orderType: widget.orderType,
            ),
          ),
              (route) => route.isFirst, // Keep only the first route in the stack
        );
      }
    } else {
      if (mounted) {
        SnackBarServices.showErrorMessage(
            "Failed to place order: ${orderProvider.errorMessage}");
      }
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
            // Texts
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