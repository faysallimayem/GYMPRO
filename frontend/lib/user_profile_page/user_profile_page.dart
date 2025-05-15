import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../widgets.dart';
import '../services/auth_service.dart';
import '../services/user_provider.dart';
import '../routes/app_routes.dart';
import '../favorite_exercises_screen/favorite_exercises_screen.dart';
import '../authentication_screen/authentication_screen.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final responsivePadding = screenWidth < 600 ? 14.h : 24.h;

    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding:
                EdgeInsetsDirectional.symmetric(horizontal: responsivePadding),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Profile",
                  style: CustomTextStyles.headlineSmallPoppins,
                ),
                SizedBox(height: 8.h),
                CustomIconButton(
                  height: 150.h,
                  width: 150.h,
                  padding: EdgeInsetsDirectional.all(54.h),
                  decoration: IconButtonStyleHelper.fillOnPrimaryContainerTL74,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgCameraBlack900,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  userProvider.username,
                  style: CustomTextStyles.headlineSmallSignika,
                ),
                SizedBox(height: 22.h),
                _buildEditProfileRow(context),
                SizedBox(height: 18.h),
                _buildFavoriteExercisesRow(context),
                SizedBox(height: 18.h),
                _buildSettingsRow(context),
                SizedBox(height: 18.h),
                _buildLogoutRow(context),
                SizedBox(height: 24.h), // Added bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditProfileRow(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to Edit Profile Screen
        Navigator.pushNamed(context, AppRoutes.editUserProfileScreen);
      },
      child: Container(
        margin: EdgeInsetsDirectional.only(start: 8.h),
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 8.h,
          vertical: 14.h,
        ),
        decoration: AppDecoration.gray5.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder20,
        ),
        width: double.maxFinite,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsetsDirectional.only(start: 6.h),
                child: Row(
                  children: [
                    CustomIconButton(
                      height: 48.h,
                      width: 48.h,
                      padding: EdgeInsetsDirectional.all(10.h),
                      decoration: IconButtonStyleHelper.fillOrange,
                      child: CustomImageView(
                        imagePath: ImageConstant.imgProfile,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 12.h),
                      child: Text(
                        "Edit Profile",
                        style: CustomTextStyles.titleMediumWorkSansOnPrimary,
                      ),
                    )
                  ],
                ),
              ),
            ),
            CustomImageView(
              imagePath: ImageConstant.imgArrowRight,
              height: 24.h,
              width: 24.h,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteExercisesRow(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to Favorite Exercises Screen using MaterialPageRoute instead of named route
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FavoriteExercisesScreen(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsetsDirectional.only(start: 8.h),
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 8.h,
          vertical: 14.h,
        ),
        decoration: AppDecoration.gray5.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder20,
        ),
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(start: 6.h),
              child: CustomIconButton(
                height: 48.h,
                width: 48.h,
                padding: EdgeInsetsDirectional.all(10.h),
                decoration: IconButtonStyleHelper.fillOrange,
                child: Icon(
                  Icons.favorite,
                  color: theme.colorScheme.primary,
                  size: 26.h,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 12.h),
              child: Text(
                "Favorite Exercises",
                style: CustomTextStyles.titleMediumWorkSansOnPrimary,
              ),
            ),
            Spacer(),
            CustomImageView(
              imagePath: ImageConstant.imgArrowRight,
              height: 24.h,
              width: 26.h,
            )
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildSettingsRow(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsetsDirectional.only(start: 8.h),
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 8.h,
          vertical: 14.h,
        ),
        decoration: AppDecoration.gray5.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder20,
        ),
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(start: 6.h),
              child: CustomIconButton(
                height: 48.h,
                width: 48.h,
                padding: EdgeInsetsDirectional.all(10.h),
                decoration: IconButtonStyleHelper.fillOrange,
                child: CustomImageView(
                  imagePath: ImageConstant.imgSearch,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 12.h),
              child: Text(
                "Settings",
                style: CustomTextStyles.titleMediumWorkSansOnPrimary,
              ),
            ),
            Spacer(),
            CustomImageView(
              imagePath: ImageConstant.imgArrowRight,
              height: 24.h,
              width: 26.h,
            )
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildLogoutRow(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Show loading indicator
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(width: 16),
                Text('Logging out...')
              ],
            ),
            duration: Duration(seconds: 1),
          ),
        );

        try {
          // Call logout method from AuthService
          await Provider.of<AuthService>(context, listen: false).logout();

          // Navigate to authentication screen using MaterialPageRoute
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => AuthenticationScreen(),
            ),
            (route) => false, // Remove all previous routes
          );
        } catch (e) {
          // Show error if logout fails
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Logout failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsetsDirectional.only(start: 8.h),
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 8.h,
          vertical: 14.h,
        ),
        decoration: AppDecoration.gray5.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder20,
        ),
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(start: 6.h),
              child: CustomIconButton(
                height: 48.h,
                width: 48.h,
                padding: EdgeInsetsDirectional.all(10.h),
                decoration: IconButtonStyleHelper.fillOrange,
                child: CustomImageView(
                  imagePath: ImageConstant.imgLogout,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 12.h),
              child: Text(
                "Log out",
                style: CustomTextStyles.titleMediumWorkSansOnPrimary,
              ),
            ),
            Spacer(),
            CustomImageView(
              imagePath: ImageConstant.imgArrowRight,
              height: 24.h,
              width: 26.h,
              alignment: AlignmentDirectional.topCenter,
              margin: EdgeInsetsDirectional.only(top: 10.h),
            )
          ],
        ),
      ),
    );
  }
}
