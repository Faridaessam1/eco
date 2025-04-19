import 'package:flutter/material.dart';

import '../../../../Data/order_data_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../widgets/custom_status_container.dart';

class CustomOrderContainer extends StatelessWidget {
  final OrderDataModel orderDataModel;

  CustomOrderContainer({super.key, required this.orderDataModel});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

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
                orderStatusColor: orderDataModel.orderStatusColor,
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
              onPressed: () {},
              textColor: AppColors.white,
              buttonColor: AppColors.green,
              borderRadius: 8.0,
            ),
          ),
        ],
      ),
    );
  }
}
