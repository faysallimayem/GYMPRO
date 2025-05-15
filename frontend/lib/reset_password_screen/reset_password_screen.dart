// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? token;

  const ResetPasswordScreen({super.key, this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _token;

  @override
  void initState() {
    super.initState();
    _token = widget.token;

    // If token was not passed directly, try to get it from the URL parameters
    if (_token == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // This would be replaced with actual URL parameter extraction logic
        // In a real deep linking implementation
        final uri = Uri.base;
        if (uri.queryParameters.containsKey('token')) {
          setState(() {
            _token = uri.queryParameters['token'];
          });
        } else {
          setState(() {
            _errorMessage =
                "No reset token found. Please request a new password reset link.";
          });
        }
      });
    }
  }

  void _resetPassword() async {
    // Validate inputs
    if (passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please enter a new password";
      });
      return;
    }

    if (passwordController.text.length < 6) {
      setState(() {
        _errorMessage = "Password must be at least 6 characters";
      });
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match";
      });
      return;
    }

    if (_token == null) {
      setState(() {
        _errorMessage = "Reset token is missing";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      await Provider.of<AuthService>(context, listen: false)
          .resetPassword(_token!, passwordController.text);

      setState(() {
        _successMessage = "Password updated successfully";
        _isLoading = false;

        // Clear inputs after success
        passwordController.clear();
        confirmPasswordController.clear();
      });

      // Navigate to login screen after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.authenticationScreen, (route) => false);
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().contains("Invalid or expired token")
            ? "This reset link has expired. Please request a new one."
            : "An error occurred. Please try again.";
        _isLoading = false;
      });
      print('Reset password error: $e'); // Debug - remove in production
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildResetPasswordHeading(context),
                SizedBox(height: 32.h),
                _buildPasswordFields(context),
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
                SizedBox(height: 32.h),
                Align(
                  alignment: Alignment.center,
                  child: CustomElevatedButton(
                    height: 60.h,
                    width: 300.h,
                    text: _isLoading ? "Updating..." : "Reset Password",
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
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build password field section
  Widget _buildPasswordFields(BuildContext context) {
    return Column(
      children: [
        // New Password Field
        Padding(
          padding: EdgeInsetsDirectional.only(end: 14.h),
          child: CustomTextFormField(
            controller: passwordController,
            hintText: "New Password",
            hintStyle: CustomTextStyles.titleMediumWorkSansOnPrimary,
            textInputAction: TextInputAction.next,
            obscureText: _obscurePassword,
            prefix: Container(
              padding: EdgeInsetsDirectional.all(6.h),
              margin: EdgeInsetsDirectional.only(end: 12.h),
              decoration: BoxDecoration(
                color: Color(0xFFFFF8F0),
                shape: BoxShape.circle,
              ),
              child: CustomImageView(
                imagePath: ImageConstant.imgEmail,
                height: 20.h,
                width: 20.h,
                color: theme.colorScheme.primary,
                fit: BoxFit.contain,
              ),
            ),
            prefixConstraints: BoxConstraints(maxHeight: 80.h),
            suffix: GestureDetector(
              onTap: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              child: Container(
                margin: EdgeInsetsDirectional.fromSTEB(16.h, 28.h, 20.h, 28.h),
                child: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: appTheme.gray400,
                  size: 24.h,
                ),
              ),
            ),
            suffixConstraints: BoxConstraints(maxHeight: 80.h),
            contentPadding:
                EdgeInsetsDirectional.fromSTEB(28.h, 28.h, 20.h, 28.h),
            borderDecoration: TextFormFieldStyleHelper.outlineGray,
            fillColor: appTheme.gray50,
          ),
        ),
        SizedBox(height: 16.h),
        // Confirm Password Field
        Padding(
          padding: EdgeInsetsDirectional.only(end: 14.h),
          child: CustomTextFormField(
            controller: confirmPasswordController,
            hintText: "Confirm New Password",
            hintStyle: CustomTextStyles.titleMediumWorkSansOnPrimary,
            textInputAction: TextInputAction.done,
            obscureText: _obscureConfirmPassword,
            prefix: Container(
              padding: EdgeInsetsDirectional.all(
                  6.h), // Reduced padding to create a distance
              margin: EdgeInsetsDirectional.only(
                  end: 12.h), // Increased margin for spacing
              decoration: BoxDecoration(
                color: Color(0xFFFFF8F0),
                shape: BoxShape.circle,
              ),
              child: CustomImageView(
                imagePath: ImageConstant.imgEmail,
                height: 20.h, // Adjusted size for better fit
                width: 20.h,
                color: theme.colorScheme.primary,
                fit: BoxFit.contain,
              ),
            ),
            prefixConstraints: BoxConstraints(maxHeight: 80.h),
            suffix: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
              child: Container(
                margin: EdgeInsetsDirectional.fromSTEB(16.h, 28.h, 20.h, 28.h),
                child: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: appTheme.gray400,
                  size: 24.h,
                ),
              ),
            ),
            suffixConstraints: BoxConstraints(maxHeight: 80.h),
            contentPadding:
                EdgeInsetsDirectional.fromSTEB(28.h, 28.h, 20.h, 28.h),
            borderDecoration: TextFormFieldStyleHelper.outlineGray,
            fillColor: appTheme.gray50,
          ),
        ),
      ],
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
  Widget _buildResetPasswordHeading(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reset Password",
            style: CustomTextStyles.headlineLargeOnPrimary,
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: 342.h,
            child: Text(
              "Enter your new password below to update your account.",
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
