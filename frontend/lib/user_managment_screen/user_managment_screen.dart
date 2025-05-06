import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../widgets.dart';

// ignore_for_file: must_be_immutable
class UserManagmentScreen extends StatelessWidget {
  UserManagmentScreen({super.key});

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: _buildAppbar(context),
                  ),
                  _buildUsermanagment(context),
                  SizedBox(height: 18.h),
                  CustomSearchView(
                    width: 198.h,
                    controller: searchController,
                    hintText: "Search by name",
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(14.h, 4.h, 10.h, 4.h),
                  ),
                  SizedBox(height: 24.h),
                  _buildRowidone(context),
                  SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        _buildRowfiveone(context),
                        _buildRowtenone(context),
                        _buildRowfifteenone(context),
                        _buildUsermanagment1(context)
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
      bottomNavigationBar: _buildColumnaddnew(context),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 34.h,
      title: AppbarSubtitleOne(
        text: "←",
        margin: EdgeInsetsDirectional.only(start: 12.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildUsermanagment(BuildContext context) {
    return CustomElevatedButton(
      height: 60.h,
      text: "User Managment",
      margin: EdgeInsetsDirectional.symmetric(horizontal: 98.h),
      buttonStyle: CustomButtonStyles.fillOnPrimaryContainer,
      buttonTextStyle: CustomTextStyles.headlineSmallPoppins_1,
    );
  }

  /// Section Widget
  Widget _buildRowidone(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 64.h,
            width: 64.h,
            decoration: AppDecoration.outlineBlack,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ID",
                  style: theme.textTheme.bodySmall,
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsetsDirectional.symmetric(vertical: 22.h),
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
          ),
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 26.h,
              vertical: 20.h,
            ),
            decoration: AppDecoration.outlineBlack,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Email",
                  style: theme.textTheme.bodySmall,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 30.h,
              vertical: 22.h,
            ),
            decoration: AppDecoration.outlineBlack,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Role",
                  style: theme.textTheme.bodySmall,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 20.h,
              vertical: 22.h,
            ),
            decoration: AppDecoration.outlineBlack,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Actions",
                  style: theme.textTheme.bodySmall,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildEdit(BuildContext context) {
    return CustomElevatedButton(
      text: "Edit",
    );
  }

  /// Section Widget
  Widget _buildDelete(BuildContext context) {
    return CustomElevatedButton(
      text: "Delete",
    );
  }

  /// Section Widget
  Widget _buildRowfiveone(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          Container(
            height: 64.h,
            width: 62.h,
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
              height: 64.h,
              width: 112.h,
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
            height: 64.h,
            width: 88.h,
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
            width: 88.h,
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
            width: 88.h,
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
                _buildEdit(context),
                _buildDelete(context),
                SizedBox(height: 2.h)
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildEditone(BuildContext context) {
    return CustomElevatedButton(
      text: "Edit",
    );
  }

  /// Section Widget
  Widget _buildDeleteone(BuildContext context) {
    return CustomElevatedButton(
      text: "Delete",
    );
  }

  /// Section Widget
  Widget _buildRowtenone(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.img10,
            height: 62.h,
            width: 62.h,
          ),
          Expanded(
            child: Container(
              height: 62.h,
              width: 112.h,
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
            width: 88.h,
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
            width: 88.h,
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
            width: 88.h,
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 10.h,
              vertical: 4.h,
            ),
            decoration: AppDecoration.outlineBlack,
            child: Column(
              spacing: 12,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_buildEditone(context), _buildDeleteone(context)],
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildEdittwo(BuildContext context) {
    return CustomElevatedButton(
      text: "Edit",
    );
  }

  /// Section Widget
  Widget _buildDeletetwo(BuildContext context) {
    return CustomElevatedButton(
      text: "Delete",
    );
  }

  /// Section Widget
  Widget _buildEditthree(BuildContext context) {
    return CustomElevatedButton(
      text: "Edit",
    );
  }

  /// Section Widget
  Widget _buildDeletethree(BuildContext context) {
    return CustomElevatedButton(
      text: "Delete",
    );
  }

  /// Section Widget
  Widget _buildRowfifteenone(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          SizedBox(
            height: 126.h,
            width: 176.h,
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Container(
                    height: 62.h,
                    width: 62.h,
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
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Container(
                    height: 64.h,
                    width: 112.h,
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
                Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Container(
                    height: 62.h,
                    width: 64.h,
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
                  width: 112.h,
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
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 62.h,
                          width: 88.h,
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
                      Expanded(
                        child: Container(
                          height: 62.h,
                          width: 88.h,
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
                              _buildEdittwo(context),
                              _buildDeletetwo(context)
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
                      Expanded(
                        child: Container(
                          height: 62.h,
                          width: 88.h,
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
                      Expanded(
                        child: Container(
                          height: 62.h,
                          width: 88.h,
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
                              _buildEditthree(context),
                              _buildDeletethree(context)
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
    );
  }

  /// Section Widget
  Widget _buildUsermanagment1(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsetsDirectional.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return UserManagmentItemWidget();
      },
    );
  }

  /// Section Widget
  Widget _buildAddnewuser(BuildContext context) {
    return CustomElevatedButton(
      height: 32.h,
      width: 158.h,
      text: "Add new User",
      margin: EdgeInsetsDirectional.only(bottom: 12.h),
      buttonStyle: CustomButtonStyles.fillPrimaryTL16,
      buttonTextStyle: CustomTextStyles.titleSmallWorkSansWhiteA700,
    );
  }

  /// Section Widget
  Widget _buildColumnaddnew(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsetsDirectional.only(end: 138.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [_buildAddnewuser(context)],
      ),
    );
  }
}

class UserManagmentItemWidget extends StatelessWidget {
  const UserManagmentItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 64.h,
          width: 62.h,
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
            height: 64.h,
            width: 112.h,
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
          height: 64.h,
          width: 88.h,
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
          width: 88.h,
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
          width: 88.h,
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 10.h,
            vertical: 4.h,
          ),
          decoration: AppDecoration.outlineBlack,
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildEdit(context), _buildDelete(context)],
          ),
        )
      ],
    );
  }

  /// Section Widget
  Widget _buildEdit(BuildContext context) {
    return CustomElevatedButton(
      text: "Edit",
    );
  }

  /// Section Widget
  Widget _buildDelete(BuildContext context) {
    return CustomElevatedButton(
      text: "Delete",
    );
  }
}
