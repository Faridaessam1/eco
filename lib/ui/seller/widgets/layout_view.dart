import 'package:eco_eaters_app_3/ui/seller/home/home_view.dart';
import 'package:eco_eaters_app_3/ui/seller/orders/orders_view.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../new dish/new_dish_view.dart';
import '../profile/seller_profile_view.dart';
import '../seller available dish/seller_available_dish.dart';

class LayOutViewSeller extends StatefulWidget {
  const LayOutViewSeller({super.key});

  @override
  State<LayOutViewSeller> createState() => _LayOutViewSellerState();
}

class _LayOutViewSellerState extends State<LayOutViewSeller> {
  int selectedIndex = 0;


  List<Widget> tabs = [
  const HomeView(),
  const OrdersView(),
  const NewDishView(),
  const SellerAvailableDish(),
  const SellerProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.green,
        unselectedItemColor: AppColors.black,
        currentIndex: selectedIndex,
        onTap: _onButtonNavBarItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(AppAssets.homeIcon, width: 22.5, height: 20),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(AppAssets.ordersIcon),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            label: "New",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: "Dishes",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(AppAssets.profileIcon, width: 22.5, height: 20),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  _onButtonNavBarItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}