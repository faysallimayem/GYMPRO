import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart'; // ignore_for_file: must_be_immutable

class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsetsDirectional.only(top: 12.h),
              child: Column(
                spacing: 14,
                children: [
                  _buildHeaderSection(context),
                  _buildWorkoutsGrid(context),
                  _buildCoachesSection(context),
                  _buildWeeklyProgressSection(context),
                  SizedBox(height: 18.h)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(
        start: 10.h,
        end: 6.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsetsDirectional.symmetric(horizontal: 10.h),
                    decoration: AppDecoration.fillGray.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.maxFinite,
                          padding: EdgeInsetsDirectional.only(start: 12.h),
                          decoration: AppDecoration.outline4.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder8,
                          ),
                          child: Column(
                            spacing: 4,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "GYM PRO",
                                style: CustomTextStyles.headlineSmallPrimary,
                              ),
                              SizedBox(
                                width: 148.h,
                                child: Text(
                                  "Welcome back, Nick!",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: CustomTextStyles
                                      .titleLargeInterWhiteA700SemiBold,
                                ),
                              ),
                              SizedBox(height: 40.h)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 26.h),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 10.h),
                    child: Text(
                      "Today’s Workouts",
                      style: CustomTextStyles.headlineSmallWorkSansSemiBold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ListView.separated(
                    padding: EdgeInsetsDirectional.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 18.h,
                      );
                    },
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return ListpushUpsItemWidget();
                    },
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 10.h),
                    child: Text(
                      "Workout Programs",
                      style: CustomTextStyles.headlineSmallWorkSansSemiBold,
                    ),
                  )
                ],
              ),
            ),
          ),
          VerticalDivider(
            width: 5.h,
            thickness: 5.h,
            color: theme.colorScheme.onPrimaryContainer,
            indent: 132.h,
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildWorkoutsGrid(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 10.h,
        end: 16.h,
      ),
      child: ResponsiveGridListBuilder(
        minItemWidth: 1,
        minItemsPerRow: 2,
        maxItemsPerRow: 2,
        horizontalGridSpacing: 6.h,
        verticalGridSpacing: 6.h,
        builder: (context, items) => ListView(
          shrinkWrap: true,
          padding: EdgeInsetsDirectional.zero,
          physics: NeverScrollableScrollPhysics(),
          children: items,
        ),
        gridItems: List.generate(
          4,
          (index) {
            return WorkoutsgridItemWidget();
          },
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildCoachesSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(start: 20.h),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(start: 4.h),
            child: Text(
              "Coaches",
              style: CustomTextStyles.headlineSmallPrimary,
            ),
          ),
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 14.h,
                children: List.generate(
                  5,
                  (index) {
                    return ListsarahOneItemWidget();
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildWeeklyProgressSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 10.h),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 4.h),
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(start: 4.h),
            child: Text(
              "Weekly Progress",
              style: CustomTextStyles.headlineSmallWorkSansSemiBold,
            ),
          ),
          Container(
            height: 270.h,
            width: 400.h,
            margin: EdgeInsetsDirectional.only(start: 8.h),
            decoration: BoxDecoration(
              color: appTheme.blueGray50,
              borderRadius: BorderRadius.circular(
                16.h,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ListpushUpsItemWidget extends StatelessWidget {
  const ListpushUpsItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 172.h,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgClock,
            height: 6.h,
            width: 8.h,
            alignment: AlignmentDirectional.bottomStart,
            margin: EdgeInsetsDirectional.only(
              start: 44.h,
              bottom: 56.h,
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 6.h,
              vertical: 8.h,
            ),
            decoration: AppDecoration.outline2.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your next workout:",
                  style: CustomTextStyles.bodyLargeInterPrimary,
                ),
                SizedBox(height: 4.h),
                Text(
                  "Push ups",
                  style: CustomTextStyles.titleLargeInterMedium,
                ),
                SizedBox(height: 6.h),
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsetsDirectional.only(
                    start: 8.h,
                    end: 26.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Duration:",
                              style: CustomTextStyles.titleSmallInter,
                            ),
                            Text(
                              "30 minutes",
                              style: CustomTextStyles.bodyMediumRegular,
                            )
                          ],
                        ),
                      ),
                      Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Reps:",
                            style: CustomTextStyles.titleSmallInter,
                          ),
                          Text(
                            "115",
                            style: CustomTextStyles.bodyMediumRegular,
                          )
                        ],
                      ),
                      Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sets:",
                            style: CustomTextStyles.titleSmallInter,
                          ),
                          Text(
                            "15",
                            style: CustomTextStyles.bodyMediumRegular,
                          )
                        ],
                      ),
                      Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Exercise:",
                            style: CustomTextStyles.titleSmallInter,
                          ),
                          Text(
                            "5",
                            style: CustomTextStyles.bodyMediumRegular,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                CustomOutlinedButton(
                  height: 40.h,
                  text: "Start workout",
                  margin: EdgeInsetsDirectional.only(
                    start: 12.h,
                    end: 14.h,
                  ),
                  buttonStyle: CustomButtonStyles.none,
                  decoration: CustomButtonStyles.outlineTL8Decoration,
                  buttonTextStyle: CustomTextStyles.headlineSmallWhiteA700,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class WorkoutsgridItemWidget extends StatelessWidget {
  const WorkoutsgridItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsetsDirectional.all(14.h),
      decoration: AppDecoration.fillBlueGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 4.h),
          CustomImageView(
            imagePath: ImageConstant.imgRectangle188,
            height: 138.h,
            width: double.maxFinite,
            radius: BorderRadius.circular(
              16.h,
            ),
            margin: EdgeInsetsDirectional.only(end: 8.h),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 4.h),
            child: Text(
              "Chest & Arms",
              style: CustomTextStyles.titleLargeInterBluegray70001,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 6.h),
            child: Text(
              "12 exercises • 45 min",
              style: CustomTextStyles.labelMediumInterBluegray70001,
            ),
          )
        ],
      ),
    );
  }
}

class ListsarahOneItemWidget extends StatelessWidget {
  const ListsarahOneItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgRectangle195,
          height: 80.h,
          width: 80.h,
          radius: BorderRadius.circular(
            40.h,
          ),
        ),
        Text(
          "Sarah",
          overflow: TextOverflow.ellipsis,
          style: CustomTextStyles.titleSmallInterBluegray70001,
        )
      ],
    );
  }
}
