import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';

class WorkoutDetailsScreen extends StatelessWidget {
  const WorkoutDetailsScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsetsDirectional.only(
                start: 8.h,
                top: 16.h,
                end: 8.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgRectangle211,
                    height: 250.h,
                    width: double.maxFinite,
                    radius: BorderRadius.circular(
                      12.h,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  _buildExerciseSummary(context),
                  SizedBox(height: 18.h),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 20.h),
                    child: Text(
                      "Exercises",
                      style: CustomTextStyles.titleLargeInter,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  _buildExerciseList(context),
                  SizedBox(height: 12.h)
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildStartWorkoutButton(context),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 46.h,
      title: Padding(
        padding: EdgeInsetsDirectional.only(start: 16.h),
        child: Row(
          children: [
            AppbarSubtitleOne(
              text: "←",
            ),
            AppbarSubtitle(
              text: "Chest & Arms",
              margin: EdgeInsetsDirectional.only(start: 101.h),
            )
          ],
        ),
      ),
      styleType: Style.bgOutlineGray100,
    );
  }

  /// Section Widget
  Widget _buildExerciseSummary(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(end: 2.h),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 2.h),
      width: double.maxFinite,
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 2.h),
        scrollDirection: Axis.horizontal,
        child: Wrap(
          direction: Axis.horizontal,
          spacing: 38.h,
          children: List.generate(
            3,
            (index) {
              return ExercisesummaryItemWidget();
            },
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildExerciseList(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 8.h),
      child: ListView.builder(
        padding: EdgeInsetsDirectional.zero,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return ExerciselistItemWidget();
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildStartWorkoutButton(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 42.h,
        vertical: 12.h,
      ),
      decoration: AppDecoration.outlineGray,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomElevatedButton(
            height: 60.h,
            text: "start Workout",
            margin: EdgeInsetsDirectional.only(end: 14.h),
            buttonStyle: CustomButtonStyles.fillOrangeA,
            buttonTextStyle: CustomTextStyles.headlineSmallWhiteA700,
          )
        ],
      ),
    );
  }
}

class ExercisesummaryItemWidget extends StatelessWidget {
  const ExercisesummaryItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110.h,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 26.h,
        vertical: 8.h,
      ),
      decoration: AppDecoration.fillGray100.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "12",
            style: CustomTextStyles.titleMediumOrangeA70001,
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              "Exercises",
              style: CustomTextStyles.bodySmallGray60001_1,
            ),
          ),
          SizedBox(height: 12.h)
        ],
      ),
    );
  }
}

class ExerciselistItemWidget extends StatelessWidget {
  const ExerciselistItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(
        start: 4.h,
        end: 10.h,
      ),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 10.h,
        vertical: 6.h,
      ),
      decoration: AppDecoration.fillGray100.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgImage84x98,
            height: 84.h,
            width: 98.h,
            radius: BorderRadius.circular(
              12.h,
            ),
            alignment: AlignmentDirectional.bottomCenter,
            margin: EdgeInsetsDirectional.only(top: 2.h),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 12.h),
              child: Column(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 4.h),
                    child: Text(
                      "Bench Press",
                      style: CustomTextStyles.titleLargeInter,
                    ),
                  ),
                  Text(
                    "4 sets • 12 reps",
                    style: CustomTextStyles.bodyMediumGray60001,
                  )
                ],
              ),
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgVectorOrangeA70001,
            height: 40.h,
            width: 40.h,
            margin: EdgeInsetsDirectional.only(top: 14.h),
          )
        ],
      ),
    );
  }
}
