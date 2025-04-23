import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';

// ignore_for_file: must_be_immutable
class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key})
      : super(
          key: key,
        );

  TextEditingController emailController = TextEditingController();

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
          padding: EdgeInsetsDirectional.only(
            start: 12.h,
            top: 18.h,
            end: 12.h,
          ),
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildForgotPasswordHeading(context),
              Padding(
                padding: EdgeInsetsDirectional.only(end: 14.h),
                child: CustomTextFormField(
                  controller: emailController,
                  hintText: "Send via Email",
                  hintStyle: CustomTextStyles.titleMediumWorkSansOnPrimary,
                  textInputAction: TextInputAction.done,
                  prefix: Container(
                    padding: EdgeInsetsDirectional.all(12.h),
                    margin:
                        EdgeInsetsDirectional.fromSTEB(28.h, 28.h, 24.h, 28.h),
                    decoration: BoxDecoration(
                      color: appTheme.orange50,
                      borderRadius: BorderRadius.circular(
                        24.h,
                      ),
                    ),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgLockPrimary,
                      height: 24.h,
                      width: 24.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  prefixConstraints: BoxConstraints(
                    maxHeight: 80.h,
                  ),
                  suffix: Container(
                    margin:
                        EdgeInsetsDirectional.fromSTEB(16.h, 28.h, 20.h, 28.h),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgArrowleft,
                      height: 24.h,
                      width: 24.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  suffixConstraints: BoxConstraints(
                    maxHeight: 80.h,
                  ),
                  contentPadding:
                      EdgeInsetsDirectional.fromSTEB(28.h, 28.h, 20.h, 28.h),
                  borderDecoration: TextFormFieldStyleHelper.outlineGray,
                  fillColor: appTheme.gray50,
                ),
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
      title: AppbarSubtitleOne(
        text: "←",
        margin: EdgeInsetsDirectional.only(start: 12.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildForgotPasswordHeading(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 16.h),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Forgot Password",
            style: CustomTextStyles.headlineLargeOnPrimary,
          ),
          SizedBox(
            width: 342.h,
            child: Text(
              "Please select the following options to reset your password.",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.bodyLargeBluegray700.copyWith(
                height: 1.60,
              ),
            ),
          )
        ],
      ),
    );
  }
}
