
import 'package:eco_eaters_app_3/ui/customer/cartTab/widgets/food_card_widget.dart';
import 'package:flutter/material.dart';

import '../../../Data/food_card_in_cart_tab_data.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_elevated_button.dart';

class CartTab extends StatefulWidget {


  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
List<FoodCardInCartTabData> cardData=[
    FoodCardInCartTabData(
      foodImgPath: AppAssets.recentlyAddedImg,
      foodName: "Buddha Bowl",
      foodPrice:100,
      foodQuantity: 1,
    ),
  FoodCardInCartTabData(
      foodImgPath: AppAssets.recentlyAddedImg,
      foodName: "Buddha Bowl",
      foodPrice:340,
      foodQuantity: 1,
    ),
  FoodCardInCartTabData(
      foodImgPath: AppAssets.recentlyAddedImg,
      foodName: "Buddha Bowl",
      foodPrice:200,
      foodQuantity: 1,
    ),
  ];
  void increment(int index) {
    setState(() {
      cardData[index].foodQuantity++;

    });
  }

  void decrement(int index) {
      setState(() {
        cardData[index].foodQuantity--;
      });

  }
double calculateSubtotal() {
  return cardData.fold(
           0,
          (sum, item) => sum + (item.foodQuantity * item.foodPrice));
}

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    double subtotal = calculateSubtotal();
    double deliveryFees = 50;
    double tax = 30;
    double totalPrice = subtotal + deliveryFees + tax;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          AppAssets.appLogo,
          height: height * 0.02,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) =>
                    FoodCardWidget(
                  foodData: cardData[index],
                  onIncrement:() => increment(index),
                  onDecrement:() => decrement(index),
                ),
                separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10,),
                itemCount: cardData.length,
              ),
            ),
            SizedBox(
              height: height * 0.06,
            ),
            Row(
              children: [
                Text(
                  "SubTotal",
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                Text(subtotal.toString(),
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Delivery Fees",
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                Text(
                  deliveryFees.toString(),
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Tax",
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                Text(
                  tax.toString(),
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Divider(
              color: AppColors.primaryColor,
              thickness: 2,
              indent: 10,
              endIndent: 10,
            ),
            Row(
              children: [
                Text(
                  "Total Price",
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                Text(
                 totalPrice.toString(),
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    onPressed: () {
                      print("");
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
          ],
        ),
      ),
    );
  }
}
