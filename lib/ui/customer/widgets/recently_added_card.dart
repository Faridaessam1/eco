import 'package:flutter/material.dart';
class RecentlyAddedCard extends StatelessWidget {
  final Map<String, dynamic> dishData;

  RecentlyAddedCard({required this.dishData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
              image: DecorationImage(
            image: NetworkImage(dishData['dishImage'] ?? 'assets/images/recentlyAddedImg.png'),  // عرض الصورة من الرابط
               fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم الطبق
                Text(
                  dishData['dishName'],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // معلومات إضافية عن الطبق
                const SizedBox(height: 4),
                Text(dishData['dishAdditionalInfo'] ?? 'No additional info'),
                const SizedBox(height: 8),
                // السعر
                Text(
                  '\$${dishData['dishPrice']}',
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
