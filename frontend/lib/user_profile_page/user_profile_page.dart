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
import '../services/navigation_provider.dart';
import '../config.dart';
import '../edit_user_profile_screen/edit_user_profile_screen.dart';
import '../widgets/membership_status_widget.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Refresh user data when the profile page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).syncWithAuthService();
    });
    
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
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.editUserProfileScreen);
                  },
                  child: Container(
                    height: 150.h,
                    width: 150.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: userProvider.photoUrl != null && userProvider.photoUrl!.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                            userProvider.photoUrl!.startsWith('http')
                              ? userProvider.photoUrl!
                              : '${AppConfig.apiUrl}${userProvider.photoUrl!.startsWith('/') ? '' : '/'}${userProvider.photoUrl!}',
                          ),
                        )
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 74.h,
                              backgroundColor: appTheme.deepOrange500.withOpacity(0.1),
                              child: Icon(
                                Icons.person,
                                size: 80.h,
                                color: appTheme.deepOrange500,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(8.h),
                                decoration: BoxDecoration(
                                  color: appTheme.deepOrange500,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  userProvider.username,
                  style: CustomTextStyles.headlineSmallSignika,
                ),                SizedBox(height: 22.h),
                // Add membership status widget
                MembershipStatusWidget(
                  user: userProvider.toUserModel(),
                  onRefresh: () {
                    userProvider.syncWithAuthService();
                  },
                ),
                SizedBox(height: 18.h),
                _buildUserInfoSection(userProvider),
                SizedBox(height: 18.h),
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
    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    
    return GestureDetector(
      onTap: () {
        // Use navigation provider for direct navigation to edit profile
        navigationProvider.navigateDirectly(
          context,
          EditUserProfileScreen(),
          AppRoutes.editUserProfileScreen
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
    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    
    return GestureDetector(
      onTap: () {
        // Use navigation provider for direct navigation
        navigationProvider.navigateDirectly(
          context,
          FavoriteExercisesScreen(),
          AppRoutes.favoriteExercisesScreen
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

  Widget _buildUserInfoSection(UserProvider userProvider) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 8.h),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 16.h,
        vertical: 16.h,
      ),
      decoration: AppDecoration.gray5.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Personal Information",
            style: CustomTextStyles.titleMediumWorkSansOnPrimary,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.cake,
                  label: "Age",
                  value: userProvider.age?.toString() ?? "Not set",
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: _buildInfoItem(
                  icon: userProvider.gender == 'Male' ? Icons.male : Icons.female,
                  label: "Gender",
                  value: userProvider.gender ?? "Not set",
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.height,
                  label: "Height",
                  value: userProvider.height != null ? "${userProvider.height!.toInt()} cm" : "Not set",
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.fitness_center,
                  label: "Weight",
                  value: userProvider.weight != null ? "${userProvider.weight!.toInt()} kg" : "Not set",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.h),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: appTheme.deepOrange500,
            size: 20.h,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: CustomTextStyles.bodySmallWorkSans.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: CustomTextStyles.bodyMediumWorkSans.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
