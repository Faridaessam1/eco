import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SellerAvailableDish extends StatefulWidget {
  const SellerAvailableDish({super.key});

  @override
  State<SellerAvailableDish> createState() => _SellerAvailableDishState();
}

class _SellerAvailableDishState extends State<SellerAvailableDish> {
  late Future<List<Map<String, dynamic>>> _dishesFuture;

  @override
  void initState() {
    super.initState();
    _dishesFuture = fetchDishesWithImages();
  }

  Future<List<Map<String, dynamic>>> fetchDishesWithImages() async {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    print("👤 Current UID: $uid");

    List<Map<String, dynamic>> finalDishes = [];

    try {
      final userDishesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('dishes')
          .get();

      print("📦 Total fetched documents: ${userDishesSnapshot.docs.length}");

      for (var doc in userDishesSnapshot.docs) {
        final dishData = doc.data();
        final dishImage = dishData['dishImage'] ?? '';

        if (dishImage.toString().trim().isNotEmpty) {
          final fullDish = {
            'id': doc.id,
            ...dishData,
            'dishImage': dishImage,
            'isAvailable': dishData['isAvailable'] ?? true, // default to true
          };
          finalDishes.add(fullDish);
        }
      }
    } catch (e) {
      print("❌ Error fetching dishes: $e");
    }

    return finalDishes;
  }

  Future<void> updateDishAvailability(String dishId, bool isAvailable) async {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('dishes')
        .doc(dishId)
        .update({'isAvailable': isAvailable});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EcoEaters"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dishesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No available dishes"));
          }

          final dishes = snapshot.data!;

          return ListView.builder(
            itemCount: dishes.length,
            itemBuilder: (context, index) {
              final dish = dishes[index];

              return StatefulBuilder(
                builder: (context, setStateSwitch) {
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: dish['dishImage'] != null &&
                                  dish['dishImage'] != ''
                              ? Image.network(
                                  dish['dishImage'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image_not_supported),
                          title: Text(dish['dishName'] ?? 'No name'),
                          subtitle:
                              Text('\$${dish['dishPrice']?.toString() ?? "0"}'),
                          trailing: Switch(
                            value: dish['isAvailable'] ?? true,
                            onChanged: (value) async {
                              setStateSwitch(() {
                                dish['isAvailable'] = value;
                              });
                              await updateDishAvailability(dish['id'], value);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
