import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';

class AppNavigationScreen extends StatelessWidget {
  const AppNavigationScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFFFFF),
      body: SafeArea(
        child: SizedBox(
          width: 375.h,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0XFFFFFFFF),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.symmetric(horizontal: 20.h),
                      child: Text(
                        "App Navigation",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0XFF000000),
                          fontSize: 20.fSize,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 20.h),
                      child: Text(
                        "Check your app's UI from the below demo screens of your app.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0XFF888888),
                          fontSize: 16.fSize,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Divider(
                      height: 1.h,
                      thickness: 1.h,
                      color: Color(0XFF000000),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFFFFFFF),
                    ),
                    child: Column(
                      children: [
                        _buildScreenTitle(
                          context,
                          screenTitle: "Get started",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.getStartedScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Authentication",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.authenticationScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Sign up",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(context, AppRoutes.signUpScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Forgot password",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.forgotPasswordScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: " Gender",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(context, AppRoutes.genderScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Age",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(context, AppRoutes.ageScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Weight",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(context, AppRoutes.weightScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Height",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(context, AppRoutes.heightScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Home",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(context, AppRoutes.homeScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Admin Dashbord",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.adminDashbordScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "User Managment",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.userManagmentScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Add User",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.addUserScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Edit user",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.editUserScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Edit user-One",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.editUserOneScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Nutrition Management",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.nutritionManagementScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Add Nutrition ",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.addNutritionScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Edit Nutrition",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.editNutritionScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Exercice Managment",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.exerciceManagmentScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Add Exercise",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.addExerciseScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Add Exercise One",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.addExerciseOneScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Chat",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(context, AppRoutes.chatScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Workout Details",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.workoutDetailsScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Exercice explication",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.exerciceExplicationScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Coach Profile",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.coachProfileScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Edit User Profile",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.editUserProfileScreen),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Common widget
  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
    Function? onTapScreenTitle,
  }) {
    return GestureDetector(
      onTap: () {
        onTapScreenTitle?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF),
        ),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 20.h),
              child: Text(
                screenTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF000000),
                  fontSize: 20.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(height: 5.h),
            Divider(
              height: 1.h,
              thickness: 1.h,
              color: Color(0XFF888888),
            )
          ],
        ),
      ),
    );
  }

  /// Common click event
  void onTapScreenTitle(
    BuildContext context,
    String routeName,
  ) {
    Navigator.pushNamed(context, routeName);
  }
}
