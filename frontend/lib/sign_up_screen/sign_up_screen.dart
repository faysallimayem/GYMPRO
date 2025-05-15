import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';
import '../services/registration_provider.dart';

// ignore_for_file: must_be_immutable
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController namesevenController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Error messages map
  Map<String, String?> errorMessages = {
    'firstName': null,
    'secondName': null,
    'email': null,
    'password': null,
    'confirmPassword': null,
  };

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 600 ? 24.h : 42.h;
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsetsDirectional.only(
                  start: horizontalPadding,
                  top: 24.h,
                  end: horizontalPadding,
                  bottom: 20.h, // Add bottom padding
                ),
                child: Column(
                  children: [
                    Text(
                      "GYM PRO",
                      style: theme.textTheme.displaySmall,
                    ),
                    Text(
                      "Create an Account",
                      style: CustomTextStyles.bodyLargeBlack900_1,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Help us finish setting up your account.",
                      style: CustomTextStyles.bodyLargeBlack900_1,
                    ),
                    SizedBox(height: 24.h),
                    _buildFirstNameInput(context),
                    SizedBox(height: 2.h),
                    _buildSecondNameInput(context),
                    SizedBox(height: 16.h),
                    _buildEmailInput(context),
                    SizedBox(height: 14.h),
                    _buildPasswordInput(context),
                    SizedBox(height: 12.h),
                    _buildConfirmPasswordInput(context),
                    SizedBox(height: 20.h),
                    if (_errorMessage != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 14.h),
                        ),
                      ),
                    SizedBox(height: 16.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRoutes.authenticationScreen);
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "I already have ",
                              style: CustomTextStyles
                                  .bodyMediumWorkSansBluegray700,
                            ),
                            TextSpan(
                              text: "an account",
                              style: CustomTextStyles
                                  .titleSmallWorkSansPrimaryBold
                                  .copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            )
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 26.h),
                    CustomElevatedButton(
                      height: 46.h,
                      width: 216.h,
                      text: _isLoading ? "Creating account..." : "Continue",
                      buttonStyle: CustomButtonStyles.fillOrangeA,
                      buttonTextStyle:
                          CustomTextStyles.headlineSmallPoppinsWhiteA700,
                      onPressed: _isLoading ? null : _handleSignUp,
                    ),
                    SizedBox(height: 34.h)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignUp() async {
    if (!_validateForm()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Store user data in registration provider
      final registrationProvider =
          Provider.of<RegistrationProvider>(context, listen: false);
      registrationProvider.setBasicInfo(
        lastName: firstNameController.text.trim(),
        firstName: namesevenController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Navigate to gender screen to continue registration flow
      if (mounted) {
        Navigator.pushNamed(context, AppRoutes.genderScreen);
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred. Please try again.";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _validateForm() {
    bool isValid = true;

    // Validate First Name
    if (firstNameController.text.trim().isEmpty) {
      setState(() {
        errorMessages['firstName'] = 'First name is required';
      });
      isValid = false;
    } else {
      setState(() {
        errorMessages['firstName'] = null;
      });
    }

    // Validate Second Name
    if (namesevenController.text.trim().isEmpty) {
      setState(() {
        errorMessages['secondName'] = 'Second name is required';
      });
      isValid = false;
    } else {
      setState(() {
        errorMessages['secondName'] = null;
      });
    }

    // Validate Email
    if (emailController.text.trim().isEmpty) {
      setState(() {
        errorMessages['email'] = 'Email is required';
      });
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text)) {
      setState(() {
        errorMessages['email'] = 'Please enter a valid email address';
      });
      isValid = false;
    } else {
      setState(() {
        errorMessages['email'] = null;
      });
    }

    // Validate Password
    if (passwordController.text.isEmpty) {
      setState(() {
        errorMessages['password'] = 'Password is required';
      });
      isValid = false;
    } else if (passwordController.text.length < 6) {
      setState(() {
        errorMessages['password'] = 'Password must be at least 6 characters';
      });
      isValid = false;
    } else {
      setState(() {
        errorMessages['password'] = null;
      });
    }

    // Validate Confirm Password
    if (confirmpasswordController.text.isEmpty) {
      setState(() {
        errorMessages['confirmPassword'] = 'Confirm password is required';
      });
      isValid = false;
    } else if (passwordController.text != confirmpasswordController.text) {
      setState(() {
        errorMessages['confirmPassword'] = 'Passwords do not match';
      });
      isValid = false;
    } else {
      setState(() {
        errorMessages['confirmPassword'] = null;
      });
    }

    return isValid;
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
  Widget _buildFirstNameInput(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(end: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "First name",
            style: CustomTextStyles.titleSmallWorkSansOnPrimary,
          ),
          SizedBox(height: 8.h),
          CustomTextFormField(
            controller: firstNameController,
            hintText: "Enter your first name..",
            prefix: Container(
              margin: EdgeInsetsDirectional.fromSTEB(12.h, 14.h, 8.h, 14.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgFissuser,
                height: 18.h,
                width: 16.h,
                fit: BoxFit.contain,
              ),
            ),
            prefixConstraints: BoxConstraints(
              maxHeight: 48.h,
            ),
            contentPadding: EdgeInsetsDirectional.all(12.h),
            borderDecoration: TextFormFieldStyleHelper.outlineBlueGray,
            fillColor: appTheme.whiteA700,
          ),
          if (errorMessages['firstName'] != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                errorMessages['firstName']!,
                style: TextStyle(color: Colors.red, fontSize: 16.h),
              ),
            ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSecondNameInput(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(end: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Second name",
            style: CustomTextStyles.titleSmallWorkSansOnPrimary,
          ),
          SizedBox(height: 8.h),
          CustomTextFormField(
            controller: namesevenController,
            hintText: "Enter your second name..",
            prefix: Container(
              margin: EdgeInsetsDirectional.fromSTEB(12.h, 14.h, 8.h, 14.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgFissuser,
                height: 18.h,
                width: 16.h,
                fit: BoxFit.contain,
              ),
            ),
            prefixConstraints: BoxConstraints(
              maxHeight: 48.h,
            ),
            contentPadding: EdgeInsetsDirectional.all(12.h),
            borderDecoration: TextFormFieldStyleHelper.outlineBlueGray,
            fillColor: appTheme.whiteA700,
          ),
          if (errorMessages['secondName'] != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                errorMessages['secondName']!,
                style: TextStyle(color: Colors.red, fontSize: 12.h),
              ),
            ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildEmailInput(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(end: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email Address",
            style: CustomTextStyles.titleSmallWorkSansOnPrimary,
          ),
          SizedBox(height: 8.h),
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
          ),
          if (errorMessages['email'] != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                errorMessages['email']!,
                style: TextStyle(color: Colors.red, fontSize: 12.h),
              ),
            ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPasswordInput(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(end: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Password",
            style: CustomTextStyles.titleSmallWorkSansOnPrimary,
          ),
          SizedBox(height: 8.h),
          CustomTextFormField(
            controller: passwordController,
            hintText: "*****************",
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
          ),
          if (errorMessages['password'] != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                errorMessages['password']!,
                style: TextStyle(color: Colors.red, fontSize: 12.h),
              ),
            ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildConfirmPasswordInput(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(end: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Confirm password",
            style: CustomTextStyles.titleSmallWorkSansOnPrimary,
          ),
          SizedBox(height: 6.h),
          CustomTextFormField(
            controller: confirmpasswordController,
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
                  _obscureConfirmPassword = !_obscureConfirmPassword;
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
            obscureText: _obscureConfirmPassword,
            contentPadding: EdgeInsetsDirectional.all(12.h),
            borderDecoration: TextFormFieldStyleHelper.outlineBlueGray,
            fillColor: appTheme.whiteA700,
          ),
          if (errorMessages['confirmPassword'] != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                errorMessages['confirmPassword']!,
                style: TextStyle(color: Colors.red, fontSize: 12.h),
              ),
            ),
        ],
      ),
    );
  }
}
