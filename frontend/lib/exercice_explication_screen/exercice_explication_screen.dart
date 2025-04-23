import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';

class ExerciceExplicationScreen extends StatelessWidget {
  const ExerciceExplicationScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppbar(context),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsetsDirectional.only(top: 20.h),
              child: Column(
                children: [
                  SizedBox(height: 34.h),
                  Container(
                    height: 200.h,
                    width: 202.h,
                    decoration: AppDecoration.outlineGray100.copyWith(
                      borderRadius: BorderRadiusStyle.circleBorder100,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Set 2/4",
                          style: CustomTextStyles.headlineSmallBold,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildColumn25complet(context),
                  SizedBox(height: 68.h),
                  CustomImageView(
                    imagePath: ImageConstant.imgFrame1000006648,
                    height: 190.h,
                    width: double.maxFinite,
                    margin: EdgeInsetsDirectional.only(
                      start: 52.h,
                      end: 58.h,
                    ),
                  ),
                  SizedBox(height: 110.h),
                  _buildColumncontrast(context)
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildColumnend(context),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
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
              text: "Bench Press",
              margin: EdgeInsetsDirectional.only(start: 109.h),
            )
          ],
        ),
      ),
      actions: [
        AppbarSubtitleThree(
          text: "00:00",
          margin: EdgeInsetsDirectional.only(end: 12.h),
        )
      ],
      styleType: Style.bgOutlineGray100,
    );
  }

  /// Section Widget
  Widget _buildColumn25complet(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 10.h),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 4.h),
      child: Column(
        spacing: 18,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsetsDirectional.only(
              start: 4.h,
              end: 2.h,
            ),
            child: Container(
              height: 8.h,
              width: 400.h,
              decoration: BoxDecoration(
                color: appTheme.gray100,
                borderRadius: BorderRadius.circular(
                  4.h,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  4.h,
                ),
                child: LinearProgressIndicator(
                  value: 0.21,
                  backgroundColor: appTheme.gray100,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    appTheme.orangeA70001,
                  ),
                ),
              ),
            ),
          ),
          Text(
            "25% completed",
            style: CustomTextStyles.bodySmallGray60001_1,
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumncontrast(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsetsDirectional.all(12.h),
      decoration: AppDecoration.outlineGray1001,
      child: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsetsDirectional.only(
              start: 24.h,
              end: 34.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.h,
                  width: 22.h,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgContrast,
                        height: 20.h,
                        width: 20.h,
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgVectorBlack900,
                        height: 8.h,
                        width: 6.h,
                        alignment: AlignmentDirectional.topEnd,
                        margin: EdgeInsetsDirectional.only(
                          top: 4.h,
                          end: 6.h,
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 6.h),
                    child: Text(
                      "00:45",
                      style: CustomTextStyles.bodyMediumLight,
                    ),
                  ),
                ),
                Spacer(
                  flex: 34,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgSettingsBlack900,
                  height: 24.h,
                  width: 26.h,
                ),
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 6.h),
                    child: Text(
                      "3 sets left",
                      style: CustomTextStyles.bodyMediumLight,
                    ),
                  ),
                ),
                Spacer(
                  flex: 65,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgHeartLine,
                  height: 24.h,
                  width: 26.h,
                )
              ],
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    height: 48.h,
                    text: "Previous",
                    buttonStyle: CustomButtonStyles.fillGray,
                    buttonTextStyle: CustomTextStyles.titleLargeInterGray60001,
                  ),
                ),
                Expanded(
                  child: CustomElevatedButton(
                    height: 48.h,
                    text: "Next",
                    rightIcon: Container(
                      margin: EdgeInsetsDirectional.only(start: 16.h),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgArrowrightWhiteA700,
                        height: 24.h,
                        width: 24.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    buttonStyle: CustomButtonStyles.fillOrangeA,
                    buttonTextStyle: CustomTextStyles.titleLargeInterWhiteA700,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumnend(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            height: 48.h,
            text: "End Workout",
            margin: EdgeInsetsDirectional.only(bottom: 12.h),
            leftIcon: Container(
              margin: EdgeInsetsDirectional.only(end: 6.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgClose,
                height: 12.h,
                width: 12.h,
                fit: BoxFit.contain,
              ),
            ),
            buttonStyle: CustomButtonStyles.fillDeepOrange,
            buttonTextStyle: CustomTextStyles.titleLargeInterRed500,
          )
        ],
      ),
    );
  }
}
