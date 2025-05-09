import 'package:flutter/material.dart';

import '../../../../Data/order_data_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../widgets/custom_status_container.dart';

class CustomOrderContainer extends StatelessWidget {
  final OrderDataModel orderDataModel;
  final Function(String) onUpdateStatus;

  CustomOrderContainer({super.key, required this.orderDataModel, required this.onUpdateStatus});

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
        orderStatusColor = AppColors.grey; // في حالة غير معروفة
    }

    return Container(
      width: mediaQuery.size.width * 0.9,
      height: mediaQuery.size.height * 0.29,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              CustomStatusContainer(
                orderStatus: orderDataModel.orderStatus,
                orderStatusColor: orderStatusColor,
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                orderDataModel.time,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                "Customer:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
              ),
              Text(
                orderDataModel.customerName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                "Address:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
              ),
              Text(
                orderDataModel.customerAddress!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                "Items:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
              ),
              Text(
                orderDataModel.orderItemCount!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                "Total: \$${orderDataModel.orderAmount}",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          SizedBox(
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

