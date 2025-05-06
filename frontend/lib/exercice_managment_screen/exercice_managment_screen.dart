import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../widgets.dart';

// ignore_for_file: must_be_immutable
class ExerciceManagmentScreen extends StatelessWidget {
  ExerciceManagmentScreen({super.key});

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppbar(context),
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
                    margin: EdgeInsetsDirectional.symmetric(horizontal: 86.h),
                    padding: EdgeInsetsDirectional.symmetric(vertical: 6.h),
                    decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 4.h),
                        Text(
                          "Exercice Managment",
                          style: CustomTextStyles.headlineSmallPoppins_1,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
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
                        _buildListtwentyfive(context)
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
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 38.h,
      title: AppbarSubtitleOne(
        text: "←",
        margin: EdgeInsetsDirectional.only(start: 8.h),
      ),
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
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 24.h,
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
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsetsDirectional.symmetric(vertical: 22.h),
              decoration: AppDecoration.outlineBlack,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Description",
                    style: theme.textTheme.bodySmall,
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 6.h,
              vertical: 22.h,
            ),
            decoration: AppDecoration.outlineBlack,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Muscle Group ",
                  style: theme.textTheme.bodySmall,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsetsDirectional.all(20.h),
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
          Container(
            height: 64.h,
            width: 86.h,
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
              width: 110.h,
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
            width: 92.h,
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
            decoration: AppDecoration.outlineBlack,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                SizedBox(
                  width: 68.h,
                  child: Column(
                    spacing: 12,
                    mainAxisSize: MainAxisSize.min,
                    children: [_buildEdit(context), _buildDelete(context)],
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
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildEditone(context),
                      _buildDeleteone(context),
                      SizedBox(height: 2.h)
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
  Widget _buildRowtenone(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.img1062x62,
            height: 62.h,
            width: 62.h,
          ),
          Container(
            height: 62.h,
            width: 86.h,
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
              width: 110.h,
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
            width: 92.h,
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
              children: [_buildEdittwo(context), _buildDeletetwo(context)],
            ),
          )
        ],
      ),
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
  Widget _buildEditfour(BuildContext context) {
    return CustomElevatedButton(
      text: "Edit",
    );
  }

  /// Section Widget
  Widget _buildDeletefour(BuildContext context) {
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
          Expanded(
            child: SizedBox(
              height: 126.h,
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
                      width: 86.h,
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
                    width: 86.h,
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
          SizedBox(
            width: 110.h,
            child: Column(
              children: [
                Container(
                  height: 62.h,
                  width: 110.h,
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
                  width: 110.h,
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
            width: 92.h,
            child: Column(
              children: [
                Container(
                  height: 64.h,
                  width: 92.h,
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
                  width: 92.h,
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
                      _buildEditthree(context),
                      _buildDeletethree(context)
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
                      _buildEditfour(context),
                      _buildDeletefour(context)
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
  Widget _buildListtwentyfive(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsetsDirectional.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListtwentyfiveItemWidget();
      },
    );
  }

  /// Section Widget
  Widget _buildAddexercise(BuildContext context) {
    return CustomElevatedButton(
      height: 32.h,
      width: 158.h,
      text: "Add Exercise",
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
        children: [_buildAddexercise(context)],
      ),
    );
  }
}

class ListtwentyfiveItemWidget extends StatelessWidget {
  const ListtwentyfiveItemWidget({super.key});

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
        Container(
          height: 64.h,
          width: 86.h,
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
            width: 110.h,
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
          width: 92.h,
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
          padding: EdgeInsetsDirectional.symmetric(horizontal: 10.h),
          decoration: AppDecoration.outlineBlack,
          child: Column(
            spacing: 14,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEdit(context),
              _buildDelete(context),
              SizedBox(height: 4.h)
            ],
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
