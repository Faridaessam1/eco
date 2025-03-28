
import 'package:flutter/material.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../home/home_view.dart';
import '../new dish/new_dish_view.dart';
import '../orders/orders_view.dart';
import '../profile/profile_view.dart';

class LayOutViewSeller extends StatefulWidget {
  const LayOutViewSeller({super.key});

  @override
  State<LayOutViewSeller> createState() => _LayOutViewSellerState();
}

class _LayOutViewSellerState extends State<LayOutViewSeller> {

  int selectedIndex=0;
  List <Widget> tabs =[
    HomeView(),
    OrdersView(),
    NewDishView(),
    ProfileView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.green,
        unselectedItemColor: AppColors.black,
        currentIndex: selectedIndex,
        onTap: _onButtonNavBarItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(AppAssets.homeIcon , width: 22.5, height: 20,),
            label: "Home",

            //   label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(AppAssets.ordersIcon),
            activeIcon: Image.asset(AppAssets.ordersIcon),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(AppAssets.newIcon),
            activeIcon: Image.asset(AppAssets.newIcon),
            label: "New",
          ),
          BottomNavigationBarItem(
              icon:Image.asset(AppAssets.profileIcon,  width: 22.5, height: 20,),
              label: "Profile"
            // label: AppLocalizations.of(context)!.profile,
          ),
      ],
      ),
      body: tabs[selectedIndex],
    );
  }

  _onButtonNavBarItemTapped(int index){
    selectedIndex = index;
    setState(() {});
  }

}
