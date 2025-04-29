
import 'package:eco_eaters_app_3/ui/customer/restaurantsTab/widgets/custom_tab_bar_item_customer.dart';
import 'package:flutter/material.dart';

import '../../../Data/restaurant_card_data.dart';
import '../../../core/FirebaseServices/firebas_firestore_customer.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/page_route_names.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import '../widgets/restaurant_card.dart';

class RestaurantsTab extends StatefulWidget {

  @override
  State<RestaurantsTab> createState() => _RestaurantsTabState();
}

class _RestaurantsTabState extends State<RestaurantsTab> {
  int SelectedIndex = 0;
  late Future<List<RestaurantCardData>> futureRestaurantsData;
  List<String> tabNames = ["All", "Fast Food", "Salad", "Healthy", "Desserts",];
  @override
  void initState() {
    super.initState();
    futureRestaurantsData = FireBaseFirestoreServicesCustomer.getAllRestaurants();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),//bnzwed height el appbar
          child: AppBar(
            title:  Row(
              children: [
                Image.asset(
                  AppAssets.appLogo,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: CustomTextFormField(
                      hintText: "Search Restaurants",
                      borderColor: AppColors.lightGrey,
                      filledColor:AppColors.lightGrey,
                      hasIcon: true,
                      iconPath: AppAssets.searchIcon,
                      iconColor: AppColors.black,
                      hintTextColor: AppColors.darkGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DefaultTabController(
                length: 5,
                child: TabBar(
                  onTap: (index) {
                    SelectedIndex = index;
                    setState(() {});
                  },
                  splashFactory: NoSplash.splashFactory, //btshel el shadow el byb2a mawgod kol ma a select tab
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  tabs: tabNames.map((name) {
                    int index = tabNames.indexOf(name);
                    return Tab(
                      child: CustomTabBarItemCustomer(
                        text: name,
                        isSelected: SelectedIndex == index,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: FutureBuilder<List<RestaurantCardData>>(
                  future: futureRestaurantsData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No restaurants found"));
                    } else {
                      var restaurantsData = snapshot.data!;
                      return ListView.separated(
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, PagesRouteName.restaurantFoodItem);
                          },
                          child: RestaurantCard(
                            restaurantCardData: restaurantsData[index],
                          ),
                        ),
                        separatorBuilder: (context, index) => const SizedBox(width: 16),
                        itemCount: restaurantsData.length,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
