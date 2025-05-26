import 'package:eco_eaters_app_3/ui/customer/cartTab/widgets/food_card_widget.dart';
import 'package:eco_eaters_app_3/ui/customer/paymentMethod/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Data/recently_added_dish_data_model.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../core/utils/snack_bar_services.dart';
import '../../../core/FirebaseServices/firebase_firestore_seller.dart';  // إضافة import

class CartTab extends StatefulWidget {
  CartTab({super.key});

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  bool? deliveryAvailable;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkDeliveryAvailability();
  }

  Future<void> _checkDeliveryAvailability() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    if (cartProvider.currentSellerId.isNotEmpty) {
      try {
        final availability = await FireBaseFirestoreServicesSeller.getSellerDeliveryAvailability(
            cartProvider.currentSellerId
        );

        if (mounted) {
          setState(() {
            deliveryAvailable = availability;
            isLoading = false;
          });
        }
      } catch (e) {
        print("Error checking delivery availability: $e");
        if (mounted) {
          setState(() {
            deliveryAvailable = false;
            isLoading = false;
          });
        }
      }
    } else {
      setState(() {
        deliveryAvailable = false;
        isLoading = false;
      });
    }
  }

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

    // Early return if cart is empty
    if (cardData.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            AppAssets.appLogo,
            height: height * 0.03,
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.darkGrey),
              SizedBox(height: 16),
              Text(
                "Your cart is empty",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Add items to get started",
                style: TextStyle(
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          AppAssets.appLogo,
          height: height * 0.03,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                bottom: _getBottomPadding()
            ), // Dynamic padding based on button count
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

                  // عرض الـ buttons حسب availability
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    _buildActionButtons(cartProvider),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(CartProvider cartProvider) {
    // لو delivery availability = false، اعرض button واحد للـ checkout
    if (deliveryAvailable == false) {
      return SizedBox(
        width: double.infinity,
        child: CustomElevatedButton(
          onPressed: () {
            if (cartProvider.currentSellerId.isEmpty) {
              SnackBarServices.showErrorMessage(
                  "Unable to identify seller. Please try again or re-add items to cart."
              );
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PaymentMethodScreen(
                sellerId: cartProvider.currentSellerId,
                orderType: "pickup",
              )),
            );
          },
          text: "Proceed to Checkout",
          icon: Icons.shopping_cart_checkout,
          buttonColor: AppColors.primaryColor,
          borderRadius: 20,
          textColor: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    // لو delivery availability = true، اعرض الـ 2 buttons
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: CustomElevatedButton(
            onPressed: () {
              if (cartProvider.currentSellerId.isEmpty) {
                SnackBarServices.showErrorMessage(
                    "Unable to identify seller. Please try again or re-add items to cart."
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentMethodScreen(
                  sellerId: cartProvider.currentSellerId,
                  orderType: "pickup",
                )),
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
              if (cartProvider.currentSellerId.isEmpty) {
                SnackBarServices.showErrorMessage(
                    "Unable to identify seller. Please try again or re-add items to cart."
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentMethodScreen(
                  sellerId: cartProvider.currentSellerId,
                  orderType: "delivery",
                )),
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
    );
  }

  double _getBottomPadding() {
    if (isLoading) return 180;
    return deliveryAvailable == true ? 210 : 160;
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
            "${value.toStringAsFixed(2)} L.E",
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