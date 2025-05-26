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
        orderStatusColor = AppColors.grey;
    }

    return Container(
      width: mediaQuery.size.width * 0.9,
      height: mediaQuery.size.height * 0.29,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightMint,
          width: 2,
        ),
      ),
      child: Column(
        children: [
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
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                orderDataModel.time,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const Text(
                "Customer:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
              ),
              Text(
                orderDataModel.customerName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const Text(
                "Address:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
              ),
              Text(
                orderDataModel.customerAddress!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const Text(
                "Items:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
              ),

              Text(
                orderDataModel.orderItemCount!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              orderDataModel.items.map((i) => "${i.name} x${i.quantity}").join(", "),
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.grey,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                "Total: ${orderDataModel.orderAmount} EGP",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
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
              ListTile(
                title: const Text("Pending"),
                onTap: () {
                  onUpdateStatus("Pending");
                  Navigator.pop(context); // Close the dialog
                },
              ),
              ListTile(
                title: const Text("In Progress"),
                onTap: () {
                  onUpdateStatus("In Progress");
                  Navigator.pop(context); // Close the dialog
                },
              ),
              ListTile(
                title: const Text("Completed"),
                onTap: () {
                  onUpdateStatus("Completed");
                  Navigator.pop(context); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

}

