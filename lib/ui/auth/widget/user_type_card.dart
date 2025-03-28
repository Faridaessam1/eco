import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class UserTypeCard extends StatelessWidget {
  final IconData icon;
  final String text;

  UserTypeCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.black, size: 20),
            ),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 3),
              Text(
                text == "I'm a Customer" ? "Order eco-friendly food" : "List your eco-friendly foods",
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
