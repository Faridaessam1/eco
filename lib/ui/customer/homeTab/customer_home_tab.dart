import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../Data/recently_added_dish_data_model.dart';
import '../../../core/FirebaseServices/firebas_firestore_customer.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../restaurantsTab/restaurants_tab.dart';
import '../widgets/recently_added_card.dart';

class CustomerHomeTab extends StatefulWidget {
  @override
  State<CustomerHomeTab> createState() => _CustomerHomeTabState();
}

class _CustomerHomeTabState extends State<CustomerHomeTab> {
  Future<List<RecentlyAddedDishDataModel>>? _recentDishesFuture;
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final List<String> adImages = [
    AppAssets.ad3,
    AppAssets.ad1,
    AppAssets.ad4,
    AppAssets.ad5,
  ];

  @override
  void initState() {
    super.initState();
    _recentDishesFuture =
        FireBaseFirestoreServicesCustomer.getRecentlyAddedDishes();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(AppAssets.appLogo, height: height * 0.04),
        actions: [
          IconButton(
            onPressed: () {},
            icon:
                Image.asset(AppAssets.notificationsIcon, width: 20, height: 20),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.04), // Responsive padding
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to EcoEaters",
                style: TextStyle(
                  fontSize: height * 0.025,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Save Food, Save Money!",
                style: TextStyle(
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreen,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: height * 0.25,
                child: PageView.builder(
                    controller: _pageController,
                    itemCount: adImages.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        adImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    }),
              ),
              Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: adImages.length,
                  effect: const WormEffect(
                    activeDotColor: AppColors.primaryColor,
                    dotHeight: 8.0,
                    dotWidth: 8.0,
                  ),
                  onDotClicked: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: height * 0.024, // Responsive font size
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: height * 0.02), // Responsive spacing
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategoryItem(
                              "Fast Food",
                              AppAssets.fastFoodIcon,
                              context,
                              height,
                              width), // Pass context, height, width
                          _buildCategoryItem("Restaurants",
                              AppAssets.restaurantIcon, context, height, width),
                          _buildCategoryItem("Desserts", AppAssets.dessertIcon,
                              context, height, width),
                          _buildCategoryItem("Hotel", AppAssets.hotelsIcon,
                              context, height, width),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.02), // Responsive spacing
                  ],
                ),
              ),
              SizedBox(height: height * 0.01), // Responsive spacing
              Text(
                "Recently Added",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: height * 0.024, // Responsive font size
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: height * 0.01),
              FutureBuilder<List<RecentlyAddedDishDataModel>>(
                future: _recentDishesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading dishes'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No recently added dishes'));
                  } else {
                    List<RecentlyAddedDishDataModel> dishes = snapshot.data!;
                    return SizedBox(
                      height: height * 0.24, // Responsive height
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: dishes.length,
                        itemBuilder: (context, index) {
                          return RecentlyAddedCard(dishData: dishes[index]);
                        },
                        separatorBuilder: (_, __) =>
                            SizedBox(width: width * 0.026), // Responsive width
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String category, String iconPath,
      BuildContext context, double height, double width) {
    // Added height and width
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RestaurantsTab(category: category),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(right: width * 0.106), // Responsive padding
        child: Column(
          children: [
            Image.asset(
              iconPath,
              height: height * 0.07, // Responsive icon height
            ),
            SizedBox(height: height * 0.006), // Responsive spacing
            Text(
              category,
              style: TextStyle(
                color: AppColors.black,
                fontSize: height * 0.018, // Responsive font size
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
