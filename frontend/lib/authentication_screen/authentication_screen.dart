import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';

// ignore_for_file: must_be_immutable
class AuthenticationScreen extends StatelessWidget {
  AuthenticationScreen({Key? key})
      : super(
          key: key,
        );

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsetsDirectional.only(
            start: 46.h,
            top: 80.h,
            end: 46.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 72.h,
                width: 172.h,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(start: 2.h),
                        child: Text(
                          "GYM PRO",
                          style: theme.textTheme.displaySmall,
                        ),
                      ),
                    ),
                    Text(
                      "Login to your Account",
                      style: CustomTextStyles.bodyLargeBlack900_1,
                    )
                  ],
                ),
              ),
              SizedBox(height: 72.h),
              _buildEmailInputSection(context),
              SizedBox(height: 24.h),
              _buildPasswordInputSection(context),
              SizedBox(height: 26.h),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: 4.h),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.forgotPasswordScreen);
                    },
                    child: Text(
                      "Forgot Password",
                      style: CustomTextStyles.titleSmallWorkSansPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 46.h),
              CustomElevatedButton(
                height: 46.h,
                text: "Log in",
                margin: EdgeInsetsDirectional.only(
                  start: 8.h,
                  end: 2.h,
                ),
                buttonTextStyle: CustomTextStyles.headlineSmallPoppinsWhiteA700,
              ),
              SizedBox(height: 18.h),
              CustomElevatedButton(
                height: 46.h,
                text: "Sign up ",
                margin: EdgeInsetsDirectional.only(
                  start: 8.h,
                  end: 2.h,
                ),
                buttonTextStyle: CustomTextStyles.headlineSmallPoppinsWhiteA700,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.signUpScreen);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildEmailInputSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(start: 4.h),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email Address",
            style: CustomTextStyles.titleSmallWorkSansOnPrimary,
          ),
          CustomTextFormField(
            controller: emailController,
            hintText: "Enter your email address...",
            prefix: Container(
              margin: EdgeInsetsDirectional.fromSTEB(12.h, 14.h, 8.h, 14.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgLock,
                height: 18.h,
                width: 20.h,
                fit: BoxFit.contain,
              ),
            ),
            prefixConstraints: BoxConstraints(
              maxHeight: 48.h,
            ),
            contentPadding: EdgeInsetsDirectional.all(12.h),
            borderDecoration: TextFormFieldStyleHelper.outlineBlueGray,
            fillColor: appTheme.whiteA700,
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPasswordInputSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(start: 4.h),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Password",
            style: CustomTextStyles.titleSmallWorkSansOnPrimary,
          ),
          CustomTextFormField(
            controller: passwordController,
            hintText: "*****************",
            textInputAction: TextInputAction.done,
            prefix: Container(
              margin: EdgeInsetsDirectional.fromSTEB(12.h, 14.h, 8.h, 14.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgBag,
                height: 18.h,
                width: 20.h,
                fit: BoxFit.contain,
              ),
            ),
            prefixConstraints: BoxConstraints(
              maxHeight: 48.h,
            ),
            suffix: Container(
              margin: EdgeInsetsDirectional.fromSTEB(16.h, 14.h, 12.h, 14.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgEye,
                height: 18.h,
                width: 20.h,
                fit: BoxFit.contain,
              ),
            ),
            suffixConstraints: BoxConstraints(
              maxHeight: 48.h,
            ),
            obscureText: true,
            contentPadding: EdgeInsetsDirectional.all(12.h),
            borderDecoration: TextFormFieldStyleHelper.outlineBlueGray,
            fillColor: appTheme.whiteA700,
          )
        ],
      ),
    );
  }
}
