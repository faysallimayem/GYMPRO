import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';

// ignore_for_file: must_be_immutable
class AddUserScreen extends StatelessWidget {
  AddUserScreen({Key? key})
      : super(
          key: key,
        );

  TextEditingController firstNameInputController = TextEditingController();

  TextEditingController secondNameInputController = TextEditingController();

  TextEditingController emailInputController = TextEditingController();

  List<String> dropdownItemList = ["Item One", "Item Two", "Item Three"];

  TextEditingController noneoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsetsDirectional.symmetric(vertical: 38.h),
          child: Column(
            children: [
              _buildAddUserButton(context),
              SizedBox(height: 42.h),
              _buildFirstNameRow(context),
              SizedBox(height: 22.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 20.h,
                  endIndent: 24.h,
                ),
              ),
              SizedBox(height: 16.h),
              _buildSecondNameRow(context),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 16.h,
                  endIndent: 26.h,
                ),
              ),
              SizedBox(height: 16.h),
              _buildEmailRow(context),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 16.h,
                  endIndent: 26.h,
                ),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 16.h,
                  end: 26.h,
                ),
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
                  hintText: "Role",
                  items: dropdownItemList,
                  contentPadding:
                      EdgeInsetsDirectional.fromSTEB(12.h, 14.h, 6.h, 14.h),
                ),
              ),
              SizedBox(height: 20.h),
              _buildHorizontalScroll(context),
              SizedBox(height: 12.h),
              _buildBirthDateRow(context),
              SizedBox(height: 94.h),
              _buildConfirmButton(context),
              Spacer(),
              Text(
                "Add Exercise",
                style: CustomTextStyles.titleSmallWorkSansWhiteA700,
              ),
              SizedBox(height: 12.h)
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 48.h,
      title: AppbarSubtitleOne(
        text: "←",
        margin: EdgeInsetsDirectional.only(start: 11.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildAddUserButton(BuildContext context) {
    return CustomElevatedButton(
      height: 60.h,
      text: "Add User",
      margin: EdgeInsetsDirectional.only(
        start: 86.h,
        end: 88.h,
      ),
      buttonStyle: CustomButtonStyles.fillOnPrimaryContainer,
      buttonTextStyle: CustomTextStyles.headlineSmallPoppins_1,
    );
  }

  /// Section Widget
  Widget _buildFirstNameInput(BuildContext context) {
    return CustomTextFormField(
      width: 190.h,
      controller: firstNameInputController,
      hintText: "Eg: Jhon",
      contentPadding: EdgeInsetsDirectional.fromSTEB(18.h, 6.h, 18.h, 2.h),
    );
  }

  /// Section Widget
  Widget _buildFirstNameRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(
        start: 20.h,
        end: 24.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "First Name",
            style: CustomTextStyles.bodyLargeBlack900_1,
          ),
          _buildFirstNameInput(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSecondNameInput(BuildContext context) {
    return CustomTextFormField(
      width: 190.h,
      controller: secondNameInputController,
      hintText: "Eg: Wick",
      alignment: AlignmentDirectional.center,
      contentPadding: EdgeInsetsDirectional.fromSTEB(18.h, 6.h, 18.h, 2.h),
    );
  }

  /// Section Widget
  Widget _buildSecondNameRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(
        start: 16.h,
        end: 24.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Second Name",
            style: CustomTextStyles.bodyLargeBlack900_1,
          ),
          _buildSecondNameInput(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildEmailInput(BuildContext context) {
    return CustomTextFormField(
      width: 190.h,
      controller: emailInputController,
      hintText: "yourname@exapmle.com",
      alignment: AlignmentDirectional.center,
      contentPadding: EdgeInsetsDirectional.fromSTEB(18.h, 6.h, 18.h, 2.h),
    );
  }

  /// Section Widget
  Widget _buildEmailRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(
        start: 16.h,
        end: 24.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email account",
            style: theme.textTheme.bodyLarge,
          ),
          _buildEmailInput(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildNoneone(BuildContext context) {
    return Expanded(
      child: CustomTextFormField(
        controller: noneoneController,
        hintText: "None",
        hintStyle: CustomTextStyles.bodyMediumWorkSansBluegray70001,
        textInputAction: TextInputAction.done,
        alignment: AlignmentDirectional.center,
        suffix: Padding(
          padding: EdgeInsetsDirectional.only(
            start: 16.h,
            top: 8.h,
            bottom: 8.h,
          ),
          child: Text(
            "None",
            style: TextStyle(
              color: appTheme.blueGray70001,
              fontSize: 14.fSize,
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
        suffixConstraints: BoxConstraints(
          maxHeight: 54.h,
        ),
        contentPadding: EdgeInsetsDirectional.only(
          start: 12.h,
          top: 16.h,
          bottom: 16.h,
        ),
        borderDecoration: TextFormFieldStyleHelper.underLineBlack,
        filled: false,
      ),
    );
  }

  /// Section Widget
  Widget _buildHorizontalScroll(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 16.h),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicWidth(
            child: SizedBox(
              width: 464.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNoneone(context),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: 42.h,
                      top: 4.h,
                    ),
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

  /// Section Widget
  Widget _buildBirthDateRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Birth Date",
            style: theme.textTheme.bodyLarge,
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: 22.h),
              child: Text(
                "DD/MM/YY",
                style: CustomTextStyles.bodyMediumWorkSansExtraLight,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildConfirmButton(BuildContext context) {
    return CustomElevatedButton(
      height: 32.h,
      width: 158.h,
      text: "Confirm",
      buttonStyle: CustomButtonStyles.fillPrimaryTL16,
      buttonTextStyle: CustomTextStyles.bodyLargeWhiteA700,
    );
  }
}
