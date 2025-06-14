import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart'; // Import UserService
import '../main.dart' show navigatorKey;
import '../widgets/gym_pro_logo.dart';

// ignore_for_file: must_be_immutable
class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      // Allow screen to resize when keyboard appears
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          // Make the content scrollable to prevent overflow
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsetsDirectional.only(
              start: 46.h,
              top: 40.h, // Reduced top padding
              end: 46.h,
              bottom: 20.h, // Added bottom padding
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Use min size to prevent overflow
              children: [                // Updated header section with logo widget and login text
                Column(
                  children: [                    GymProLogo(
                      size: 40.h,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "Login to your Account",
                      style: CustomTextStyles.bodyLargeBlack900_1,
                    ),
                  ],
                ),
                SizedBox(height: 50.h),
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
                        Navigator.pushNamed(
                            context, AppRoutes.forgotPasswordScreen);
                      },
                      child: Text(
                        "Forgot Password",
                        style: CustomTextStyles.titleSmallWorkSansPrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                if (_errorMessage != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 14.h),
                    ),
                  ),
                SizedBox(height: 10.h),
                CustomElevatedButton(
                  height: 46.h,
                  text: _isLoading ? "Logging in..." : "Log in",
                  margin: EdgeInsetsDirectional.only(
                    start: 8.h,
                    end: 2.h,
                  ),
                  buttonStyle: CustomButtonStyles.fillOrangeA,
                  buttonTextStyle:
                      CustomTextStyles.headlineSmallPoppinsWhiteA700,
                  onPressed: _isLoading ? null : _handleLogin,
                ),
                SizedBox(height: 18.h),
                CustomElevatedButton(
                  height: 46.h,
                  text: "Sign up ",
                  margin: EdgeInsetsDirectional.only(
                    start: 8.h,
                    end: 2.h,
                  ),
                  buttonStyle: CustomButtonStyles.fillOrangeA,
                  buttonTextStyle:
                      CustomTextStyles.headlineSmallPoppinsWhiteA700,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.signUpScreen);
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please enter both email and password";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Login with credentials
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.login(
          emailController.text.trim(), passwordController.text);

      // Add delay to ensure role is properly set
      await Future.delayed(const Duration(milliseconds: 500));

      // Use the global navigator key for consistent navigation
      if (authService.isAdmin) {
        // Cache the profile in UserService for later use
        try {
          final userService = UserService();
          if (authService.userData != null) {
            userService.cacheProfile(authService.userData!);
          }
        } catch (e) {
          print('Failed to cache profile in UserService: $e');
        }
        print('Navigating to admin dashboard using global navigator');

        // Use the global navigator key
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.adminDashbordScreen,
            (_) => false // Remove all previous routes
            );
      } else {
        print('Navigating to home screen using global navigator');

        // Use the global navigator key
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.homeScreen, (_) => false // Remove all previous routes
            );
      }
    } catch (e) {
      print('Login error caught: $e');
      setState(() {
        _errorMessage = e.toString().contains('ApiException')
            ? "Invalid email or password"
            : "Connection error. Please try again.";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
            suffix: GestureDetector(
              onTap: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              child: Container(
                margin: EdgeInsetsDirectional.fromSTEB(16.h, 14.h, 12.h, 14.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgEye,
                  height: 18.h,
                  width: 20.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            suffixConstraints: BoxConstraints(
              maxHeight: 48.h,
            ),
            obscureText: _obscurePassword,
            contentPadding: EdgeInsetsDirectional.all(12.h),
            borderDecoration: TextFormFieldStyleHelper.outlineBlueGray,
            fillColor: appTheme.whiteA700,
          )
        ],
      ),
    );
  }
}
