import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../Data/complete_order_data_model.dart';

class OrderCardWidget extends StatelessWidget {
  final CompleteOrderDataModel? order;
  final VoidCallback? onTap;

  const OrderCardWidget({
    Key? key,
    this.order,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // If no order is provided, use hardcoded data (for preview/design)
    final String orderId = order?.orderId.substring(0, 5) ?? "123";

    // Format the date or use default
    String formattedDate = "Jan 15, 2025 • 12:30 PM";
    if (order?.createdAt != null) {
      formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(order!.createdAt.toDate());
    }

    // Determine status or use default
    String orderStatus = order?.orderStatus ?? "Delivered";

    // Use sellerName from the model or fallback to "Restaurant"
    String restaurantName = (order?.sellerName?.isNotEmpty ?? false)
        ? order!.sellerName!
        : "Restaurant";


    // Use the order total or default
    String totalAmount = order != null
        ? "${order!.totalAmount.toStringAsFixed(0)} L.E"
        : "500 L.E";

    // Status color logic
    Color statusColor = AppColors.lightMint;
    Color textColor = AppColors.primaryColor;
    if (order != null) {
      switch (order!.orderStatus.toLowerCase()) {
        case 'pending':
          statusColor = Colors.orange.shade100;
          textColor = Colors.orange.shade800;
          break;
        case 'confirmed':
          statusColor = Colors.blue.shade100;
          textColor = Colors.blue.shade800;
          break;
        case 'preparing':
          statusColor = Colors.amber.shade100;
          textColor = Colors.amber.shade800;
          break;
        case 'delivered':
          statusColor = AppColors.lightMint;
          textColor = AppColors.primaryColor;
          break;
        case 'cancelled':
          statusColor = Colors.red.shade100;
          textColor = Colors.red.shade800;
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              width: 2,
              color: AppColors.primaryColor
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "#ORD - $orderId",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: AppColors.black
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppColors.darkGrey
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      orderStatus.substring(0, 1).toUpperCase() + orderStatus.substring(1),
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: textColor
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: height * 0.03),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.grey,
                    ),
                    child: Image.asset(AppAssets.restaurantsIcon, height: height * 0.04),
                  ),
                  SizedBox(width: width * 0.03),
                  Expanded(
                    child: Text(
                      restaurantName, // USE THE SELLER NAME HERE
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: AppColors.black
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              SizedBox(height: height * 0.03),
              Row(
                children: [
                  Text(
                    totalAmount,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: AppColors.black
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: onTap,
                    child: Text(
                      "View Details",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}