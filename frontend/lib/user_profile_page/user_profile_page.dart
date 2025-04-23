import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart'; // ignore_for_file: must_be_immutable

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key})
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
          padding: EdgeInsetsDirectional.symmetric(horizontal: 14.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  "GYM PRO",
                  style: theme.textTheme.displaySmall,
                ),
              ),
              Text(
                "Profile",
                style: CustomTextStyles.headlineSmallPoppins,
              ),
              SizedBox(height: 8.h),
              CustomIconButton(
                height: 150.h,
                width: 150.h,
                padding: EdgeInsetsDirectional.all(54.h),
                decoration: IconButtonStyleHelper.fillOnPrimaryContainerTL74,
                child: CustomImageView(
                  imagePath: ImageConstant.imgCameraBlack900,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Nick",
                style: CustomTextStyles.headlineSmallSignika,
              ),
              SizedBox(height: 22.h),
              _buildEditProfileRow(context),
              SizedBox(height: 18.h),
              _buildSettingsRow(context),
              SizedBox(height: 18.h),
              _buildLogoutRow(context)
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 26.h,
      leadingWidth: 18.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgUserPrimary,
        margin: EdgeInsetsDirectional.only(start: 12.h),
      ),
      title: AppbarSubtitleFour(
        text: "Back",
        margin: EdgeInsetsDirectional.only(start: 9.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildEditProfileRow(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 8.h),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 8.h,
        vertical: 14.h,
      ),
      decoration: AppDecoration.gray5.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      width: double.maxFinite,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsetsDirectional.only(start: 6.h),
              child: Row(
                children: [
                  CustomIconButton(
                    height: 48.h,
                    width: 48.h,
                    padding: EdgeInsetsDirectional.all(10.h),
                    decoration: IconButtonStyleHelper.fillOrange,
                    child: CustomImageView(
                      imagePath: ImageConstant.imgLockPrimary48x48,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 12.h),
                    child: Text(
                      "Edit Profile",
                      style: CustomTextStyles.titleMediumWorkSansOnPrimary,
                    ),
                  )
                ],
              ),
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgArrowRight,
            height: 24.h,
            width: 24.h,
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSettingsRow(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 8.h),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 8.h,
        vertical: 14.h,
      ),
      decoration: AppDecoration.gray5.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(start: 6.h),
            child: CustomIconButton(
              height: 48.h,
              width: 48.h,
              padding: EdgeInsetsDirectional.all(10.h),
              decoration: IconButtonStyleHelper.fillOrange,
              child: CustomImageView(
                imagePath: ImageConstant.imgSearch,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 12.h),
            child: Text(
              "Settings",
              style: CustomTextStyles.titleMediumWorkSansOnPrimary,
            ),
          ),
          Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imgArrowRight,
            height: 24.h,
            width: 26.h,
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildLogoutRow(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 8.h),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 8.h,
        vertical: 14.h,
      ),
      decoration: AppDecoration.gray5.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(start: 6.h),
            child: CustomIconButton(
              height: 48.h,
              width: 48.h,
              padding: EdgeInsetsDirectional.all(10.h),
              decoration: IconButtonStyleHelper.fillOrange,
              child: CustomImageView(
                imagePath: ImageConstant.imgUserPrimary48x48,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 12.h),
            child: Text(
              "Log out",
              style: CustomTextStyles.titleMediumWorkSansOnPrimary,
            ),
          ),
          Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imgArrowRight,
            height: 24.h,
            width: 26.h,
            alignment: AlignmentDirectional.topCenter,
            margin: EdgeInsetsDirectional.only(top: 10.h),
          )
        ],
      ),
    );
  }
}
