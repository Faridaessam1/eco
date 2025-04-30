import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../Data/recently_added_dish_data_model.dart';
import '../../../core/FirebaseServices/firebas_firestore_customer.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/recently_added_card.dart';

class CustomerHomeTab extends StatefulWidget {
  @override
  State<CustomerHomeTab> createState() => _CustomerHomeTabState();
}

class _CustomerHomeTabState extends State<CustomerHomeTab> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final List<String> adImages = [
    AppAssets.ad3,
    AppAssets.ad1,
    AppAssets.ad4,
    AppAssets.ad5,
  ];

  Future<List<RecentlyAddedDishDataModel>>? _recentDishesFuture;

  @override
  void initState() {
    super.initState();
    _recentDishesFuture =
        FireBaseFirestoreServicesCustomer.getRecentlyAddedDishes();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(AppAssets.appLogo),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(AppAssets.searchIcon, width: 20, height: 20),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset(AppAssets.notificationsIcon, width: 20, height: 20),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome To EcoEaters",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: AppColors.black,
                ),
              ),
              const Text(
                "Save Food, Save Money!",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: AppColors.primaryColor,
                ),
              ),
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
                  },
                ),
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



              const Text(
                "Categories",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(AppAssets.fastFoodIcon, height: height * 0.07),
                      Image.asset(AppAssets.restaurantIcon, height: height * 0.07),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Fast Food",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Restaurants",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(AppAssets.dessertIcon, height: height * 0.07),
                      Image.asset(AppAssets.hotelsIcon, height: height * 0.07),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Desserts",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Hotels",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Recently Added",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<RecentlyAddedDishDataModel>>(
                future: _recentDishesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading dishes'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No recently added dishes'));
                  } else {
                    List<RecentlyAddedDishDataModel> dishes = snapshot.data!;
                    return SizedBox(
                      height: 220,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: dishes.length,
                        itemBuilder: (context, index) {
                          return RecentlyAddedCard(dishData: dishes[index]);
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
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
}
