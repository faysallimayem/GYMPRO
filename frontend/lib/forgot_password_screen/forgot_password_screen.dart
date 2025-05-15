import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../widgets.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';

// ignore_for_file: must_be_immutable
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  void _resetPassword() async {
    if (emailController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = "Please enter your email";
        _successMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      // Get the success message from the API
      final message = await Provider.of<AuthService>(context, listen: false)
          .requestPasswordReset(emailController.text.trim());

      setState(() {
        _successMessage = message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred. Please try again later.";
        _isLoading = false;
      });
      print('Reset password error: $e'); // Debug - remove in production
    }
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildForgotPasswordHeading(context),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 28.h, end: 14.h),
                child: CustomTextFormField(
                  controller: emailController,
                  hintText: "Enter your email",
                  hintStyle: CustomTextStyles.titleMediumWorkSansOnPrimary,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.emailAddress,
                  prefix: Container(
                    padding: EdgeInsetsDirectional.all(12.h),
                    margin: EdgeInsetsDirectional.only(end: 12.h),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF8F0),
                      shape: BoxShape.circle,
                    ),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgEmail,
                      height: 24.h,
                      width: 24.h,
                      color: theme.colorScheme.primary,
                      fit: BoxFit.contain,
                    ),
                  ),
                  prefixConstraints: BoxConstraints(
                    maxHeight: 48.h,
                  ),
                  contentPadding:
                      EdgeInsetsDirectional.fromSTEB(28.h, 28.h, 20.h, 28.h),
                  borderDecoration: TextFormFieldStyleHelper.outlineGray,
                  fillColor: appTheme.gray50,
                ),
              ),
              SizedBox(height: 16.h),
              if (_errorMessage != null)
                Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: 24.h, end: 24.h, top: 8.h),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.h,
                    ),
                  ),
                ),
              if (_successMessage != null)
                Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: 24.h, end: 24.h, top: 8.h),
                  child: Text(
                    _successMessage!,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14.h,
                    ),
                  ),
                ),
              SizedBox(height: 24.h),
              Align(
                alignment: Alignment.center,
                child: CustomElevatedButton(
                  height: 60.h,
                  width: 300.h,
                  text: _isLoading ? "Sending..." : "Send Reset Link",
                  buttonTextStyle: TextStyle(
                    fontSize: 18.h,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: CustomTextStyles
                        .headlineSmallPoppinsWhiteA700.fontFamily,
                  ),
                  onPressed: _isLoading ? null : _resetPassword,
                ),
              ),
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
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildForgotPasswordHeading(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Forgot Password",
            style: CustomTextStyles.headlineLargeOnPrimary,
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: 342.h,
            child: Text(
              "Enter your email address and we'll send you a link to reset your password.",
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
