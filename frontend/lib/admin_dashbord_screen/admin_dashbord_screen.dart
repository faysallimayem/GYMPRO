import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';

class AdminDashbordScreen extends StatelessWidget {
  const AdminDashbordScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsetsDirectional.symmetric(vertical: 8.h),
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: 16.h),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "GYM",
                          style: CustomTextStyles.headlineSmallPoppinsPrimary_1,
                        ),
                        TextSpan(
                          text: " PRO",
                          style: CustomTextStyles.headlineSmallPoppinsPrimary_1,
                        )
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              CustomElevatedButton(
                height: 60.h,
                text: "Admin Dashbrod",
                margin: EdgeInsetsDirectional.only(
                  start: 92.h,
                  end: 82.h,
                ),
                buttonStyle: CustomButtonStyles.fillOnPrimaryContainer,
                buttonTextStyle: CustomTextStyles.headlineSmallPoppins_1,
              ),
              SizedBox(height: 18.h),
              _buildUserManagementSection(context),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 12.h,
                  endIndent: 32.h,
                ),
              ),
              SizedBox(height: 18.h),
              _buildNutritionManagementSection(context),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 12.h,
                  endIndent: 32.h,
                ),
              ),
              SizedBox(height: 22.h),
              _buildExerciseManagementSection(context),
              Spacer(),
              Text(
                "Add Exercise",
                style: CustomTextStyles.titleSmallWorkSansWhiteA700,
              ),
              SizedBox(height: 40.h)
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: AppbarSubtitleOne(
        text: "←",
        margin: EdgeInsetsDirectional.only(start: 12.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildUserManagementSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(
        start: 12.h,
        end: 32.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Text(
              "User Managment",
              style: CustomTextStyles.bodyLargeBlack900_1,
            ),
          ),
          Container(
            height: 26.h,
            width: 96.h,
            decoration: AppDecoration.fillPrimary.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder12,
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgLockBlack900,
                  height: 24.h,
                  width: 26.h,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildNutritionManagementSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(
        start: 12.h,
        end: 32.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Text(
              "Nutrition Managment",
              style: theme.textTheme.bodyLarge,
            ),
          ),
          Container(
            height: 26.h,
            width: 96.h,
            decoration: AppDecoration.fillPrimary.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder12,
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgMedicalIconINutritionBlack900,
                  height: 24.h,
                  width: 26.h,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildExerciseManagementSection(BuildContext context) {
    return Container(
      height: 98.h,
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(start: 12.h),
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicWidth(
              child: SizedBox(
                width: 464.h,
                child: Column(
                  spacing: 24,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Exercise Managment",
                      style: theme.textTheme.bodyLarge,
                    ),
                    SizedBox(
                      width: 398.h,
                      child: Divider(
                        color: appTheme.black900,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(
                        "USA",
                        style: CustomTextStyles.bodyMediumPoppinsBluegray70001,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: Container(
              height: 26.h,
              width: 96.h,
              margin: EdgeInsetsDirectional.only(end: 32.h),
              decoration: AppDecoration.fillPrimary.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder12,
              ),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgMaximizeBlack900,
                    height: 24.h,
                    width: 26.h,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
