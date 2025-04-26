import 'package:eco_eaters_app_3/core/routes/page_route_names.dart';
import 'package:eco_eaters_app_3/ui/auth/otp_screen.dart';
import 'package:eco_eaters_app_3/ui/auth/phone_login.dart';
import 'package:eco_eaters_app_3/ui/auth/seller_sign_up_screen.dart';
import 'package:eco_eaters_app_3/ui/customer/feedbackScreen/feedback.dart';
import 'package:flutter/material.dart';
import '../../ui/auth/login_screen.dart';
import '../../ui/auth/customer_sign_up_screen.dart';
import '../../ui/auth/user_type.dart';
import '../../ui/customer/layout/layout.dart';
import '../../ui/customer/orders/customer_order_screen.dart';
import '../../ui/customer/restaurantsFoodItems/restaurants_food_items.dart';
import '../../ui/onBoarding/widget/onBoardingScreen.dart';
import '../../ui/seller/widgets/layout_view.dart';
import '../../ui/splash/splash_screen.dart';

class AppRoutes {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PagesRouteName.onBoarding:
        return MaterialPageRoute(
          builder: (context) => OnBoardingScreen(),
          settings: settings,
        );
      case PagesRouteName.userType:
        return MaterialPageRoute(
          builder: (context) => UserTypeScreen(),
          settings: settings,
        );
      case PagesRouteName.login:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
          settings: settings,
        );
      case PagesRouteName.otpScreen:
        final verificationId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => OtpScreen(verificationId: verificationId),
        );
      case PagesRouteName.customerSignUp:
        return MaterialPageRoute(
          builder: (context) => CustomerSignUpScreen(),
          settings: settings,
        );
      case PagesRouteName.sellerSignUp:
        return MaterialPageRoute(
          builder: (context) => SellerSignUpScreen(),
          settings: settings,
        );

      case PagesRouteName.phoneLoginScreen:
        return MaterialPageRoute(
          builder: (context) => PhoneLoginScreen(),
          settings: settings,
        );

      case PagesRouteName.customerFeedbackScreen:
        return MaterialPageRoute(
          builder: (context) => CustomerFeedbackScreen(),
          settings: settings,
        );

      // Routes from farida-feature
      case PagesRouteName.customerHomeLayout:
        return MaterialPageRoute(
          builder: (context) => LayoutCustomer(),
          settings: settings,
        );
      case PagesRouteName.restaurantFoodItem:
        return MaterialPageRoute(
          builder: (context) => RestaurantFoodItem(),
          settings: settings,
        );
      case PagesRouteName.customerOrdersScreen:
        return MaterialPageRoute(
          builder: (context) => CustomerOrderScreen(),
          settings: settings,
        );
      case PagesRouteName.sellerHomeLayout:
        return MaterialPageRoute(
          builder: (context) => LayOutViewSeller(),
          settings: settings,
        );
      // Default route
      default:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(),
          settings: settings,
        );
    }
  }
}
