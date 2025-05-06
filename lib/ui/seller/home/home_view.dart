import 'package:eco_eaters_app_3/ui/seller/home/widgets/custom_insights_container.dart';
import 'package:eco_eaters_app_3/ui/seller/home/widgets/custom_recent_order_container.dart';
import 'package:eco_eaters_app_3/ui/seller/home/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

import '../../../Data/insights_data_model.dart';
import '../../../Data/order_data_model.dart';
import '../../../core/constants/app_colors.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<InsightsDataModel> insights = [
    const InsightsDataModel(
      icon: Icons.shopping_basket_rounded,
      title: "Total Orders",
      value: "247",
    ),
    const InsightsDataModel(
      icon: Icons.attach_money,
      title: "Revenue",
      value: "1,438",
    ),
    const InsightsDataModel(
      icon: Icons.restaurant,
      title: "Available Dishes",
      value: "32",
    ),
    const InsightsDataModel(
      icon: Icons.access_time_filled_rounded,
      title: "Pending Orders",
      value: "8",
    ),
  ];

  List<OrderDataModel> recentOrders = [
    const OrderDataModel(
      orderNumber: "2458",
      orderStatus: "Pending",
      orderStatusColor: AppColors.red,
      orderItemCount: "3",
      orderAmount: "24.00",
      customerName: "Sarah M.",
      time: "10:00 AM",
    ),
    const OrderDataModel(
      orderNumber: "2457",
      orderStatus: "Completed",
      orderStatusColor: AppColors.green,
      orderItemCount: "4",
      orderAmount: "52.50",
      customerName: "John D.",
      time: "9:45 AM",
    ),
  ];

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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.sunny),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.04),
        child: Column(
          children: [
            // Insights Grid
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

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: "Add New Dish",
                    textColor: AppColors.white,
                    icon: Icons.add,
                    iconColor: AppColors.white,
                    buttonColor: AppColors.green,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: CustomTextButton(
                    text: "Today's Order",
                    textColor: AppColors.green,
                    icon: Icons.menu_rounded,
                    iconColor: AppColors.green,
                    buttonColor: AppColors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Recent Orders Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Orders",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "View All",
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Recent Orders List
            Expanded(
              child: ListView.builder(
                itemCount: recentOrders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomRecentOrderContainer(
                      orderDataModel: recentOrders[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

