import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';


class OrderCardWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
                      Text("#ORD - 123" ,
                        style:TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: AppColors.black
                        ),
                      ),
                      Text("Jan 15, 2025 • 12:30 PM",
                        style:TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppColors.darkGrey
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.lightMint,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child:Text("Delivered",
                      style:TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: AppColors.primaryColor
                      ),),
                  )
                ],
              ),
              SizedBox(height: height * 0.03,),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.grey,
                    ),
                    child: Image.asset(AppAssets.restaurantsIcon , height: height*0.04,),
                  ),
                  SizedBox(width:  width * 0.03,),

                  Text("Green Garden Restaurant",
                    style:TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppColors.black
                    ),
                  )
                ],
              ),
              SizedBox(height: height * 0.03,),
              Row(
                children: [
                  Text("500 L.E",
                    style:TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: AppColors.black
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed:(){},
                    child:  Text("View Details",
                      style:TextStyle(
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