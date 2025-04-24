import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../app_theme.dart';
import '../app_utils.dart';
import '../responsive_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';
import '../services/registration_provider.dart';
import '../services/auth_service.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({Key? key}) : super(key: key);

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  int selectedWeight = 75; // Default weight
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: context.responsivePadding(vertical: 0.02),
          child: ResponsiveLayout(
            // Mobile layout (portrait)
            mobile: Column(
              children: [
                _buildHeader(context),
                Spacer(flex: 62),
                _buildWeightSelectionRow(context),
                CustomImageView(
                  imagePath: ImageConstant.imgPolygon1,
                  height: context.heightRatio(0.04),
                  width: context.widthRatio(0.12),
                  radius: BorderRadius.circular(4),
                ),
                SizedBox(height: context.heightRatio(0.01)),
                _buildLineDividerRow(context),
                SizedBox(height: context.heightRatio(0.04)),
                _buildWeightDisplay(context),
                if (_errorMessage != null)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: context.heightRatio(0.02),
                      horizontal: context.widthRatio(0.05),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Spacer(flex: 37),
                _buildContinueButton(context),
                SizedBox(height: context.heightRatio(0.05))
              ],
            ),
            // Tablet layout
            tablet: Column(
              children: [
                _buildHeader(context),
                SizedBox(height: context.heightRatio(0.08)),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildWeightSelectionRow(context),
                        CustomImageView(
                          imagePath: ImageConstant.imgPolygon1,
                          height: context.heightRatio(0.05),
                          width: context.widthRatio(0.1),
                          radius: BorderRadius.circular(4),
                        ),
                        SizedBox(height: context.heightRatio(0.01)),
                        _buildLineDividerRow(context),
                        SizedBox(height: context.heightRatio(0.05)),
                        _buildWeightDisplay(context),
                        if (_errorMessage != null)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: context.heightRatio(0.02),
                              horizontal: context.widthRatio(0.05),
                            ),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
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
                      _buildWeightSelectionRow(context),
                      CustomImageView(
                        imagePath: ImageConstant.imgPolygon1,
                        height: context.heightRatio(0.05),
                        width: context.widthRatio(0.08),
                        radius: BorderRadius.circular(4),
                      ),
                      SizedBox(height: context.heightRatio(0.01)),
                      _buildLineDividerRow(context),
                      SizedBox(height: context.heightRatio(0.05)),
                      _buildWeightDisplay(context),
                      if (_errorMessage != null)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: context.heightRatio(0.02),
                            horizontal: context.widthRatio(0.05),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
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

  /// Section Widget - Header
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: context.heightRatio(0.1),
      width: ResponsiveUtils.responsiveValue(
        context: context,
        mobile: double.infinity,
        tablet: context.widthRatio(0.7),
        desktop: context.widthRatio(0.3),
      ),
      margin: EdgeInsets.symmetric(horizontal: context.widthRatio(0.1)),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: Text(
              "GYM PRO",
              style: TextStyle(
                fontSize: context.responsiveFontSize(28),
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                fontFamily: theme.textTheme.displaySmall?.fontFamily,
              ),
            ),
          ),
          Text(
            "What Is Your Weight?",
            style: TextStyle(
              fontSize: context.responsiveFontSize(22),
              fontWeight: FontWeight.bold,
              fontFamily: CustomTextStyles.headlineSmallWorkSansBold.fontFamily,
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget - AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: AppbarSubtitleOne(
        text: "←",
        margin: EdgeInsets.only(left: context.widthRatio(0.03)),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  /// Section Widget - Weight Selection Row
  Widget _buildWeightSelectionRow(BuildContext context) {
    final double fontSize = context.responsiveFontSize(20);
    final double selectedFontSize = context.responsiveFontSize(32);
    
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: context.widthRatio(0.08)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "73",
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: appTheme.black900,
              fontFamily: CustomTextStyles.headlineSmallPoppinsBlack900.fontFamily,
            ),
          ),
          SizedBox(
            width: context.widthRatio(0.12),
            child: Text(
              "74",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: appTheme.black900,
                fontFamily: CustomTextStyles.displaySmallBlack900.fontFamily,
              ),
            ),
          ),
          Text(
            "75",
            style: TextStyle(
              fontSize: selectedFontSize,
              fontWeight: FontWeight.bold,
              color: appTheme.black900,
              fontFamily: theme.textTheme.displayMedium?.fontFamily,
            ),
          ),
          SizedBox(
            width: context.widthRatio(0.12),
            child: Text(
              "76",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: appTheme.black900,
                fontFamily: CustomTextStyles.displaySmallBlack900.fontFamily,
              ),
            ),
          ),
          Text(
            "77",
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: appTheme.black900,
              fontFamily: CustomTextStyles.headlineSmallPoppinsBlack900.fontFamily,
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget - Weight Display
  Widget _buildWeightDisplay(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          selectedWeight.toString(),
          style: TextStyle(
            fontSize: context.responsiveFontSize(60),
            fontWeight: FontWeight.bold,
            color: appTheme.black900,
            fontFamily: CustomTextStyles.displayLargeBlack900.fontFamily,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: context.heightRatio(0.035)),
          child: Text(
            "kg",
            style: TextStyle(
              fontSize: context.responsiveFontSize(18),
              fontWeight: FontWeight.bold,
              color: appTheme.black900,
              fontFamily: CustomTextStyles.titleLargePoppinsBlack900.fontFamily,
            ),
          ),
        )
      ],
    );
  }

  /// Section Widget - Line Divider Row
  Widget _buildLineDividerRow(BuildContext context) {
    // Calculate divider width based on screen width
    final double dividerWidth = ResponsiveUtils.responsiveValue<double>(
      context: context,
      mobile: context.widthRatio(0.005),
      tablet: context.widthRatio(0.004),
      desktop: context.widthRatio(0.003),
    );
    
    // Calculate container width based on screen size
    final double containerWidth = ResponsiveUtils.responsiveValue<double>(
      context: context,
      mobile: context.widthRatio(0.8),
      tablet: context.widthRatio(0.6),
      desktop: context.widthRatio(0.4),
    );
    
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        width: containerWidth,
        padding: EdgeInsets.symmetric(
          horizontal: context.widthRatio(0.05),
          vertical: context.heightRatio(0.015),
        ),
        decoration: AppDecoration.fillOnPrimaryContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(19, (index) {
            // Make the 10th divider (index 9) orange and thicker
            if (index == 9) {
              return VerticalDivider(
                width: dividerWidth * 1.5,
                thickness: dividerWidth * 1.5,
                color: appTheme.orangeA700,
              );
            }
            // Make the 15th divider (index 14) black and slightly thicker
            else if (index == 14) {
              return VerticalDivider(
                width: dividerWidth,
                thickness: dividerWidth,
                color: appTheme.black900,
              );
            }
            // Normal dividers
            else {
              return VerticalDivider(
                width: dividerWidth,
                thickness: dividerWidth,
              );
            }
          }),
        ),
      ),
    );
  }

  /// Section Widget - Continue Button
  Widget _buildContinueButton(BuildContext context) {
    return CustomElevatedButton(
      height: context.heightRatio(0.06),
      width: ResponsiveUtils.responsiveValue(
        context: context,
        mobile: context.widthRatio(0.5),
        tablet: context.widthRatio(0.4),
        desktop: context.widthRatio(0.25),
      ),
      text: _isLoading ? "Creating account..." : "Continue",
      buttonTextStyle: TextStyle(
        fontSize: context.responsiveFontSize(18),
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: CustomTextStyles.headlineSmallPoppinsWhiteA700.fontFamily,
      ),
      onPressed: _isLoading ? null : _completeRegistration,
    );
  }
  
  /// Complete the registration process
  void _completeRegistration() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Save the selected weight in provider
      final registrationProvider = Provider.of<RegistrationProvider>(context, listen: false);
      registrationProvider.setWeight(selectedWeight);
      
      // Get complete user data for registration
      final userData = registrationProvider.getCompleteUserData();
      
      // Debug print - remove in production
      print('Sending registration data: ${json.encode(userData)}');
      
      // Call the signup API with all collected data - making sure to use POST
      final result = await Provider.of<AuthService>(context, listen: false).signUp(userData);
      
      // Debug - remove in production
      print('Registration successful: $result');
      
      // Navigate to home screen on success
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.homeScreen,
        (route) => false
      );
    } catch (e) {
      print('Registration error: $e'); // Debug - remove in production
      setState(() {
        _errorMessage = e.toString();
        if (e.toString().contains('409')) {
          _errorMessage = "Email already exists";
        } else {
          _errorMessage = "Registration failed: ${e.toString()}";
        }
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
