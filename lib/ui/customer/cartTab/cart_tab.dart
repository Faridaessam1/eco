import 'package:eco_eaters_app_3/ui/customer/cartTab/widgets/food_card_widget.dart';
import 'package:eco_eaters_app_3/ui/customer/paymentMethod/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Data/recently_added_dish_data_model.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../delievery/delievery_screen.dart';

class CartTab extends StatelessWidget {

  CartTab({super.key });

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
        title:Image.asset(
          AppAssets.appLogo,
          height: height * 0.03,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 210), // Reserve space for bottom section
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: cardData.length,
              itemBuilder: (BuildContext context, int index) => FoodCardWidget(
                foodData: cardData[index],
                onIncrement: () => cartProvider.increment(index),
                onDecrement: () => cartProvider.decrement(index),
                onDelete: () => cartProvider.removeFromCart(index),
              ),
              separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow("SubTotal", subtotal),
                  _buildRow("Service Fees", serviceFees),
                  _buildRow("Tax (14%)", tax),
                  const Divider(thickness: 2),
                  _buildRow("Total Price", totalPrice, isBold: true, color: AppColors.black),
                  const SizedBox(height: 16),

                  // Full-width buttons
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>PaymentMethodScreen ()),
                        );
                      },
                      text: "Pickup Order",
                      icon: Icons.store,
                      buttonColor: AppColors.primaryColor,
                      borderRadius: 20,
                      textColor: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>DeliveryHelpScreen ()),
                        );
                      },
                      text: "Delivery Order",
                      icon: Icons.delivery_dining,
                      buttonColor: AppColors.primaryColor,
                      borderRadius: 20,
                      textColor: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color ?? AppColors.darkGrey,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              color: color ?? AppColors.darkGrey,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
