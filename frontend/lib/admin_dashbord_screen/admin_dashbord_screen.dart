import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../authentication_screen/authentication_screen.dart';
import '../responsive_utils.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../widgets/gym_pro_logo.dart';
import 'generate_access_code_dialog.dart';

class AdminDashbordScreen extends StatelessWidget {
  const AdminDashbordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure padding is only used for padding, not width/height
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          // This is correct usage:
          padding: context.responsivePadding(vertical: 0.02),
          child: Column(
            children: [              
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: context.heightRatio(0.01)),
                  child: GymProLogo(
                    size: context.responsiveFontSize(30),
                  ),
                ),
              ),
              SizedBox(height: context.heightRatio(0.02)),
              Container(
                height: context.heightRatio(0.06),
                margin: EdgeInsetsDirectional.only(
                  end: context.widthRatio(0.1),
                ),
                decoration: BoxDecoration(
                  color: appTheme.deepOrange500,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    'Admin Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFontSize(18),
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.heightRatio(0.02)),
              _buildUserManagementSection(context),
              SizedBox(height: context.heightRatio(0.02)),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: context.widthRatio(0.03),
                  endIndent: context.widthRatio(0.05),
                ),
              ),
              SizedBox(height: context.heightRatio(0.02)),
              _buildNutritionManagementSection(context),
              SizedBox(height: context.heightRatio(0.02)),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: context.widthRatio(0.03),
                  endIndent: context.widthRatio(0.05),
                ),
              ),
              SizedBox(height: context.heightRatio(0.02)),              
              _buildCoursesManagementSection(context),
              SizedBox(height: context.heightRatio(0.02)),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: context.widthRatio(0.03),
                  endIndent: context.widthRatio(0.05),
                ),
              ),
              SizedBox(height: context.heightRatio(0.02)),
              _buildAccessCodeSection(context),              SizedBox(height: context.heightRatio(0.02)),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: context.widthRatio(0.03),
                  endIndent: context.widthRatio(0.05),
                ),
              ),              SizedBox(height: context.heightRatio(0.02)),
              _buildMembershipFixSection(context),
              SizedBox(height: context.heightRatio(0.02)),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: context.widthRatio(0.03),
                  endIndent: context.widthRatio(0.05),
                ),
              ),
              SizedBox(height: context.heightRatio(0.02)),
              _buildTenderManagementSection(context),
              SizedBox(height: context.heightRatio(0.02)),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: context.widthRatio(0.03),
                  endIndent: context.widthRatio(0.05),
                ),
              ),
              SizedBox(height: context.heightRatio(0.02)),
              _buildLogoutSection(context),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildUserManagementSection(BuildContext context) {
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.userManagmentScreen);
      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsetsDirectional.only(
          start: context.widthRatio(0.03),
          end: context.widthRatio(0.05),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "User Management",
                style: CustomTextStyles.bodyLargeBlack900_1,
              ),
            ),
            Container(
              height: context.heightRatio(0.04),
              width: context.widthRatio(0.2),
              decoration: AppDecoration.fillPrimary.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder12,
              ),
              child: Center(
                child: Icon(
                  Icons.people, // Using a people icon for user management
                  size: context.heightRatio(0.03),
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildNutritionManagementSection(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.supplementManagementScreen);
      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsetsDirectional.only(
          start: context.widthRatio(0.03),
          end: context.widthRatio(0.05),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Supplements Management",
                style: theme.textTheme.bodyLarge,
              ),
            ),
            Container(
              height: context.heightRatio(0.04),
              width: context.widthRatio(0.2),
              decoration: AppDecoration.fillPrimary.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder12,
              ),
              child: Center(
                child: Icon(
                  Icons.medication_outlined, // Using a pill/medicine icon for supplements
                  size: context.heightRatio(0.03),
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildCoursesManagementSection(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.courseManagementScreen);
      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsetsDirectional.only(
            start: context.widthRatio(0.03), end: context.widthRatio(0.05)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Courses Management",
                style: theme.textTheme.bodyLarge,
              ),
            ),
            Container(
              height: context.heightRatio(0.04),
              width: context.widthRatio(0.2),
              decoration: AppDecoration.fillPrimary.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder12,
              ),
              child: Center(
                child: Icon(
                  Icons.calendar_today, // Using a calendar icon for courses
                  size: context.heightRatio(0.03),
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAccessCodeSection(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        _showGenerateAccessCodeDialog(context);
      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsetsDirectional.only(
            start: context.widthRatio(0.03), end: context.widthRatio(0.05)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Generate Access Code",
                style: theme.textTheme.bodyLarge,
              ),
            ),
            Container(
              height: context.heightRatio(0.04),
              width: context.widthRatio(0.2),
              decoration: AppDecoration.fillPrimary.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder12,
              ),
              child: Center(
                child: Icon(
                  Icons.vpn_key, // Using a key icon for access codes
                  size: context.heightRatio(0.03),
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  void _showGenerateAccessCodeDialog(BuildContext context) {
    // Use our new dedicated dialog widget
    showDialog(
      context: context,
      builder: (context) => const GenerateAccessCodeDialog(),
    );
  }

  /// Section Widget for tender management
  Widget _buildTenderManagementSection(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.tenderManagementScreen);
      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsetsDirectional.only(
          start: context.widthRatio(0.03),
          end: context.widthRatio(0.05),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tender Management',
                    style: theme.textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Create and manage tenders for your gym',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Container(
              height: context.heightRatio(0.04),
              width: context.widthRatio(0.2),
              decoration: AppDecoration.fillPrimary.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder12,
              ),
              child: Center(
                child: Icon(
                  Icons.campaign_rounded, // Tender announcement icon
                  size: context.heightRatio(0.03),
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Section Widget for fixing membership issues
  Widget _buildMembershipFixSection(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.fixMembershipScreen);
      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsetsDirectional.only(
          start: context.widthRatio(0.03),
          end: context.widthRatio(0.05),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fix Membership Issues',
                    style: theme.textTheme.bodyLarge,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Troubleshoot and fix user membership problems',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: context.heightRatio(0.04),
              width: context.widthRatio(0.2),
              decoration: AppDecoration.fillPrimary.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder12,
              ),
              child: Center(
                child: Icon(
                  Icons.build_rounded, // Wrench/repair icon
                  size: context.heightRatio(0.03),
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildLogoutSection(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () async {
        try {
          // Show loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
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

          // Call logout method from AuthService
          await Provider.of<AuthService>(context, listen: false).logout();

          // Navigate to authentication screen
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => AuthenticationScreen(),
            ),
            (route) => false, // Remove all previous routes
          );
        } catch (e) {
          // Show error if logout fails
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logout failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsetsDirectional.only(
            start: context.widthRatio(0.03), end: context.widthRatio(0.05)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Logout",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: context.heightRatio(0.04),
              width: context.widthRatio(0.2),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadiusStyle.roundedBorder12,
              ),
              child: Center(
                child: Icon(
                  Icons.logout,
                  size: context.heightRatio(0.03),
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  // Button styling is now handled in the GenerateAccessCodeDialog class
}
