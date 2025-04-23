import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';

// ignore_for_file: must_be_immutable
class AddNutritionScreen extends StatelessWidget {
  AddNutritionScreen({Key? key})
      : super(
          key: key,
        );

  TextEditingController nameInputController = TextEditingController();

  TextEditingController proteinInputController = TextEditingController();

  TextEditingController caloriesInputController = TextEditingController();

  TextEditingController fatInputController = TextEditingController();

  TextEditingController carbsInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsetsDirectional.only(
            start: 18.h,
            top: 42.h,
            end: 18.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildAddNutritionButton(context),
              SizedBox(height: 80.h),
              _buildNameRow(context),
              SizedBox(height: 22.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 2.h,
                ),
              ),
              SizedBox(height: 14.h),
              _buildProteinRow(context),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 2.h,
                  endIndent: 2.h,
                ),
              ),
              SizedBox(height: 20.h),
              _buildCaloriesRow(context),
              SizedBox(height: 26.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 2.h,
                ),
              ),
              SizedBox(height: 16.h),
              _buildFatRow(context),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 2.h,
                  endIndent: 2.h,
                ),
              ),
              SizedBox(height: 20.h),
              _buildCarbsRow(context),
              SizedBox(height: 18.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 2.h,
                  endIndent: 2.h,
                ),
              ),
              SizedBox(height: 94.h),
              _buildConfirmButton(context)
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 44.h,
      title: AppbarSubtitleOne(
        text: "←",
        margin: EdgeInsetsDirectional.only(start: 12.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildAddNutritionButton(BuildContext context) {
    return CustomElevatedButton(
      height: 60.h,
      text: "Add Nutrition",
      margin: EdgeInsetsDirectional.symmetric(horizontal: 68.h),
      buttonStyle: CustomButtonStyles.fillOnPrimaryContainer,
      buttonTextStyle: CustomTextStyles.headlineSmallPoppins_1,
    );
  }

  /// Section Widget
  Widget _buildNameInput(BuildContext context) {
    return CustomTextFormField(
      width: 190.h,
      controller: nameInputController,
      hintText: "Eg: Apple",
      alignment: AlignmentDirectional.center,
      contentPadding: EdgeInsetsDirectional.fromSTEB(18.h, 6.h, 18.h, 2.h),
    );
  }

  /// Section Widget
  Widget _buildNameRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(start: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(top: 2.h),
            child: Text(
              "Name",
              style: CustomTextStyles.bodyLargeBlack900_1,
            ),
          ),
          _buildNameInput(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildProteinInput(BuildContext context) {
    return CustomTextFormField(
      width: 190.h,
      controller: proteinInputController,
      hintText: "Per 100g",
      alignment: AlignmentDirectional.center,
      contentPadding: EdgeInsetsDirectional.fromSTEB(18.h, 6.h, 18.h, 2.h),
    );
  }

  /// Section Widget
  Widget _buildProteinRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(start: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Protein",
            style: CustomTextStyles.bodyLargeBlack900_1,
          ),
          _buildProteinInput(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildCaloriesInput(BuildContext context) {
    return CustomTextFormField(
      width: 190.h,
      controller: caloriesInputController,
      hintText: "per 100g",
      alignment: AlignmentDirectional.center,
      contentPadding: EdgeInsetsDirectional.fromSTEB(18.h, 6.h, 18.h, 2.h),
    );
  }

  /// Section Widget
  Widget _buildCaloriesRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(start: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Calories",
            style: theme.textTheme.bodyLarge,
          ),
          _buildCaloriesInput(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildFatInput(BuildContext context) {
    return CustomTextFormField(
      width: 190.h,
      controller: fatInputController,
      hintText: "per 100g",
      contentPadding: EdgeInsetsDirectional.fromSTEB(18.h, 6.h, 18.h, 2.h),
    );
  }

  /// Section Widget
  Widget _buildFatRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(start: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Fat",
            style: CustomTextStyles.bodyLargeBlack900_1,
          ),
          _buildFatInput(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildCarbsInput(BuildContext context) {
    return CustomTextFormField(
      width: 190.h,
      controller: carbsInputController,
      hintText: "per 100g",
      textInputAction: TextInputAction.done,
      alignment: AlignmentDirectional.center,
      contentPadding: EdgeInsetsDirectional.fromSTEB(18.h, 6.h, 18.h, 2.h),
    );
  }

  /// Section Widget
  Widget _buildCarbsRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(start: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Carbs",
            style: theme.textTheme.bodyLarge,
          ),
          _buildCarbsInput(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildConfirmButton(BuildContext context) {
    return CustomElevatedButton(
      height: 32.h,
      width: 158.h,
      text: "Confirm",
      buttonStyle: CustomButtonStyles.fillPrimaryTL16,
      buttonTextStyle: CustomTextStyles.bodyLargeWhiteA700,
    );
  }
}
