import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../widgets.dart';

// ignore_for_file: must_be_immutable
class AddExerciseScreen extends StatelessWidget {
  AddExerciseScreen({super.key});

  TextEditingController exerciseNameInputController = TextEditingController();

  TextEditingController exerciseDescriptionInputController =
      TextEditingController();

  TextEditingController muscleGroupInputController = TextEditingController();

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
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 18.h,
            vertical: 42.h,
          ),
          child: Column(
            children: [
              _buildAddExerciseButton(context),
              SizedBox(height: 80.h),
              _buildExerciseNameRow(context),
              SizedBox(height: 22.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 2.h,
                ),
              ),
              SizedBox(height: 14.h),
              _buildExerciseDescriptionRow(context),
              SizedBox(height: 14.h),
              SizedBox(
                width: double.maxFinite,
                child: Divider(
                  color: appTheme.black900,
                  indent: 2.h,
                  endIndent: 2.h,
                ),
              ),
              SizedBox(height: 20.h),
              _buildMuscleGroupRow(context),
              Spacer(
                flex: 51,
              ),
              _buildConfirmButton(context),
              Spacer(
                flex: 48,
              )
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
        margin: EdgeInsetsDirectional.only(start: 10.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildAddExerciseButton(BuildContext context) {
    return CustomElevatedButton(
      height: 60.h,
      text: "Add Exercise",
      margin: EdgeInsetsDirectional.symmetric(horizontal: 68.h),
      buttonStyle: CustomButtonStyles.fillOnPrimaryContainer,
      buttonTextStyle: CustomTextStyles.headlineSmallPoppins_1,
    );
  }

  /// Section Widget
  Widget _buildExerciseNameInput(BuildContext context) {
    return CustomTextFormField(
      width: 190.h,
      controller: exerciseNameInputController,
      hintText: "Exercise Name",
      hintStyle: CustomTextStyles.bodySmallWorkSansBlack900,
      alignment: AlignmentDirectional.center,
      contentPadding: EdgeInsetsDirectional.fromSTEB(18.h, 6.h, 18.h, 2.h),
    );
  }

  /// Section Widget
  Widget _buildExerciseNameRow(BuildContext context) {
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
          _buildExerciseNameInput(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildExerciseDescriptionInput(BuildContext context) {
    return CustomTextFormField(
      width: 190.h,
      controller: exerciseDescriptionInputController,
      hintText: "Describe the exercise...",
      hintStyle: CustomTextStyles.bodySmallWorkSansBlack900,
      alignment: AlignmentDirectional.center,
      maxLines: 5,
      contentPadding: EdgeInsetsDirectional.fromSTEB(14.h, 6.h, 14.h, 12.h),
      borderDecoration: TextFormFieldStyleHelper.fillOnPrimaryContainerTL20,
    );
  }

  /// Section Widget
  Widget _buildExerciseDescriptionRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(start: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: CustomTextStyles.bodyLargeBlack900_1,
          ),
          _buildExerciseDescriptionInput(context)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildMuscleGroupInput(BuildContext context) {
    return CustomTextFormField(
      width: 190.h,
      controller: muscleGroupInputController,
      hintText: "eg:Chest/legs...",
      hintStyle: CustomTextStyles.bodySmallWorkSansBlack900,
      textInputAction: TextInputAction.done,
      alignment: AlignmentDirectional.center,
      contentPadding: EdgeInsetsDirectional.fromSTEB(18.h, 6.h, 18.h, 2.h),
    );
  }

  /// Section Widget
  Widget _buildMuscleGroupRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(start: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Muscle Group",
            style: theme.textTheme.bodyLarge,
          ),
          _buildMuscleGroupInput(context)
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
