import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';

class CoachProfileScreen extends StatelessWidget {
  const CoachProfileScreen({Key? key})
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
          child: Column(
            children: [
              _buildUserCameraStack(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsetsDirectional.only(
                      start: 10.h,
                      top: 12.h,
                      end: 10.h,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Coach Name",
                          style: theme.textTheme.headlineLarge,
                        ),
                        SizedBox(height: 48.h),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            "Personal Information",
                            style:
                                CustomTextStyles.headlineSmallWorkSansSemiBold,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        _buildPersonalInfoRow(context),
                        SizedBox(height: 30.h),
                        _buildDateOfBirthRow(context),
                        SizedBox(height: 28.h),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Container(
                            height: 214.h,
                            width: 120.h,
                            margin: EdgeInsetsDirectional.only(start: 10.h),
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Container(
                                    height: 50.h,
                                    width: 50.h,
                                    decoration: BoxDecoration(
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                      borderRadius: BorderRadius.circular(
                                        24.h,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.topEnd,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.only(
                                      top: 4.h,
                                      end: 12.h,
                                    ),
                                    child: Text(
                                      "Height",
                                      style: CustomTextStyles.bodyLargeBlack900,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.topEnd,
                                  child: Padding(
                                    padding:
                                        EdgeInsetsDirectional.only(top: 24.h),
                                    child: Text(
                                      "185cm",
                                      style: theme.textTheme.titleLarge,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              spacing: 46,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomImageView(
                                                  imagePath:
                                                      ImageConstant.imgVector,
                                                  height: 18.h,
                                                  width: 20.h,
                                                  margin: EdgeInsetsDirectional
                                                      .only(start: 14.h),
                                                ),
                                                CustomIconButton(
                                                  height: 50.h,
                                                  width: 50.h,
                                                  padding:
                                                      EdgeInsetsDirectional.all(
                                                          10.h),
                                                  decoration:
                                                      IconButtonStyleHelper
                                                          .none,
                                                  child: CustomImageView(
                                                    imagePath: ImageConstant
                                                        .imgSettingsPrimary,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: AlignmentDirectional
                                                  .bottomStart,
                                              child: Padding(
                                                padding:
                                                    EdgeInsetsDirectional.only(
                                                        bottom: 4.h),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Gender",
                                                      style: CustomTextStyles
                                                          .bodyLargeBlack900,
                                                    ),
                                                    Text(
                                                      "Male",
                                                      style: theme
                                                          .textTheme.titleLarge,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Align(
                                  alignment: AlignmentDirectional.topCenter,
                                  child: SizedBox(
                                    width: double.maxFinite,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: double.maxFinite,
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional.topCenter,
                                            child: Padding(
                                              padding:
                                                  EdgeInsetsDirectional.only(
                                                      top: 16.h),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      spacing: 46,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomImageView(
                                                          imagePath:
                                                              ImageConstant
                                                                  .imgVector,
                                                          height: 18.h,
                                                          width: 20.h,
                                                          margin:
                                                              EdgeInsetsDirectional
                                                                  .only(
                                                                      start:
                                                                          14.h),
                                                        ),
                                                        CustomIconButton(
                                                          height: 50.h,
                                                          width: 50.h,
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .all(10.h),
                                                          decoration:
                                                              IconButtonStyleHelper
                                                                  .none,
                                                          child:
                                                              CustomImageView(
                                                            imagePath: ImageConstant
                                                                .imgMaterialSymbol,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional
                                                              .bottomCenter,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .only(
                                                          end: 10.h,
                                                          bottom: 4.h,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              "Weight",
                                                              style: CustomTextStyles
                                                                  .bodyLargeBlack900,
                                                            ),
                                                            Text(
                                                              "80kg",
                                                              style: theme
                                                                  .textTheme
                                                                  .titleLarge,
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
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 100.h),
                        CustomElevatedButton(
                          height: 32.h,
                          width: 158.h,
                          text: "Chat",
                          buttonStyle: CustomButtonStyles.fillPrimaryTL16,
                          buttonTextStyle: theme.textTheme.titleLarge!,
                        ),
                        SizedBox(height: 38.h)
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

  /// Section Widget
  Widget _buildUserCameraStack(BuildContext context) {
    return SizedBox(
      height: 250.h,
      width: double.maxFinite,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsetsDirectional.symmetric(vertical: 14.h),
              decoration: AppDecoration.fillPrimary1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomAppBar(
                    height: 32.h,
                    leadingWidth: 20.h,
                    leading: AppbarLeadingImage(
                      imagePath: ImageConstant.imgUserPrimary,
                      margin: EdgeInsetsDirectional.only(start: 14.h),
                    ),
                    title: Padding(
                      padding: EdgeInsetsDirectional.only(start: 9.h),
                      child: Row(
                        children: [
                          AppbarSubtitleFour(
                            text: "Back",
                          ),
                          AppbarTitle(
                            text: "Coach Details",
                            margin: EdgeInsetsDirectional.only(start: 79.h),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 140.h,
            width: 142.h,
            decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
              borderRadius: BorderRadiusStyle.circleBorder70,
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgCamera,
                  height: 24.h,
                  width: 26.h,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPersonalInfoRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconButton(
            height: 50.h,
            width: 50.h,
            padding: EdgeInsetsDirectional.all(16.h),
            decoration: IconButtonStyleHelper.none,
            alignment: AlignmentDirectional.center,
            child: CustomImageView(
              imagePath: ImageConstant.imgVectorPrimary,
            ),
          ),
          Expanded(
            child: _buildDateOfBirthColumn(
              context,
              dateofbirthOne: "Email",
              ddmmyyOne: "coachname@example.com",
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildDateOfBirthRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconButton(
            height: 50.h,
            width: 50.h,
            padding: EdgeInsetsDirectional.all(12.h),
            decoration: IconButtonStyleHelper.none,
            child: CustomImageView(
              imagePath: ImageConstant.imgFormkitDate,
            ),
          ),
          Expanded(
            child: _buildDateOfBirthColumn(
              context,
              dateofbirthOne: "Date of Birth",
              ddmmyyOne: "DD/MM/YY",
            ),
          )
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildDateOfBirthColumn(
    BuildContext context, {
    required String dateofbirthOne,
    required String ddmmyyOne,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateofbirthOne,
          style: CustomTextStyles.bodyLargeBlack900.copyWith(
            color: appTheme.black900,
          ),
        ),
        Text(
          ddmmyyOne,
          style: theme.textTheme.titleLarge!.copyWith(
            color: appTheme.black900,
          ),
        )
      ],
    );
  }
}
