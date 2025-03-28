
import 'package:eco_eaters_app_3/ui/customer/orders/widgets/order_card_widget.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class CustomerOrderScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
      body: Column(
        children: [
          Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) => OrderCardWidget(),
                  separatorBuilder: (context, index) => SizedBox(height: height * 0.04,),
                  itemCount: 4,
              ),
          ),
        ],
      ),
    );
  }
}
