import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../widgets.dart';

// ignore_for_file: must_be_immutable
class EditUserProfileScreen extends StatelessWidget {
  EditUserProfileScreen({super.key});

  List<String> dropdownItemList = ["Item One", "Item Two", "Item Three"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: 14.h),
                  child: Text(
                    "GYM PRO",
                    style: theme.textTheme.displaySmall,
                  ),
                ),
              ),
              SizedBox(height: 58.h),
              _buildProfileHeader(context),
              SizedBox(height: 16.h),
              _buildDividerLine(context),
              SizedBox(height: 38.h),
              _buildNameRow(context),
              SizedBox(height: 18.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 26.h,
                  endIndent: 16.h,
                ),
              ),
              SizedBox(height: 12.h),
              _buildEmailRow(context),
              SizedBox(height: 26.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 26.h,
                  endIndent: 16.h,
                ),
              ),
              SizedBox(height: 24.h),
              _buildMobileNumberRow(context),
              SizedBox(height: 26.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 26.h,
                  endIndent: 16.h,
                ),
              ),
              SizedBox(height: 16.h),
              _buildGenderSelection(context),
              Spacer(),
              CustomElevatedButton(
                height: 46.h,
                width: 216.h,
                text: "Save change",
                buttonTextStyle: CustomTextStyles.titleLargeWhiteA700,
              )
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
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 16.h),
      child: Row(
        children: [
          Container(
            height: 70.h,
            width: 70.h,
            decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder34,
            ),
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgEllipse3370,
                  height: 24.h,
                  width: 26.h,
                  radius: BorderRadius.circular(
                    12.h,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your name",
                  style: CustomTextStyles.bodyLargePoppins,
                ),
                Text(
                  "yourname@gmail.com",
                  style: CustomTextStyles.bodyMediumPoppinsGray60001,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildDividerLine(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 18.h),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicWidth(
            child: SizedBox(
              width: 470.h,
              child: Divider(
                color: appTheme.gray200,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildNameRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(
        start: 26.h,
        end: 20.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Name",
            style: CustomTextStyles.bodyLargeBlack900_1,
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Container(
              margin: EdgeInsetsDirectional.only(top: 6.h),
              padding: EdgeInsetsDirectional.symmetric(horizontal: 30.h),
              decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder8,
              ),
              child: Text(
                "your name",
                textAlign: TextAlign.left,
                style: CustomTextStyles.bodyLargeBluegray70001,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildEmailRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(
        start: 26.h,
        end: 16.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Email account",
            style: theme.textTheme.bodyLarge,
          ),
          Container(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 6.h),
            decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder8,
            ),
            child: Text(
              "yourname@gmail.com",
              textAlign: TextAlign.left,
              style: CustomTextStyles.bodyLargeBluegray70001,
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildMobileNumberRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(
        start: 26.h,
        end: 16.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Mobile number ",
            style: theme.textTheme.bodyLarge,
          ),
          Container(
            height: 22.h,
            width: 158.h,
            padding: EdgeInsetsDirectional.only(end: 30.h),
            decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder8,
            ),
            child: Stack(
              alignment: AlignmentDirectional.centerEnd,
              children: [
                Text(
                  "Add number",
                  style:
                      CustomTextStyles.bodyMediumWorkSansBluegray70001Regular,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildGenderSelection(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 26.h),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicWidth(
            child: SizedBox(
              width: 464.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(bottom: 6.h),
                      child: Text(
                        "Gender",
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(start: 206.h),
                      child: CustomDropDown(
                        icon: Container(
                          margin: EdgeInsetsDirectional.only(start: 16.h),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgArrowdown,
                            height: 16.h,
                            width: 16.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        iconSize: 16.h,
                        items: dropdownItemList,
                        contentPadding: EdgeInsetsDirectional.symmetric(
                          horizontal: 12.h,
                          vertical: 2.h,
                        ),
                        borderDecoration:
                            DropDownStyleHelper.fillOnPrimaryContainer,
                        filled: true,
                        fillColor: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 46.h),
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
      ),
    );
  }
}
