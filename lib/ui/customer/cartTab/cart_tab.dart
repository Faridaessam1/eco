import 'package:eco_eaters_app_3/ui/customer/cartTab/widgets/food_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../core/widgets/custom_elevated_button.dart';

class CartTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cardData = cartProvider.cartItems;

    var height = MediaQuery.of(context).size.height;
    double subtotal = cartProvider.subtotal;

    // Dynamic service fee calculation
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
        title: Image.asset(
          AppAssets.appLogo,
          height: height * 0.03,
        ),
      ),
      body: Column(
        children: [
          // Cart items list takes remaining available height
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) =>
                    FoodCardWidget(
                  foodData: cardData[index],
                  onIncrement: () => cartProvider.increment(index),
                  onDecrement: () => cartProvider.decrement(index),
                  onDelete: () => cartProvider.removeFromCart(index),
                ),
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 10),
                itemCount: cardData.length,
              ),
            ),
          ),

          // Price summary and checkout button fixed at bottom
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow("SubTotal", subtotal),
                  _buildRow("Service Fees", serviceFees),
                  _buildRow("Tax (14%)", tax),
                  const Divider(
                    thickness: 2,
                  ),
                  _buildRow("Total Price", totalPrice,
                      isBold: true, color: AppColors.black),
                  const SizedBox(height: 10),
                  Center(
                    child: CustomElevatedButton(
                      onPressed: () {
                        print("Proceed to checkout");
                      },
                      text: "Proceed To Checkout",
                      buttonColor: AppColors.primaryColor,
                      borderRadius: 40,
                      textColor: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, double value,
      {bool isBold = false, Color? color}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color ?? AppColors.darkGrey,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            fontSize: 18,
          ),
        ),
        const Spacer(),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            color: color ?? AppColors.darkGrey,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
