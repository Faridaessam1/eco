import 'package:eco_eaters_app_3/ui/customer/restaurantsTab/widgets/custom_tab_bar_item_customer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Data/restaurant_card_data.dart';
import '../../../core/FirebaseServices/firebas_firestore_customer.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/routes/page_route_names.dart';
import '../widgets/restaurant_card.dart';

class RestaurantsTab extends StatefulWidget {
  final String? category; // New: Receive the category

  RestaurantsTab({this.category}); // Make category optional

  @override
  State<RestaurantsTab> createState() => _RestaurantsTabState();
}

class _RestaurantsTabState extends State<RestaurantsTab> {
  int SelectedIndex = 0;
  late Future<List<RestaurantCardData>> futureRestaurantsData;
  List<String> tabNames = [
    "All",
    "Fast Food",
    "Hotel",
    "Restaurants",
    "Desserts",
  ];
  List<RestaurantCardData> restaurantsData = [];

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      // If a category is passed, fetch restaurants by that category
      futureRestaurantsData =
          FireBaseFirestoreServicesCustomer.getRestaurantsByCategory(
              widget.category!);
      SelectedIndex =
          tabNames.indexOf(widget.category!); //set the selected index
    } else {
      // Otherwise, fetch all restaurants
      futureRestaurantsData =
          FireBaseFirestoreServicesCustomer.getAllRestaurants();
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                AppAssets.appLogo,
                height: height * 0.03,
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DefaultTabController(
                length: tabNames.length,
                child: TabBar(
                  onTap: (index) {
                    setState(() {
                      SelectedIndex = index;
                      if (index == 0) {
                        futureRestaurantsData =
                            FireBaseFirestoreServicesCustomer
                                .getAllRestaurants();
                      } else {
                        futureRestaurantsData =
                            FireBaseFirestoreServicesCustomer
                                .getRestaurantsByCategory(
                              tabNames[index],
                            );
                      }
                    });
                  },
                  splashFactory: NoSplash
                      .splashFactory, // btshel el shadow el byb2a mawgod kol ma a select tab
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
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: FutureBuilder<List<RestaurantCardData>>(
                  future: futureRestaurantsData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text("No restaurants found"));
                    } else {
                      final restaurants = snapshot.data!;
                      // No need to filter here, the future builder gets the data already filtered
                      return ListView.separated(
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              PagesRouteName.restaurantFoodItem,
                              arguments: restaurants[index]
                                  .restaurantName, // تمرير اسم المطعم
                            );
                          },
                          child: RestaurantCard(
                            restaurantCardData: restaurants[index],
                          ),
                        ),
                        separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
                        itemCount: restaurants.length,
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