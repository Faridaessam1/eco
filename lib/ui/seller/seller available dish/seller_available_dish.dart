import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_eaters_app_3/core/constants/app_assets.dart';
import 'package:eco_eaters_app_3/ui/seller/home/widgets/custom_text_button.dart';
import 'package:eco_eaters_app_3/ui/seller/seller%20available%20dish/widgets/custom_available_dish_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Data/dish_data_model.dart';
import '../../../Data/insights_data_model.dart';
import '../../../Data/seller_available_dish_data_model.dart';
import '../../../core/constants/app_colors.dart';
import '../home/widgets/custom_insights_container.dart';

class SellerAvailableDish extends StatefulWidget {
  const SellerAvailableDish({super.key});

  @override
  State<SellerAvailableDish> createState() => _SellerAvailableDishState();
}

class _SellerAvailableDishState extends State<SellerAvailableDish> {
  List<DishDataModel> dishes = [];
  List<bool> availability = [];

  List<InsightsDataModel> insights = [
    const InsightsDataModel(
      icon: Icons.local_dining,
      title: "Active Dishes",
      value: "24",
    ),
    const InsightsDataModel(
      icon: Icons.shopping_cart,
      title: "Total Orders",
      value: "156",
    ),
  ];

  @override
  void initState() {
    super.initState();
    fetchDishes();
  }

  Future<void> fetchDishes() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection(DishDataModel.collectionName)
        .get();

    final fetchedDishes =
        snapshot.docs.map((doc) => DishDataModel.fromFirestore(doc)).toList();

    setState(() {
      dishes = fetchedDishes;
      availability = List.generate(dishes.length, (index) => true);
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "EcoEaters",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.green,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.04),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: insights.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.8,
                ),
                itemBuilder: (context, index) {
                  return CustomInsightsContainer(
                    icon: insights[index].icon,
                    text: insights[index].title,
                    number: insights[index].value,
                  );
                },
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text(
                    "Your Dishes",
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    child: CustomTextButton(
                      text: "Add new",
                      textColor: AppColors.white,
                      buttonColor: AppColors.green,
                      icon: Icons.add_rounded,
                      iconColor: AppColors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dishes.length,
                itemBuilder: (context, index) {
                  final dish = dishes[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: CustomAvailableDishWidget(
                      availableDishDataModel: SellerAvailableDishDataModel(
                        dishImage: dish.dishImage ?? AppAssets.recentlyAddedImg,
                        dishName: dish.dishName,
                        dishPrice: dish.dishPrice.toStringAsFixed(2),
                      ),
                      isAvailable: availability[index],
                      onToggle: (value) {
                        setState(() {
                          availability[index] = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
