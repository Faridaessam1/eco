import 'package:eco_eaters_app_3/ui/seller/home/widgets/custom_insights_container.dart';
import 'package:eco_eaters_app_3/ui/seller/home/widgets/custom_recent_order_container.dart';
import 'package:eco_eaters_app_3/ui/seller/home/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import '../../../Data/insights_data_model.dart';
import '../../../Data/order_data_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/page_route_names.dart';
import '../../../core/seller services/seller_home_services.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<InsightsDataModel> insights = [];
  List<OrderDataModel> recentOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// Initialize all data needed for the home view
  Future<void> _initializeData() async {
    setState(() => isLoading = true);

    final results = await Future.wait([
      SellerHomeServices.fetchRecentOrders(),
      SellerHomeServices.fetchInsights(),
    ]);

    setState(() {
      recentOrders = results[0] as List<OrderDataModel>;
      insights = results[1] as List<InsightsDataModel>;
      isLoading = false;
    });
  }

  /// Refresh data when user pulls to refresh
  Future<void> _onRefresh() async {
    await _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _onRefresh,
        child: _buildBody(mediaQuery),
      ),
    );
  }

  /// Builds the app bar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      title: const Text(
        "EcoEaters",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.green,
        ),
      ),
      actions: [
        const IconButton(
          icon: Icon(Icons.notifications_rounded),
          onPressed: SellerHomeServices.handleNotificationPress,
        ),
        const IconButton(
          icon: Icon(Icons.sunny),
          onPressed: SellerHomeServices.handleThemeToggle,
        ),
      ],
    );
  }

  /// Builds the main body content
  Widget _buildBody(MediaQueryData mediaQuery) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.04),
      child: Column(
        children: [
          _buildInsightsGrid(),
          const SizedBox(height: 30),
          _buildActionButtons(),
          const SizedBox(height: 30),
          _buildRecentOrdersHeader(),
          const SizedBox(height: 20),
          _buildRecentOrdersList(),
        ],
      ),
    );
  }

  /// Builds the insights grid
  Widget _buildInsightsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: insights.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) {
        return CustomInsightsContainer(
          icon: insights[index].icon,
          text: insights[index].title,
          number: insights[index].value,
        );
      },
    );
  }

  /// Builds the action buttons row
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomTextButton(
            onPressed: () {
              Navigator.pushNamed(context, PagesRouteName.sellerNewDishScreen);
            },
            text: "Add New Dish",
            textColor: AppColors.white,
            icon: Icons.add,
            iconColor: AppColors.white,
            buttonColor: AppColors.green,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: CustomTextButton(
            onPressed: () {
              Navigator.pushNamed(context, PagesRouteName.sellerOrdersScreen);
            },
            text: "Today's Order",
            textColor: AppColors.green,
            icon: Icons.menu_rounded,
            iconColor: AppColors.green,
            buttonColor: AppColors.white,
          ),
        ),
      ],
    );
  }

  /// Builds the recent orders header
  Widget _buildRecentOrdersHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Recent Orders",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, PagesRouteName.sellerOrdersScreen);
          },
          child: const Text(
            "View All",
            style: TextStyle(
              color: AppColors.green,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the recent orders list
  Widget _buildRecentOrdersList() {
    return Expanded(
      child: recentOrders.isEmpty
          ? const Center(child: Text("No recent orders."))
          : ListView.builder(
        itemCount: recentOrders.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CustomRecentOrderContainer(
              orderDataModel: recentOrders[index],
            ),
          );
        },
      ),
    );
  }
}