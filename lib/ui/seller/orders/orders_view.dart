import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_eaters_app_3/ui/seller/orders/widgets/custom_order_container.dart';
import 'package:eco_eaters_app_3/ui/seller/orders/widgets/custom_tab_bar_item_seller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Data/order_data_model.dart';
import '../../../core/constants/app_colors.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final sellerId = FirebaseAuth.instance.currentUser?.uid;
    if (sellerId == null) return Container(); // Show an empty container if there's no user

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          "Order Management",
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
        ],
      ),
      body: Column(
        children: [
          SafeArea(
            child: DefaultTabController(
              length: 4,
              child: TabBar(
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                isScrollable: true,
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                tabAlignment: TabAlignment.start,
                tabs: [
                  CustomTabBarItemSeller(
                      title: "All",
                      isSelected: selectedIndex == 0,
                      tabColor: AppColors.black),
                  CustomTabBarItemSeller(
                      title: "Pending",
                      isSelected: selectedIndex == 1,
                      tabColor: AppColors.red),
                  CustomTabBarItemSeller(
                    title: "In Progress",
                    isSelected: selectedIndex == 2,
                    tabColor: AppColors.orange,
                  ),
                  CustomTabBarItemSeller(
                    title: "Completed",
                    isSelected: selectedIndex == 3,
                    tabColor: AppColors.green,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(sellerId)
                  .collection('orders')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No orders available"));
                }

                // Convert Firestore data to OrderDataModel list
                final orders = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>; // Safely cast to Map<String, dynamic>
                  final orderData = OrderDataModel.fromFireStore(data, doc.id);
                  return orderData;
                }).toList();

                // Apply filtering based on selected tab
                final filteredOrders = orders.where((order) {
                  switch (selectedIndex) {
                    case 1:
                      return order.orderStatus == "Pending";
                    case 2:
                      return order.orderStatus == "In Progress";
                    case 3:
                      return order.orderStatus == "Completed";
                    default:
                      return true;
                  }
                }).toList();

                return ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    final orderNumber = index + 1; // Generate order number as 1, 2, 3, ...

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: CustomOrderContainer(
                        orderDataModel: order.copyWith(orderNumber: orderNumber.toString()), // Pass the generated order number
                        onUpdateStatus: (newStatus) {
                          updateOrderStatus(order.id, newStatus);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          )

        ],
      ),
    );
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final sellerId = FirebaseAuth.instance.currentUser?.uid;
    if (sellerId == null) return;

    // Update Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(sellerId)
        .collection('orders')
        .doc(orderId)
        .update({'orderStatus': newStatus});
  }
}