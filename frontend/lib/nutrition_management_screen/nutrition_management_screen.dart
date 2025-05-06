// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';

// ignore_for_file: must_be_immutable
class NutritionManagementScreen extends StatelessWidget {
  NutritionManagementScreen({super.key});

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsetsDirectional.only(
                      start: 74.h,
                      end: 88.h,
                    ),
                    padding: EdgeInsetsDirectional.symmetric(vertical: 8.h),
                    decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Nutrition Managment",
                          style: CustomTextStyles.headlineSmallPoppins_1,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CustomSearchView(
                    width: 198.h,
                    controller: searchController,
                    hintText: "Search by name",
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(14.h, 4.h, 10.h, 4.h),
                  ),
                  SizedBox(height: 24.h),
                  _buildNutritionHeaderRow(context),
                  SizedBox(
                    height: 572.h,
                    width: double.maxFinite,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: SizedBox(
                            width: 180.h,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: double.maxFinite,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 64.h,
                                        width: 48.h,
                                        decoration: BoxDecoration(
                                          color: appTheme.blueGray10001,
                                          border: Border.all(
                                            color: appTheme.black900,
                                            width: 1.h,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 64.h,
                                          width: 74.h,
                                          decoration: BoxDecoration(
                                            color: appTheme.blueGray10001,
                                            border: Border.all(
                                              color: appTheme.black900,
                                              width: 1.h,
                                              strokeAlign:
                                                  BorderSide.strokeAlignCenter,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 64.h,
                                        width: 56.h,
                                        decoration: BoxDecoration(
                                          color: appTheme.blueGray10001,
                                          border: Border.all(
                                            color: appTheme.black900,
                                            width: 1.h,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: double.maxFinite,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: double.maxFinite,
                                              child: Row(
                                                children: [
                                                  CustomImageView(
                                                    imagePath: ImageConstant
                                                        .img1062x48,
                                                    height: 62.h,
                                                    width: 48.h,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      height: 62.h,
                                                      width: 74.h,
                                                      decoration: BoxDecoration(
                                                        color: appTheme
                                                            .blueGray10001,
                                                        border: Border.all(
                                                          color:
                                                              appTheme.black900,
                                                          width: 1.h,
                                                          strokeAlign: BorderSide
                                                              .strokeAlignCenter,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: double.maxFinite,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 62.h,
                                                    width: 48.h,
                                                    decoration: BoxDecoration(
                                                      color: appTheme
                                                          .blueGray10001,
                                                      border: Border.all(
                                                        color:
                                                            appTheme.black900,
                                                        width: 1.h,
                                                        strokeAlign: BorderSide
                                                            .strokeAlignCenter,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      height: 62.h,
                                                      width: 74.h,
                                                      decoration: BoxDecoration(
                                                        color: appTheme
                                                            .blueGray10001,
                                                        border: Border.all(
                                                          color:
                                                              appTheme.black900,
                                                          width: 1.h,
                                                          strokeAlign: BorderSide
                                                              .strokeAlignCenter,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 56.h,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 64.h,
                                              width: 56.h,
                                              decoration: BoxDecoration(
                                                color: appTheme.blueGray10001,
                                                border: Border.all(
                                                  color: appTheme.black900,
                                                  width: 1.h,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignCenter,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 62.h,
                                              width: 56.h,
                                              decoration: BoxDecoration(
                                                color: appTheme.blueGray10001,
                                                border: Border.all(
                                                  color: appTheme.black900,
                                                  width: 1.h,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignCenter,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [_buildNutritionDataRow(context)],
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [_buildNutritionActionRow(context)],
                            ),
                          ),
                        ),
                        _buildNutritionDetailsColumn(context),
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [_buildNutritionSummaryRow(context)],
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [_buildNutritionFooterRow(context)],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 44.h)
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildColumnadd(context),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 40.h,
      title: AppbarSubtitleOne(
        text: "←",
        margin: EdgeInsetsDirectional.only(start: 15.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildNutritionHeaderRow(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 18.h,
              vertical: 22.h,
            ),
            decoration: AppDecoration.outlineBlack,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ID",
                  style: theme.textTheme.bodySmall,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 18.h,
              vertical: 22.h,
            ),
            decoration: AppDecoration.outlineBlack,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Name",
                  style: theme.textTheme.bodySmall,
                )
              ],
            ),
          ),
          Container(
            height: 60.h,
            width: 56.h,
            decoration: AppDecoration.outlineBlack,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Protein",
                  style: theme.textTheme.bodySmall,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsetsDirectional.symmetric(vertical: 22.h),
            decoration: AppDecoration.outlineBlack,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Calories",
                  style: theme.textTheme.bodySmall,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 16.h,
              vertical: 20.h,
            ),
            decoration: AppDecoration.outlineBlack,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Fat",
                  style: theme.textTheme.bodySmall,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 14.h,
              vertical: 20.h,
            ),
            decoration: AppDecoration.outlineBlack,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Carbs",
                  style: CustomTextStyles.bodySmallWorkSans,
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsetsDirectional.symmetric(vertical: 20.h),
              decoration: AppDecoration.outlineBlack,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 2.h),
                  Text(
                    "Actions",
                    style: theme.textTheme.bodySmall,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildEditButton(BuildContext context) {
    return CustomElevatedButton(
      text: "Edit",
    );
  }

  /// Section Widget
  Widget _buildDeleteButton(BuildContext context) {
    return CustomElevatedButton(
      text: "Delete",
    );
  }

  /// Section Widget
  Widget _buildEditButton1(BuildContext context) {
    return CustomElevatedButton(
      text: "Edit",
    );
  }

  /// Section Widget
  Widget _buildDeleteButton1(BuildContext context) {
    return CustomElevatedButton(
      text: "Delete",
    );
  }

  /// Section Widget
  Widget _buildNutritionDataRow(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Align(
        alignment: AlignmentDirectional.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 52.h,
              child: Column(
                children: [
                  Container(
                    height: 66.h,
                    width: 52.h,
                    decoration: BoxDecoration(
                      color: appTheme.blueGray10001,
                      border: Border.all(
                        color: appTheme.black900,
                        width: 1.h,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                  ),
                  Container(
                    height: 62.h,
                    width: 52.h,
                    decoration: BoxDecoration(
                      color: appTheme.blueGray10001,
                      border: Border.all(
                        color: appTheme.black900,
                        width: 1.h,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 208.h,
              child: Column(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Container(
                          height: 64.h,
                          width: 52.h,
                          decoration: BoxDecoration(
                            color: appTheme.blueGray10001,
                            border: Border.all(
                              color: appTheme.black900,
                              width: 1.h,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                          ),
                        ),
                        Container(
                          height: 64.h,
                          width: 66.h,
                          decoration: BoxDecoration(
                            color: appTheme.blueGray10001,
                            border: Border.all(
                              color: appTheme.black900,
                              width: 1.h,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: 10.h,
                              vertical: 4.h,
                            ),
                            decoration: AppDecoration.outlineBlack,
                            child: Column(
                              spacing: 12,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildEditButton(context),
                                _buildDeleteButton(context),
                                SizedBox(height: 2.h)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Container(
                          height: 62.h,
                          width: 52.h,
                          decoration: BoxDecoration(
                            color: appTheme.blueGray10001,
                            border: Border.all(
                              color: appTheme.black900,
                              width: 1.h,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                          ),
                        ),
                        Container(
                          height: 62.h,
                          width: 66.h,
                          decoration: BoxDecoration(
                            color: appTheme.blueGray10001,
                            border: Border.all(
                              color: appTheme.black900,
                              width: 1.h,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: 10.h,
                              vertical: 4.h,
                            ),
                            decoration: AppDecoration.outlineBlack,
                            child: Column(
                              spacing: 12,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildEditButton1(context),
                                _buildDeleteButton1(context)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildEditButton2(BuildContext context) {
    return CustomElevatedButton(
      text: "Edit",
    );
  }

  /// Section Widget
  Widget _buildDeleteButton2(BuildContext context) {
    return CustomElevatedButton(
      text: "Delete",
    );
  }

  /// Section Widget
  Widget _buildEditButton3(BuildContext context) {
    return CustomElevatedButton(
      text: "Edit",
    );
  }

  /// Section Widget
  Widget _buildDeleteButton3(BuildContext context) {
    return CustomElevatedButton(
      text: "Delete",
    );
  }

  /// Section Widget
  Widget _buildNutritionActionRow(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Align(
        alignment: AlignmentDirectional.topCenter,
        child: Padding(
          padding: EdgeInsetsDirectional.only(top: 128.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  Container(
                    height: 64.h,
                    width: 66.h,
                    decoration: BoxDecoration(
                      color: appTheme.blueGray10001,
                      border: Border.all(
                        color: appTheme.black900,
                        width: 1.h,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                  ),
                  Container(
                    height: 62.h,
                    width: 66.h,
                    decoration: BoxDecoration(
                      color: appTheme.blueGray10001,
                      border: Border.all(
                        color: appTheme.black900,
                        width: 1.h,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 88.h,
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 10.h,
                        vertical: 4.h,
                      ),
                      decoration: AppDecoration.outlineBlack,
                      child: Column(
                        spacing: 12,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildEditButton2(context),
                          _buildDeleteButton2(context)
                        ],
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 10.h,
                        vertical: 4.h,
                      ),
                      decoration: AppDecoration.outlineBlack,
                      child: Column(
                        spacing: 12,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildEditButton3(context),
                          _buildDeleteButton3(context)
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildEditButton4(BuildContext context) {
    return CustomElevatedButton(
      text: "Edit",
    );
  }

  /// Section Widget
  Widget _buildDeleteButton4(BuildContext context) {
    return CustomElevatedButton(
      text: "Delete",
    );
  }

  /// Section Widget
  Widget _buildEditButton5(BuildContext context) {
    return CustomElevatedButton(
      text: "Edit",
    );
  }

  /// Section Widget
  Widget _buildDeleteButton5(BuildContext context) {
    return CustomElevatedButton(
      text: "Delete",
    );
  }

  /// Section Widget
  Widget _buildEditButton6(BuildContext context) {
    return CustomElevatedButton(
      text: "Edit",
    );
  }

  /// Section Widget
  Widget _buildDeleteButton6(BuildContext context) {
    return CustomElevatedButton(
      text: "Delete",
    );
  }

  /// Section Widget
  Widget _buildEditButton7(BuildContext context) {
    return CustomElevatedButton(
      text: "Edit",
    );
  }

  /// Section Widget
  Widget _buildDeleteButton7(BuildContext context) {
    return CustomElevatedButton(
      text: "Delete",
    );
  }

  /// Section Widget
  Widget _buildEditButton8(BuildContext context) {
    return CustomElevatedButton(
      text: "Edit",
    );
  }

  /// Section Widget
  Widget _buildDeleteButton8(BuildContext context) {
    return CustomElevatedButton(
      text: "Delete",
    );
  }

  /// Section Widget
  Widget _buildNutritionDetailsColumn(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                Container(
                  height: 64.h,
                  width: 48.h,
                  decoration: BoxDecoration(
                    color: appTheme.blueGray10001,
                    border: Border.all(
                      color: appTheme.black900,
                      width: 1.h,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  ),
                ),
                Container(
                  height: 64.h,
                  width: 74.h,
                  decoration: BoxDecoration(
                    color: appTheme.blueGray10001,
                    border: Border.all(
                      color: appTheme.black900,
                      width: 1.h,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  ),
                ),
                Container(
                  height: 64.h,
                  width: 56.h,
                  decoration: BoxDecoration(
                    color: appTheme.blueGray10001,
                    border: Border.all(
                      color: appTheme.black900,
                      width: 1.h,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  ),
                ),
                Container(
                  height: 64.h,
                  width: 52.h,
                  decoration: BoxDecoration(
                    color: appTheme.blueGray10001,
                    border: Border.all(
                      color: appTheme.black900,
                      width: 1.h,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  ),
                ),
                Container(
                  height: 64.h,
                  width: 52.h,
                  decoration: BoxDecoration(
                    color: appTheme.blueGray10001,
                    border: Border.all(
                      color: appTheme.black900,
                      width: 1.h,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  ),
                ),
                Container(
                  height: 64.h,
                  width: 66.h,
                  decoration: BoxDecoration(
                    color: appTheme.blueGray10001,
                    border: Border.all(
                      color: appTheme.black900,
                      width: 1.h,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 10.h,
                      vertical: 4.h,
                    ),
                    decoration: AppDecoration.outlineBlack,
                    child: Column(
                      spacing: 12,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildEditButton4(context),
                        _buildDeleteButton4(context)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Container(
                              height: 62.h,
                              width: 48.h,
                              decoration: BoxDecoration(
                                color: appTheme.blueGray10001,
                                border: Border.all(
                                  color: appTheme.black900,
                                  width: 1.h,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 62.h,
                                width: 74.h,
                                decoration: BoxDecoration(
                                  color: appTheme.blueGray10001,
                                  border: Border.all(
                                    color: appTheme.black900,
                                    width: 1.h,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 62.h,
                              width: 56.h,
                              decoration: BoxDecoration(
                                color: appTheme.blueGray10001,
                                border: Border.all(
                                  color: appTheme.black900,
                                  width: 1.h,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                ),
                              ),
                            ),
                            Container(
                              height: 62.h,
                              width: 52.h,
                              decoration: BoxDecoration(
                                color: appTheme.blueGray10001,
                                border: Border.all(
                                  color: appTheme.black900,
                                  width: 1.h,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                ),
                              ),
                            ),
                            Container(
                              height: 62.h,
                              width: 52.h,
                              decoration: BoxDecoration(
                                color: appTheme.blueGray10001,
                                border: Border.all(
                                  color: appTheme.black900,
                                  width: 1.h,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 48.h,
                              child: Column(
                                children: [
                                  Container(
                                    height: 62.h,
                                    width: 48.h,
                                    decoration: BoxDecoration(
                                      color: appTheme.blueGray10001,
                                      border: Border.all(
                                        color: appTheme.black900,
                                        width: 1.h,
                                        strokeAlign:
                                            BorderSide.strokeAlignCenter,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 64.h,
                                    width: 48.h,
                                    decoration: BoxDecoration(
                                      color: appTheme.blueGray10001,
                                      border: Border.all(
                                        color: appTheme.black900,
                                        width: 1.h,
                                        strokeAlign:
                                            BorderSide.strokeAlignCenter,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 128.h,
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Container(
                                        height: 64.h,
                                        width: 74.h,
                                        decoration: BoxDecoration(
                                          color: appTheme.blueGray10001,
                                          border: Border.all(
                                            color: appTheme.black900,
                                            width: 1.h,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional.topEnd,
                                      child: Container(
                                        height: 62.h,
                                        width: 56.h,
                                        decoration: BoxDecoration(
                                          color: appTheme.blueGray10001,
                                          border: Border.all(
                                            color: appTheme.black900,
                                            width: 1.h,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional.bottomStart,
                                      child: Container(
                                        height: 64.h,
                                        width: 74.h,
                                        decoration: BoxDecoration(
                                          color: appTheme.blueGray10001,
                                          border: Border.all(
                                            color: appTheme.black900,
                                            width: 1.h,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 64.h,
                                      width: 56.h,
                                      decoration: BoxDecoration(
                                        color: appTheme.blueGray10001,
                                        border: Border.all(
                                          color: appTheme.black900,
                                          width: 1.h,
                                          strokeAlign:
                                              BorderSide.strokeAlignCenter,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 106.h,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: double.maxFinite,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 62.h,
                                            width: 52.h,
                                            decoration: BoxDecoration(
                                              color: appTheme.blueGray10001,
                                              border: Border.all(
                                                color: appTheme.black900,
                                                width: 1.h,
                                                strokeAlign: BorderSide
                                                    .strokeAlignCenter,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 62.h,
                                            width: 52.h,
                                            decoration: BoxDecoration(
                                              color: appTheme.blueGray10001,
                                              border: Border.all(
                                                color: appTheme.black900,
                                                width: 1.h,
                                                strokeAlign: BorderSide
                                                    .strokeAlignCenter,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.maxFinite,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 64.h,
                                            width: 52.h,
                                            decoration: BoxDecoration(
                                              color: appTheme.blueGray10001,
                                              border: Border.all(
                                                color: appTheme.black900,
                                                width: 1.h,
                                                strokeAlign: BorderSide
                                                    .strokeAlignCenter,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 64.h,
                                            width: 52.h,
                                            decoration: BoxDecoration(
                                              color: appTheme.blueGray10001,
                                              border: Border.all(
                                                color: appTheme.black900,
                                                width: 1.h,
                                                strokeAlign: BorderSide
                                                    .strokeAlignCenter,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: 64.h,
                      width: 66.h,
                      decoration: BoxDecoration(
                        color: appTheme.blueGray10001,
                        border: Border.all(
                          color: appTheme.black900,
                          width: 1.h,
                          strokeAlign: BorderSide.strokeAlignCenter,
                        ),
                      ),
                    ),
                    Container(
                      height: 64.h,
                      width: 66.h,
                      decoration: BoxDecoration(
                        color: appTheme.blueGray10001,
                        border: Border.all(
                          color: appTheme.black900,
                          width: 1.h,
                          strokeAlign: BorderSide.strokeAlignCenter,
                        ),
                      ),
                    ),
                    Container(
                      height: 64.h,
                      width: 66.h,
                      decoration: BoxDecoration(
                        color: appTheme.blueGray10001,
                        border: Border.all(
                          color: appTheme.black900,
                          width: 1.h,
                          strokeAlign: BorderSide.strokeAlignCenter,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 88.h,
                  child: Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 10.h,
                          vertical: 4.h,
                        ),
                        decoration: AppDecoration.outlineBlack,
                        child: Column(
                          spacing: 12,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildEditButton5(context),
                            _buildDeleteButton5(context)
                          ],
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 10.h,
                          vertical: 4.h,
                        ),
                        decoration: AppDecoration.outlineBlack,
                        child: Column(
                          spacing: 12,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildEditButton6(context),
                            _buildDeleteButton6(context)
                          ],
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 10.h,
                          vertical: 4.h,
                        ),
                        decoration: AppDecoration.outlineBlack,
                        child: Column(
                          spacing: 12,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildEditButton7(context),
                            _buildDeleteButton7(context),
                            SizedBox(height: 2.h)
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                Container(
                  height: 62.h,
                  width: 48.h,
                  decoration: BoxDecoration(
                    color: appTheme.blueGray10001,
                    border: Border.all(
                      color: appTheme.black900,
                      width: 1.h,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 62.h,
                    width: 76.h,
                    decoration: BoxDecoration(
                      color: appTheme.blueGray10001,
                      border: Border.all(
                        color: appTheme.black900,
                        width: 1.h,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 62.h,
                  width: 56.h,
                  decoration: BoxDecoration(
                    color: appTheme.blueGray10001,
                    border: Border.all(
                      color: appTheme.black900,
                      width: 1.h,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  ),
                ),
                Container(
                  height: 62.h,
                  width: 52.h,
                  decoration: BoxDecoration(
                    color: appTheme.blueGray10001,
                    border: Border.all(
                      color: appTheme.black900,
                      width: 1.h,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  ),
                ),
                Container(
                  height: 62.h,
                  width: 52.h,
                  decoration: BoxDecoration(
                    color: appTheme.blueGray10001,
                    border: Border.all(
                      color: appTheme.black900,
                      width: 1.h,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  ),
                ),
                Container(
                  height: 62.h,
                  width: 66.h,
                  decoration: BoxDecoration(
                    color: appTheme.blueGray10001,
                    border: Border.all(
                      color: appTheme.black900,
                      width: 1.h,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 10.h,
                      vertical: 4.h,
                    ),
                    decoration: AppDecoration.outlineBlack,
                    child: Column(
                      spacing: 12,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildEditButton8(context),
                        _buildDeleteButton8(context)
                      ],
                    ),
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
  Widget _buildNutritionSummaryRow(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Align(
        alignment: AlignmentDirectional.topCenter,
        child: Padding(
          padding: EdgeInsetsDirectional.only(top: 190.h),
          child: Row(
            children: [
              Container(
                height: 62.h,
                width: 48.h,
                decoration: BoxDecoration(
                  color: appTheme.blueGray10001,
                  border: Border.all(
                    color: appTheme.black900,
                    width: 1.h,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                ),
              ),
              Container(
                height: 62.h,
                width: 74.h,
                decoration: BoxDecoration(
                  color: appTheme.blueGray10001,
                  border: Border.all(
                    color: appTheme.black900,
                    width: 1.h,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                ),
              ),
              Container(
                height: 62.h,
                width: 56.h,
                decoration: BoxDecoration(
                  color: appTheme.blueGray10001,
                  border: Border.all(
                    color: appTheme.black900,
                    width: 1.h,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                ),
              ),
              Container(
                height: 62.h,
                width: 52.h,
                decoration: BoxDecoration(
                  color: appTheme.blueGray10001,
                  border: Border.all(
                    color: appTheme.black900,
                    width: 1.h,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                ),
              ),
              Container(
                height: 62.h,
                width: 52.h,
                decoration: BoxDecoration(
                  color: appTheme.blueGray10001,
                  border: Border.all(
                    color: appTheme.black900,
                    width: 1.h,
                    strokeAlign: BorderSide.strokeAlignCenter,
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
  Widget _buildNutritionFooterRow(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Align(
        alignment: AlignmentDirectional.topCenter,
        child: Container(
          margin: EdgeInsetsDirectional.only(top: 128.h),
          padding: EdgeInsetsDirectional.only(end: 154.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 62.h,
                width: 52.h,
                decoration: BoxDecoration(
                  color: appTheme.blueGray10001,
                  border: Border.all(
                    color: appTheme.black900,
                    width: 1.h,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                ),
              ),
              Container(
                height: 62.h,
                width: 52.h,
                decoration: BoxDecoration(
                  color: appTheme.blueGray10001,
                  border: Border.all(
                    color: appTheme.black900,
                    width: 1.h,
                    strokeAlign: BorderSide.strokeAlignCenter,
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
  Widget _buildAddNutritionButton(BuildContext context) {
    return CustomElevatedButton(
      height: 32.h,
      width: 158.h,
      text: "Add Nutrition",
      margin: EdgeInsetsDirectional.only(bottom: 12.h),
      buttonStyle: CustomButtonStyles.fillPrimaryTL16,
      buttonTextStyle: CustomTextStyles.titleSmallWorkSansWhiteA700,
    );
  }

  /// Section Widget
  Widget _buildColumnadd(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsetsDirectional.only(end: 138.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [_buildAddNutritionButton(context)],
      ),
    );
  }
}
