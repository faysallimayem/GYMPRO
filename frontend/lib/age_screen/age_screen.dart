import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../responsive_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';
import '../services/registration_provider.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  int selectedAge = 20;
  final int minAge = 12;
  final int maxAge = 80;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: selectedAge - minAge,
      viewportFraction: 0.2, // Show 5 items at once
    );

    _pageController.addListener(() {
      int page = _pageController.page!.round();
      if (page != selectedAge - minAge) {
        setState(() {
          selectedAge = page + minAge;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: ResponsiveLayout(
            // Mobile layout
            mobile: Column(
              children: [
                SizedBox(height: context.heightRatio(0.03)),
                _buildHeader(context),
                SizedBox(height: context.heightRatio(0.05)),
                _buildAgeDisplay(context),
                SizedBox(height: context.heightRatio(0.01)),
                _buildHorizontalAgeSelector(context),
                Spacer(),
                _buildContinueButton(context),
                SizedBox(height: context.heightRatio(0.05))
              ],
            ),
            // Tablet layout
            tablet: Column(
              children: [
                SizedBox(height: context.heightRatio(0.04)),
                _buildHeader(context),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAgeDisplay(context),
                        SizedBox(height: context.heightRatio(0.02)),
                        SizedBox(
                          width: context.widthRatio(0.7),
                          child: _buildHorizontalAgeSelector(context),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildContinueButton(context),
                SizedBox(height: context.heightRatio(0.04))
              ],
            ),
            // Desktop layout
            desktop: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeader(context),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAgeDisplay(context),
                      SizedBox(height: context.heightRatio(0.02)),
                      SizedBox(
                        width: context.widthRatio(0.5),
                        child: _buildHorizontalAgeSelector(context),
                      ),
                      SizedBox(height: context.heightRatio(0.08)),
                      _buildContinueButton(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          "GYM PRO",
          style: TextStyle(
            fontSize: context.responsiveFontSize(28),
            fontWeight: FontWeight.bold,
            color: appTheme.orangeA700,
            fontFamily: theme.textTheme.displaySmall?.fontFamily,
          ),
        ),
        SizedBox(height: context.heightRatio(0.01)),
        Text(
          "How Old Are You?",
          style: TextStyle(
            fontSize: context.responsiveFontSize(22),
            fontWeight: FontWeight.bold,
            fontFamily: CustomTextStyles.headlineSmallWorkSansBold.fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _buildAgeDisplay(BuildContext context) {
    return Column(
      children: [
        Text(
          "$selectedAge",
          style: TextStyle(
            fontSize: context.responsiveFontSize(48),
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: theme.textTheme.displayLarge?.fontFamily,
          ),
        ),
        Icon(
          Icons.arrow_drop_down,
          color: appTheme.orangeA700,
          size: context.widthRatio(0.12),
        ),
      ],
    );
  }

  Widget _buildHorizontalAgeSelector(BuildContext context) {
    // Calculate responsive dimensions
    final double selectorHeight = context.heightRatio(0.08);
    final double indicatorWidth = context.widthRatio(0.15);
    final double indicatorHeight = selectorHeight * 0.7;

    return Container(
      height: selectorHeight,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                selectedAge = minAge + index;
              });
            },
            itemCount: maxAge - minAge + 1,
            itemBuilder: (context, index) {
              int age = minAge + index;
              bool isSelected = age == selectedAge;
              return Center(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.widthRatio(0.04),
                    vertical: context.heightRatio(0.01),
                  ),
                  decoration: isSelected
                      ? BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        )
                      : null,
                  child: Text(
                    "$age",
                    style: TextStyle(
                      fontSize: isSelected
                          ? context.responsiveFontSize(24)
                          : context.responsiveFontSize(20),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.black : Colors.black45,
                    ),
                  ),
                ),
              );
            },
          ),
          // Center indicator (orange border in the center)
          Align(
            alignment: Alignment.center,
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                width: indicatorWidth,
                height: indicatorHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: appTheme.orangeA700, width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return CustomElevatedButton(
      height: context.heightRatio(0.06),
      width: ResponsiveUtils.responsiveValue(
        context: context,
        mobile: context.widthRatio(0.5),
        tablet: context.widthRatio(0.4),
        desktop: context.widthRatio(0.25),
      ),
      text: "Continue",
      buttonTextStyle: TextStyle(
        fontSize: context.responsiveFontSize(18),
        color: Color(0xFFFF7900),
        fontWeight: FontWeight.bold,
        fontFamily: CustomTextStyles.headlineSmallPoppinsWhiteA700.fontFamily,
      ),
      onPressed: () {
        // Save selected age to registration provider
        final registrationProvider =
            Provider.of<RegistrationProvider>(context, listen: false);
        registrationProvider.setAge(selectedAge);

        // Navigate to height screen
        Navigator.pushNamed(context, AppRoutes.heightScreen);
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: context.heightRatio(0.06),
      title: AppbarSubtitleOne(
        text: "←",
        margin: EdgeInsets.only(left: context.widthRatio(0.03)),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
