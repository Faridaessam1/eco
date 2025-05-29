import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_eaters_app_3/ui/seller/home/widgets/custom_insights_container.dart';
import 'package:eco_eaters_app_3/ui/seller/home/widgets/custom_recent_order_container.dart';
import 'package:eco_eaters_app_3/ui/seller/home/widgets/custom_text_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../Data/insights_data_model.dart';
import '../../../Data/order_data_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/page_route_names.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<InsightsDataModel> insights = [];
  List<OrderDataModel> recentOrders = [];

  @override
  void initState() {
    super.initState();
    fetchRecentOrders();
    fetchInsights();
  }

  Future<void> fetchRecentOrders() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      final now = DateTime.now();
      final filteredDocs = querySnapshot.docs.where((doc) {
        final createdAt = (doc['createdAt'] as Timestamp).toDate();
        return now.difference(createdAt).inHours <= 48;
      }).toList();

      setState(() {
        recentOrders = filteredDocs.asMap().entries.map((entry) {
          final index = entry.key;
          final doc = entry.value;
          final data = doc.data();
          final createdAt = (data['createdAt'] as Timestamp).toDate();
          final formattedDate = "${createdAt.day}/${createdAt.month}/${createdAt.year}";

          return OrderDataModel(
            orderNumber: (index + 1).toString(),
            orderStatus: data['orderStatus'] ?? '',
            orderStatusColor: getStatusColor(data['orderStatus']),
            orderItemCount: data['items']?.length.toString() ?? '0',
            orderAmount: data['totalAmount']?.toString() ?? '0.0',
            customerName: data['customerName'] ?? '',
            time: formattedDate,
            id: data['orderId'] ?? '',
            items: [],
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching recent orders: $e');
    }
  }
  Future<void> fetchInsights() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final ordersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('orders')
          .get();

      final totalOrders = ordersSnapshot.size;

      double revenue = 0;
      int pendingOrders = 0;

      for (var doc in ordersSnapshot.docs) {
        final data = doc.data();
        final amount = data['totalAmount'] ?? 0;
        final status = data['orderStatus'] ?? '';

        revenue += amount is int ? amount.toDouble() : amount;
        if (status.toLowerCase() == 'pending') {
          pendingOrders++;
        }
      }

      final dishesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dishes')
          .get();
      final availableDishes = dishesSnapshot.size;

      setState(() {
        insights = [
          InsightsDataModel(
            icon: Icons.shopping_basket_rounded,
            title: "Total Orders",
            value: totalOrders.toString(),
          ),
          InsightsDataModel(
            icon: Icons.attach_money,
            title: "Revenue",
            value: revenue.toStringAsFixed(2),
          ),
          InsightsDataModel(
            icon: Icons.restaurant,
            title: "Available Dishes",
            value: availableDishes.toString(),
          ),
          InsightsDataModel(
            icon: Icons.access_time_filled_rounded,
            title: "Pending Orders",
            value: pendingOrders.toString(),
          ),
        ];
      });
    } catch (e) {
      print("Error fetching insights: $e");
    }
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
                  onPressed: () {
                    Navigator.pushNamed(context,PagesRouteName.sellerOrdersScreen);
                  },
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
            Expanded(
              child: recentOrders.isEmpty
                  ? const Center(child: Text("No recent orders."))
                  : ListView.builder(
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

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return AppColors.red;
    case 'Completed':
      return AppColors.green;
    default:
      return AppColors.grey;
  }
}


