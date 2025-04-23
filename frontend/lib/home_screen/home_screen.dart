import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../gym_classes_page/gym_classes_page.dart';
import '../routes/app_routes.dart';
import '../user_profile_page/user_profile_page.dart';
import '../widgets.dart';
import '../workouts_page/workouts_page.dart';

// ignore_for_file: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key})
      : super(
          key: key,
        );

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          decoration: AppDecoration.outlineOnPrimaryContainer,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Navigator(
                  key: navigatorKey,
                  initialRoute: AppRoutes.homeInitialPage,
                  onGenerateRoute: (routeSetting) => PageRouteBuilder(
                    pageBuilder: (ctx, ani, ani1) =>
                        getCurrentPage(routeSetting.name!),
                    transitionDuration: Duration(seconds: 0),
                  ),
                ),
              ),
              SizedBox(height: 10.h)
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.maxFinite,
        margin: EdgeInsetsDirectional.only(
          start: 10.h,
          end: 10.h,
          bottom: 10.h,
        ),
        child: _buildBottombar(context),
      ),
    );
  }

  /// Section Widget
  Widget _buildBottombar(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: CustomBottomBar(
        onChanged: (BottomBarEnum type) {
          Navigator.pushNamed(
              navigatorKey.currentContext!, getCurrentRoute(type));
        },
      ),
    );
  }

  ///Handling route based on bottom click actions
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        return AppRoutes.homeInitialPage;
      case BottomBarEnum.Maximize:
        return AppRoutes.workoutsPage;
      case BottomBarEnum.Medicaliconinutrition:
        return "/";
      case BottomBarEnum.Calendar:
        return AppRoutes.gymClassesPage;
      case BottomBarEnum.Lockgray600:
        return AppRoutes.userProfilePage;
      default:
        return "/";
    }
  }

  ///Handling page based on route
  Widget getCurrentPage(String currentRoute) {
    switch (currentRoute) {
      case AppRoutes.homeInitialPage:
        return HomeInitialPage();
      case AppRoutes.workoutsPage:
        return WorkoutsPage();
      case AppRoutes.gymClassesPage:
        return GymClassesPage();
      case AppRoutes.userProfilePage:
        return UserProfilePage();
      default:
        return DefaultWidget();
    }
  }
}

class HomeThreeItemWidget extends StatelessWidget {
  const HomeThreeItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 6.h,
        vertical: 8.h,
      ),
      decoration: AppDecoration.outline2.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      child: Column(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Your next workout:",
            style: CustomTextStyles.titleMediumTTCommonsPrimary,
          ),
          Text(
            "Push ups",
            style: CustomTextStyles.titleLargePoppins,
          ),
          Container(
            width: double.maxFinite,
            margin: EdgeInsetsDirectional.only(end: 12.h),
            child: Row(
              children: [
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Duration:",
                      style: CustomTextStyles.bodyMediumTTCommons,
                    ),
                    Text(
                      "30 minutes",
                      style: theme.textTheme.titleSmall,
                    )
                  ],
                ),
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reps:",
                      style: CustomTextStyles.bodyMediumTTCommons,
                    ),
                    Text(
                      "115",
                      style: theme.textTheme.titleSmall,
                    )
                  ],
                ),
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sets:",
                      style: CustomTextStyles.bodyMediumTTCommons,
                    ),
                    Text(
                      "15",
                      style: theme.textTheme.titleSmall,
                    )
                  ],
                ),
                Expanded(
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Exercise:",
                        style: CustomTextStyles.bodyMediumTTCommons,
                      ),
                      Text(
                        "5",
                        style: theme.textTheme.titleSmall,
                      )
                    ],
                  ),
                ),
                CustomOutlinedButton(
                  height: 30.h,
                  width: 90.h,
                  text: "Start workout",
                  buttonStyle: CustomButtonStyles.none,
                  decoration: CustomButtonStyles.outlineDecoration,
                  buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HomeFourItemWidget extends StatelessWidget {
  const HomeFourItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgEllipse10,
          height: 100.h,
          width: 100.h,
          radius: BorderRadius.circular(
            50.h,
          ),
        ),
        Text(
          "Sarah",
          style: CustomTextStyles.titleLargePoppins,
        )
      ],
    );
  }
}

class HomeInitialPage extends StatefulWidget {
  const HomeInitialPage({Key? key})
      : super(
          key: key,
        );

  @override
  HomeInitialPageState createState() => HomeInitialPageState();
}

class HomeInitialPageState extends State<HomeInitialPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsetsDirectional.only(
          start: 2.h,
          top: 18.h,
          end: 2.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(start: 8.h),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "GYM",
                      style: CustomTextStyles.headlineSmallPoppinsPrimary_1,
                    ),
                    TextSpan(
                      text: " PRO",
                      style: CustomTextStyles.headlineSmallPoppinsPrimary_1,
                    )
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 6.h),
            _buildRowgymproone(context),
            SizedBox(height: 20.h),
            _buildHomethree(context),
            SizedBox(height: 28.h),
            _buildRowcoachsone(context),
            SizedBox(height: 48.h)
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildRowgymproone(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 2.h),
      decoration: AppDecoration.outline1.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      width: double.maxFinite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: 6.h,
                top: 4.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "GYM PRO",
                    style: CustomTextStyles.titleMediumPoppinsPrimary,
                  ),
                  SizedBox(
                    width: 126.h,
                    child: Text(
                      "Welcome back, Nick!",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.titleLargeTTCommonsWhiteA700,
                    ),
                  )
                ],
              ),
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgRectangle37,
            height: 86.h,
            width: 74.h,
            alignment: AlignmentDirectional.bottomCenter,
            margin: EdgeInsetsDirectional.only(top: 26.h),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildHomethree(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 2.h),
      child: ListView.separated(
        padding: EdgeInsetsDirectional.zero,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 20.h,
          );
        },
        itemCount: 2,
        itemBuilder: (context, index) {
          return HomeThreeItemWidget();
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildRowcoachsone(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 2.h),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 14.h,
        vertical: 6.h,
      ),
      decoration: AppDecoration.outline3.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(bottom: 20.h),
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Coachs",
                    style: CustomTextStyles.titleLargePoppinsPrimary,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: 14.h,
                      end: 10.h,
                    ),
                    child: ResponsiveGridListBuilder(
                      minItemWidth: 1,
                      minItemsPerRow: 3,
                      maxItemsPerRow: 3,
                      horizontalGridSpacing: 28.h,
                      verticalGridSpacing: 28.h,
                      builder: (context, items) => ListView(
                        shrinkWrap: true,
                        padding: EdgeInsetsDirectional.zero,
                        physics: NeverScrollableScrollPhysics(),
                        children: items,
                      ),
                      gridItems: List.generate(
                        6,
                        (index) {
                          return HomeFourItemWidget();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(end: 4.h),
            child: VerticalDivider(
              width: 5.h,
              thickness: 5.h,
              color: theme.colorScheme.onPrimaryContainer,
              indent: 6.h,
            ),
          )
        ],
      ),
    );
  }
}
