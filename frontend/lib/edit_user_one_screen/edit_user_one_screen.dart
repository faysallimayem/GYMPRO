import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../widgets.dart';

// ignore_for_file: must_be_immutable
class EditUserOneScreen extends StatelessWidget {
  EditUserOneScreen({super.key});

  TextEditingController egjhononeController = TextEditingController();

  TextEditingController egwickoneController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppbar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsetsDirectional.only(top: 42.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildEdituser(context),
              SizedBox(height: 38.h),
              _buildRowfirstname(context),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 20.h,
                  endIndent: 24.h,
                ),
              ),
              SizedBox(height: 16.h),
              _buildRowsecondname(context),
              SizedBox(height: 22.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 20.h,
                  endIndent: 24.h,
                ),
              ),
              SizedBox(height: 10.h),
              _buildRowemailaccount(context),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 20.h,
                  endIndent: 22.h,
                ),
              ),
              SizedBox(height: 24.h),
              _buildStackbirthdate(context),
              SizedBox(height: 32.h),
              _buildConfirm(context)
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 44.h,
      title: AppbarSubtitleOne(
        text: "←",
        margin: EdgeInsetsDirectional.only(start: 12.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildEdituser(BuildContext context) {
    return CustomElevatedButton(
      height: 60.h,
      text: "Edit User",
      margin: EdgeInsetsDirectional.only(
        start: 86.h,
        end: 88.h,
      ),
      buttonStyle: CustomButtonStyles.fillOnPrimaryContainer,
      buttonTextStyle: CustomTextStyles.headlineSmallPoppins_1,
    );
  }

  /// Section Widget
  Widget _buildEgjhonone(BuildContext context) {
    return CustomTextFormField(
      width: 190.h,
      controller: egjhononeController,
      hintText: "Eg: Jhon",
      contentPadding: EdgeInsetsDirectional.fromSTEB(18.h, 6.h, 18.h, 2.h),
    );
  }

  /// Section Widget
  Widget _buildRowfirstname(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(
        start: 20.h,
        end: 26.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Text(
              "First Name",
              style: CustomTextStyles.bodyLargeBlack900_1,
            ),
          ),
          _buildEgjhonone(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildEgwickone(BuildContext context) {
    return CustomTextFormField(
      width: 190.h,
      controller: egwickoneController,
      hintText: "Eg: Wick",
      alignment: AlignmentDirectional.center,
      contentPadding: EdgeInsetsDirectional.fromSTEB(18.h, 6.h, 18.h, 2.h),
    );
  }

  /// Section Widget
  Widget _buildRowsecondname(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(
        start: 16.h,
        end: 26.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Second Name",
            style: CustomTextStyles.bodyLargeBlack900_1,
          ),
          _buildEgwickone(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildEmail(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 2.h),
      child: CustomTextFormField(
        width: 190.h,
        controller: emailController,
        hintText: "yourname@exapmle.com",
        textInputAction: TextInputAction.done,
        alignment: AlignmentDirectional.bottomCenter,
        contentPadding: EdgeInsetsDirectional.fromSTEB(18.h, 6.h, 18.h, 2.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildRowemailaccount(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(
        start: 20.h,
        end: 26.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email account",
            style: theme.textTheme.bodyLarge,
          ),
          _buildEmail(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildStackbirthdate(BuildContext context) {
    return Container(
      height: 232.h,
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(start: 20.h),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.maxFinite,
                margin: EdgeInsetsDirectional.only(bottom: 68.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(bottom: 4.h),
                      child: Text(
                        "Birth Date",
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(end: 28.h),
                        child: Text(
                          "DD/MM/YY",
                          style: CustomTextStyles.bodyMediumWorkSans,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Align(
            alignment: AlignmentDirectional.topStart,
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                spacing: 26,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Role",
                          style: theme.textTheme.bodyLarge,
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgArrowdown,
                          height: 16.h,
                          width: 18.h,
                          alignment: AlignmentDirectional.bottomCenter,
                          margin: EdgeInsetsDirectional.only(end: 32.h),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Divider(
                      color: appTheme.black900,
                      endIndent: 22.h,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: IntrinsicWidth(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Gender",
                            style: theme.textTheme.bodyLarge,
                          ),
                          Align(
                            alignment: AlignmentDirectional.bottomCenter,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(start: 296.h),
                              child: Text(
                                "None",
                                style: CustomTextStyles
                                    .bodyMediumWorkSansBluegray70001Regular,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(start: 48.h),
                            child: Text(
                              "USA",
                              style: CustomTextStyles
                                  .bodyMediumPoppinsBluegray70001,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Container(
              width: double.maxFinite,
              margin: EdgeInsetsDirectional.only(end: 24.h),
              padding: EdgeInsetsDirectional.symmetric(vertical: 24.h),
              decoration: AppDecoration.fillBluegray10001,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 6.h),
                    child: Text(
                      "Admin",
                      style: CustomTextStyles.bodyMediumWorkSans,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.maxFinite,
                    child: Divider(
                      color: appTheme.black900,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 6.h),
                    child: Text(
                      "Client",
                      style: CustomTextStyles.bodyMediumWorkSans,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  SizedBox(
                    width: double.maxFinite,
                    child: Divider(
                      color: appTheme.black900,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 6.h),
                    child: Text(
                      "Coach",
                      style: CustomTextStyles.bodyMediumWorkSans,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildConfirm(BuildContext context) {
    return CustomElevatedButton(
      height: 38.h,
      width: 158.h,
      text: "Confirm",
      buttonStyle: CustomButtonStyles.fillPrimaryTL16,
      buttonTextStyle: CustomTextStyles.bodyLargeWhiteA700,
    );
  }
}
