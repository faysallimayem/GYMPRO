// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../responsive_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';
import '../services/registration_provider.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String selectedGender = "";

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: context.responsivePadding(
                horizontal: 0.05,
                vertical: 0.02,
              ),
              child: ResponsiveLayout(
                // Mobile layout (default)
                mobile: Column(
                  children: [
                    _buildHeader(),
                    SizedBox(height: context.heightRatio(0.06)),
                    _buildGenderOptions(),
                    SizedBox(height: context.heightRatio(0.08)),
                    _buildContinueButton(),
                    SizedBox(height: context.heightRatio(0.05))
                  ],
                ),
                // Tablet layout
                tablet: Column(
                  children: [
                    _buildHeader(),
                    SizedBox(height: context.heightRatio(0.08)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: _buildGenderOption(
                          label: "Male",
                          imagePath: ImageConstant.imgBotGenderMale,
                          isSelected: selectedGender == "Male",
                          onTap: () {
                            setState(() {
                              selectedGender = "Male";
                            });
                          },
                        )),
                        Expanded(child: _buildGenderOption(
                          label: "Female",
                          imagePath: ImageConstant.imgLaptop,
                          isSelected: selectedGender == "Female",
                          onTap: () {
                            setState(() {
                              selectedGender = "Female";
                            });
                          },
                        )),
                      ],
                    ),
                    SizedBox(height: context.heightRatio(0.1)),
                    _buildContinueButton(),
                  ],
                ),
                // Desktop layout
                desktop: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildHeader(),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(child: _buildGenderOption(
                                label: "Male",
                                imagePath: ImageConstant.imgBotGenderMale,
                                isSelected: selectedGender == "Male",
                                onTap: () {
                                  setState(() {
                                    selectedGender = "Male";
                                  });
                                },
                              )),
                              Expanded(child: _buildGenderOption(
                                label: "Female",
                                imagePath: ImageConstant.imgLaptop,
                                isSelected: selectedGender == "Female",
                                onTap: () {
                                  setState(() {
                                    selectedGender = "Female";
                                  });
                                },
                              )),
                            ],
                          ),
                          SizedBox(height: context.heightRatio(0.08)),
                          _buildContinueButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return SizedBox(
      height: context.heightRatio(0.12),
      width: context.widthRatio(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // GYM PRO title at the top
          Text(
            "GYM PRO",
            style: TextStyle(
              fontSize: context.responsiveFontSize(28),
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              fontFamily: theme.textTheme.displaySmall?.fontFamily,
            ),
          ),
          // Add spacing between texts
          SizedBox(height: context.heightRatio(0.02)),
          // What's Your Gender text below
          Text(
            "What's Your Gender",
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
  
  Widget _buildGenderOptions() {
    return Column(
      children: [
        _buildGenderOption(
          label: "Male",
          imagePath: ImageConstant.imgBotGenderMale,
          isSelected: selectedGender == "Male",
          onTap: () {
            setState(() {
              selectedGender = "Male";
            });
          },
        ),
        SizedBox(height: context.heightRatio(0.05)),
        _buildGenderOption(
          label: "Female",
          imagePath: ImageConstant.imgLaptop,
          isSelected: selectedGender == "Female",
          onTap: () {
            setState(() {
              selectedGender = "Female";
            });
          },
        ),
      ],
    );
  }
  
  Widget _buildContinueButton() {
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
        color:Color(0xFFFF7900),
        fontWeight: FontWeight.bold,
        fontFamily: CustomTextStyles.headlineSmallPoppinsWhiteA700.fontFamily,
      ),
      onPressed: () {
        if (selectedGender.isNotEmpty) {
          final registrationProvider = Provider.of<RegistrationProvider>(context, listen: false);
          registrationProvider.setGender(selectedGender);
          
          // Navigate to age screen
          Navigator.pushNamed(
            context,
            AppRoutes.ageScreen,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please select your gender"),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }

  Widget _buildGenderOption({
    required String label,
    required String imagePath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // Calculate size based on device type
    final double optionSize = ResponsiveUtils.responsiveValue<double>(
      context: context,
      mobile: context.widthRatio(0.22),
      tablet: context.widthRatio(0.18),
      desktop: context.widthRatio(0.12),
    );
    
    final double iconSize = optionSize * 0.55;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: context.responsiveFontSize(18),
            fontWeight: FontWeight.bold,
            color: appTheme.black900,
            fontFamily: CustomTextStyles.titleLargeBold.fontFamily,
          ),
        ),
        SizedBox(height: context.heightRatio(0.02)),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: optionSize,
            width: optionSize,
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : Colors.orange,
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      )
                    ]
                  : [],
            ),
            child: Center(
              child: CustomImageView(
                imagePath: imagePath,
                height: iconSize,
                width: iconSize,
                color: isSelected ? appTheme.whiteA700 : appTheme.whiteA700,
              ),
            ),
          ),
        ),
      ],
    );
  }

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
}
