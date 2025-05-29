import 'package:flutter/material.dart';
import 'package:eco_eaters_app_3/core/constants/app_colors.dart';
import 'package:eco_eaters_app_3/ui/seller/orders/widgets/custom_order_container.dart';
import 'package:eco_eaters_app_3/ui/seller/orders/widgets/custom_tab_bar_item_seller.dart';
import '../../../Data/order_data_model.dart';
import '../../../core/seller services/seller_order_services.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final sellerId = SellerOrderServices.getSellerId();
    if (sellerId == null) return Container(); // No user signed in

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
                  setState(() => selectedIndex = index);
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
            child: StreamBuilder<List<OrderDataModel>>(
              stream: SellerOrderServices.getOrdersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No orders available"));
                }

                final filteredOrders = SellerOrderServices.filterOrders(
                  snapshot.data!,
                  selectedIndex,
                );

                return ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: CustomOrderContainer(
                        orderDataModel: order,
                        onUpdateStatus: (newStatus) {
                          SellerOrderServices.updateOrderStatus(order.id, newStatus);
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
}


