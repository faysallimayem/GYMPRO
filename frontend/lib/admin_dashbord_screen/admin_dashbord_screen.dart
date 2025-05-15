import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../widgets.dart';
import '../responsive_utils.dart';
import '../routes/app_routes.dart';

class AdminDashbordScreen extends StatelessWidget {
  const AdminDashbordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: context.responsivePadding(vertical: 0.02),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: context.heightRatio(0.01)),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "GYM",
                          style: CustomTextStyles.headlineSmallPoppinsPrimary_1
                              .copyWith(
                            fontSize: context.responsiveFontSize(30),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " PRO",
                          style: CustomTextStyles.headlineSmallPoppinsPrimary_1
                              .copyWith(
                            fontSize: context.responsiveFontSize(30),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: context.heightRatio(0.02)),
              CustomElevatedButton(
                height: context.heightRatio(0.06),
                text: "Admin Dashboard",
                margin: EdgeInsetsDirectional.only(
                  start: context.widthRatio(0.1),
                  end: context.widthRatio(0.1),
                ),
                buttonStyle: CustomButtonStyles.fillOnPrimaryContainer,
                buttonTextStyle: CustomTextStyles.headlineSmallPoppins_1,
              ),
              SizedBox(height: context.heightRatio(0.02)),
              _buildUserManagementSection(context),
              SizedBox(height: context.heightRatio(0.02)),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: context.widthRatio(0.03),
                  endIndent: context.widthRatio(0.05),
                ),
              ),
              SizedBox(height: context.heightRatio(0.02)),
              _buildNutritionManagementSection(context),
              SizedBox(height: context.heightRatio(0.02)),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: context.widthRatio(0.03),
                  endIndent: context.widthRatio(0.05),
                ),
              ),
              SizedBox(height: context.heightRatio(0.02)),
              _buildCoursesManagementSection(context),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildUserManagementSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.userManagmentScreen);
      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsetsDirectional.only(
          start: context.widthRatio(0.03),
          end: context.widthRatio(0.05),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "User Management",
                style: CustomTextStyles.bodyLargeBlack900_1,
              ),
            ),
            Container(
              height: context.heightRatio(0.04),
              width: context.widthRatio(0.2),
              decoration: AppDecoration.fillPrimary.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder12,
              ),
              child: Center(
                child: Icon(
                  Icons.people, // Using a people icon for user management
                  size: context.heightRatio(0.03),
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildNutritionManagementSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(
        start: context.widthRatio(0.03),
        end: context.widthRatio(0.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "Supplements Management",
              style: theme.textTheme.bodyLarge,
            ),
          ),
          Container(
            height: context.heightRatio(0.04),
            width: context.widthRatio(0.2),
            decoration: AppDecoration.fillPrimary.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder12,
            ),
            child: Center(
              child: Icon(
                Icons
                    .medication_outlined, // Using a pill/medicine icon for supplements
                size: context.heightRatio(0.03),
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildCoursesManagementSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.courseManagementScreen);
      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsetsDirectional.only(
            start: context.widthRatio(0.03), end: context.widthRatio(0.05)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Courses Management",
                style: theme.textTheme.bodyLarge,
              ),
            ),
            Container(
              height: context.heightRatio(0.04),
              width: context.widthRatio(0.2),
              decoration: AppDecoration.fillPrimary.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder12,
              ),
              child: Center(
                child: Icon(
                  Icons.calendar_today, // Using a calendar icon for courses
                  size: context.heightRatio(0.03),
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
