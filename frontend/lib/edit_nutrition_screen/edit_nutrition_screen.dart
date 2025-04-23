import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';

// ignore_for_file: must_be_immutable
class EditNutritionScreen extends StatelessWidget {
  EditNutritionScreen({Key? key})
      : super(
          key: key,
        );

  TextEditingController egappleoneController = TextEditingController();

  TextEditingController weightController = TextEditingController();

  TextEditingController weightoneController = TextEditingController();

  TextEditingController weighttwoController = TextEditingController();

  TextEditingController weightthreeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppbar(context),
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
              _buildEditnutrition(context),
              SizedBox(height: 80.h),
              _buildRowname(context),
              SizedBox(height: 22.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 2.h,
                ),
              ),
              SizedBox(height: 14.h),
              _buildRowprotein(context),
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
              _buildRowcalories(context),
              SizedBox(height: 26.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 2.h,
                ),
              ),
              SizedBox(height: 16.h),
              _buildRowfat(context),
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
              _buildRowcarbs(context),
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
              _buildConfirm(context)
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 44.h,
      title: AppbarSubtitleOne(
        text: "←",
        margin: EdgeInsetsDirectional.only(start: 10.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildEditnutrition(BuildContext context) {
    return CustomElevatedButton(
      height: 60.h,
      text: "Edit Nutrition ",
      margin: EdgeInsetsDirectional.symmetric(horizontal: 68.h),
      buttonStyle: CustomButtonStyles.fillOnPrimaryContainer,
      buttonTextStyle: CustomTextStyles.headlineSmallPoppins_1,
    );
  }

  /// Section Widget
  Widget _buildEgappleone(BuildContext context) {
    return CustomTextFormField(
      width: 190.h,
      controller: egappleoneController,
      hintText: "Eg: Apple",
      alignment: AlignmentDirectional.center,
      contentPadding: EdgeInsetsDirectional.fromSTEB(18.h, 6.h, 18.h, 2.h),
    );
  }

  /// Section Widget
  Widget _buildRowname(BuildContext context) {
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
          _buildEgappleone(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildWeight(BuildContext context) {
    return CustomTextFormField(
      width: 190.h,
      controller: weightController,
      hintText: "Per 100g",
      alignment: AlignmentDirectional.center,
      contentPadding: EdgeInsetsDirectional.fromSTEB(18.h, 6.h, 18.h, 2.h),
    );
  }

  /// Section Widget
  Widget _buildRowprotein(BuildContext context) {
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
          _buildWeight(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildWeightone(BuildContext context) {
    return CustomTextFormField(
      width: 190.h,
      controller: weightoneController,
      hintText: "per 100g",
      alignment: AlignmentDirectional.center,
      contentPadding: EdgeInsetsDirectional.fromSTEB(18.h, 6.h, 18.h, 2.h),
    );
  }

  /// Section Widget
  Widget _buildRowcalories(BuildContext context) {
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
          _buildWeightone(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildWeighttwo(BuildContext context) {
    return CustomTextFormField(
      width: 190.h,
      controller: weighttwoController,
      hintText: "per 100g",
      contentPadding: EdgeInsetsDirectional.fromSTEB(18.h, 6.h, 18.h, 2.h),
    );
  }

  /// Section Widget
  Widget _buildRowfat(BuildContext context) {
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
          _buildWeighttwo(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildWeightthree(BuildContext context) {
    return CustomTextFormField(
      width: 190.h,
      controller: weightthreeController,
      hintText: "per 100g",
      textInputAction: TextInputAction.done,
      alignment: AlignmentDirectional.center,
      contentPadding: EdgeInsetsDirectional.fromSTEB(18.h, 6.h, 18.h, 2.h),
    );
  }

  /// Section Widget
  Widget _buildRowcarbs(BuildContext context) {
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
          _buildWeightthree(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildConfirm(BuildContext context) {
    return CustomElevatedButton(
      height: 32.h,
      width: 158.h,
      text: "Confirm",
      buttonStyle: CustomButtonStyles.fillPrimaryTL16,
      buttonTextStyle: CustomTextStyles.bodyLargeWhiteA700,
    );
  }
}
