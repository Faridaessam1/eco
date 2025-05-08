import 'package:eco_eaters_app_3/ui/customer/orders/widgets/order_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/order_provider.dart';
import '../../../Data/complete_order_data_model.dart';

class CustomerOrderScreen extends StatefulWidget {
  const CustomerOrderScreen({Key? key}) : super(key: key);

  @override
  State<CustomerOrderScreen> createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  final _tabs = ['All', 'Pending', 'Confirmed', 'Preparing', 'Delivered'];
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.setUserType('customer');
      orderProvider.loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Orders",
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: userId == null
          ? Center(child: Text("Please log in to view your orders"))
          : Column(
        children: [
          // Filter tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Row(
              children: List.generate(
                _tabs.length,
                    (index) => _buildFilterTab(index),
              ),
            ),
          ),
          // Orders list
          Expanded(
            child: Consumer<OrderProvider>(
              builder: (context, orderProvider, child) {
                if (orderProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (orderProvider.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(
                      'Error: ${orderProvider.errorMessage}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                final orders = orderProvider.customerOrders;

                if (orders.isEmpty) {
                  return Center(
                    child: Text(
                      'No orders found',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.all(15),
                  itemCount: orders.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: height * 0.04),
                  itemBuilder: (context, index) => OrderCardWidget(
                    order: orders[index],
                    onTap: () => _showOrderDetails(orders[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(int index) {
    bool isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });

        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
        if (index == 0) {
          orderProvider.loadOrders();
        } else {
          String status = _tabs[index].toLowerCase();
          orderProvider.loadOrdersByStatus(status);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(2, 2),
                blurRadius: 6)
          ]
              : [],
        ),
        child: Text(
          _tabs[index],
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: isSelected ? 16 : 14,
          ),
        ),
      ),
    );
  }

  void _showOrderDetails(CompleteOrderDataModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Order #${order.orderId.substring(0, 5)}'),
              SizedBox(height: 8),
              Text('Status: ${order.orderStatus}'),
              SizedBox(height: 8),
              Text('Restaurant: ${order.sellerName ?? "Unknown"}'),
              SizedBox(height: 8),
              Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
              SizedBox(height: 16),
              Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...order.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item.quantity}x ${item.name}'),
                    Text('\$${item.price.toStringAsFixed(2)}'),
                  ],
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}