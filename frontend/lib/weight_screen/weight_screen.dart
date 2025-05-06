// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../app_theme.dart';
import '../responsive_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';
import '../services/registration_provider.dart';
import '../services/auth_service.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  int selectedWeight = 70; // Default weight
  bool _isLoading = false;
  String? _errorMessage;
  
  // Define weight range
  final int minWeight = 40;
  final int maxWeight = 220;
  
  // Using FixedExtentScrollController for horizontal weight selection
  late final FixedExtentScrollController _scrollController;
  
  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(
      initialItem: selectedWeight - minWeight, // Initial item calculation
    );
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                _buildWeightDisplay(context),
                SizedBox(height: context.heightRatio(0.03)),
                _buildHorizontalWeightWheel(context),
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
                        _buildWeightDisplay(context),
                        SizedBox(height: context.heightRatio(0.03)),
                        _buildHorizontalWeightWheel(context),
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
                      _buildWeightDisplay(context),
                      SizedBox(height: context.heightRatio(0.03)),
                      _buildHorizontalWeightWheel(context),
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
      height: context.heightRatio(0.12),
      width: ResponsiveUtils.responsiveValue(
        context: context,
        mobile: double.infinity,
        tablet: context.widthRatio(0.7),
        desktop: context.widthRatio(0.3),
      ),
      margin: EdgeInsets.symmetric(horizontal: context.widthRatio(0.1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "GYM PRO",
            style: TextStyle(
              fontSize: context.responsiveFontSize(28),
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              fontFamily: theme.textTheme.displaySmall?.fontFamily,
            ),
          ),
          SizedBox(height: context.heightRatio(0.02)),
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
      
      // Call the register API with all collected data - making sure to use POST
      final result = await Provider.of<AuthService>(context, listen: false).register(userData);
      
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

  // Horizontal weight selector wheel
  Widget _buildHorizontalWeightWheel(BuildContext context) {
    final double containerWidth = context.widthRatio(0.8);
    final double containerHeight = context.heightRatio(0.15);
    
    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5), // Light gray background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The main horizontal wheel
          RotatedBox(
            quarterTurns: 3,
            child: ListWheelScrollView.useDelegate(
              controller: _scrollController,
              physics: const FixedExtentScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemExtent: containerWidth * 0.08,
              diameterRatio: 2.5, 
              perspective: 0.003,
              overAndUnderCenterOpacity: 0.7,
              magnification: 1.2,
              useMagnifier: true,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedWeight = minWeight + index;
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: maxWeight - minWeight + 1,
                builder: (context, index) {
                  final weight = minWeight + index;
                  final bool isMajor = weight % 5 == 0;
                  
                  // Rotate the items back to be readable horizontally
                  return RotatedBox(
                    quarterTurns: 1, // Rotate back 90 degrees
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Weight label (only for multiples of 5)
                        if (isMajor) 
                          Text(
                            weight.toString(),
                            style: TextStyle(
                              fontSize: context.responsiveFontSize(14),
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        
                        // Tick mark
                        if (!isMajor)
                          Container(
                            width: 2,
                            height: containerHeight * 0.15,
                            color: Colors.grey[400],
                          ),
                      ],
                    ),
                  );
                }
              ),
            ),
          ),
          
          // Center indicator (orange line)
          Center(
            child: Container(
              width: 2,
              height: containerHeight * 0.6,
              color: appTheme.orangeA700,
            ),
          ),
        ],
      ),
    );
  }
}
