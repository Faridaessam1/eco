import 'package:eco_eaters_app_3/core/routes/page_route_names.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../onBoarding1.dart';
import '../onBoarding2.dart';
import '../onBoarding3.dart';
import '../onBoarding4.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double buttonWidth = size.width * 0.8;
    final double buttonHeight = size.height * 0.05;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor.withOpacity(0.1),
              AppColors.white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [

            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [
                  const OnBoardingPage1(),
                  const OnBoardingPage2(),
                  const OnBoardingPage3(),
                  const OnBoardingPage4()
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.02,
              ),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 4,
                    effect: ExpandingDotsEffect(
                      dotWidth: size.width * 0.025,
                      dotHeight: size.width * 0.025,
                      activeDotColor: AppColors.green,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          text: currentPage == 0 ? "Get Started" : "Next",
                          buttonColor: AppColors.primaryColor,
                          textColor: AppColors.white,
                          borderRadius: 12,
                          fontSize: size.width * 0.045,
                          width: buttonWidth,
                          height: buttonHeight,
                          onPressed: () {
                            if (currentPage < 3) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            } else {
                              Navigator.pushNamed(context,PagesRouteName.userType);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
