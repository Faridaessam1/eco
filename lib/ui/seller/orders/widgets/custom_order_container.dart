import 'package:flutter/material.dart';

import '../../../../Data/order_data_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../widgets/custom_status_container.dart';

class CustomOrderContainer extends StatelessWidget {
  final OrderDataModel orderDataModel;
  final Function(String) onUpdateStatus;

  const CustomOrderContainer({super.key, required this.orderDataModel, required this.onUpdateStatus});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    // تحديد اللون بناءً على حالة الطلب
    Color orderStatusColor;
    switch (orderDataModel.orderStatus) {
      case "Pending":
        orderStatusColor = AppColors.red;
        break;
      case "In Progress":
        orderStatusColor = AppColors.orange;
        break;
      case "Completed":
        orderStatusColor = AppColors.green;
        break;
      default:
        orderStatusColor = AppColors.darkGrey;
    }

    return Container(
      width: mediaQuery.size.width * 0.9,
      // تم إزالة الارتفاع الثابت ليصبح ديناميكي
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightMint,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Number and Status Row
          Row(
            children: [
              Text(
                "#${orderDataModel.orderNumber}",
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              CustomStatusContainer(
                orderStatus: orderDataModel.orderStatus,
                orderStatusColor: orderStatusColor,
              )
            ],
          ),
          const SizedBox(height: 8),

          // Time Row
          Text(
            orderDataModel.time,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),

          // Customer Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Customer: ",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGrey,
                ),
              ),
              Expanded(
                child: Text(
                  orderDataModel.customerName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Address Row - الحل الأساسي للمشكلة
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Address: ",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGrey,
                ),
              ),
              Expanded(
                child: Text(
                  orderDataModel.customerAddress ?? "No address provided",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                  overflow: TextOverflow.visible, // أو TextOverflow.fade
                  maxLines: 2, // السماح بسطرين كحد أقصى
                  softWrap: true, // السماح بالـ wrapping
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Items Count Row
          Row(
            children: [
              const Text(
                "Items: ",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGrey,
                ),
              ),
              Text(
                orderDataModel.orderItemCount ?? "0",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Items Details - مع حل الـ overflow
          Text(
            "Details: ${orderDataModel.items.map((i) => "${i.name} x${i.quantity}").join(", ")}",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.darkGrey,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          const SizedBox(height: 10),

          // Total Price Row
          Text(
            "Total: ${orderDataModel.orderAmount} EGP",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),

          // Update Status Button
          SizedBox(
            width: double.infinity,
            child: CustomElevatedButton(
              text: "Update Status",
              fontSize: 16,
              onPressed: () {
                _showStatusUpdateDialog(context);
              },
              textColor: AppColors.white,
              buttonColor: AppColors.green,
              borderRadius: 8.0,
            ),
          ),
        ],
      ),
    );
  }

  // Function to show the dialog for selecting a status
  void _showStatusUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Order Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildStatusOption(context, "Pending", AppColors.red),
              _buildStatusOption(context, "In Progress", AppColors.orange),
              _buildStatusOption(context, "Completed", AppColors.green),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(BuildContext context, String status, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: ListTile(
        leading: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        title: Text(
          status,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        onTap: () {
          onUpdateStatus(status);
          Navigator.pop(context);
        },
      ),
    );
  }
}