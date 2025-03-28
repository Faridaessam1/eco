import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/data/order_data_model.dart';
import '../../widgets/custom_status_container.dart';



class CustomRecentOrderContainer extends StatelessWidget {
  final OrderDataModel orderDataModel;

  CustomRecentOrderContainer({
    super.key,
    required this.orderDataModel,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Container(
      width: mediaQuery.size.width * 0.987,
      height: mediaQuery.size.height * 0.128,
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
                  fontWeight: FontWeight.w400,
                ),
              ),
              Spacer(),
              CustomStatusContainer(
                orderStatus: orderDataModel.orderStatus,
                orderStatusColor: orderDataModel.orderStatusColor,
              )
            ],
          ),
          Row(
            children: [
              Text(
                "${orderDataModel.orderItemCount} items",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "\$${orderDataModel.orderAmount}",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.label,
                color: AppColors.green,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                orderDataModel.customerName,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.black,
                ),
              ),
              Spacer(),
              Text(
                orderDataModel.time,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
