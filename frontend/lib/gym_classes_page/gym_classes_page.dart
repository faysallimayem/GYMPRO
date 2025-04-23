import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart'; // ignore_for_file: must_be_immutable

class GymClassesPage extends StatefulWidget {
  const GymClassesPage({Key? key})
      : super(
          key: key,
        );

  @override
  GymClassesPageState createState() => GymClassesPageState();
}

// ignore_for_file: must_be_immutable
class GymClassesPageState extends State<GymClassesPage>
    with TickerProviderStateMixin {
  List<DateTime?> selectedDatesFromCalendar = [];

  late TabController tabviewController;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 26.h),
              _buildDateSelector(context),
              SizedBox(height: 32.h),
              _buildTabview(context),
              Expanded(
                child: Container(
                  child: TabBarView(
                    controller: tabviewController,
                    children: [
                      GymclassesallTabPage(),
                      GymclassesallTabPage(),
                      GymclassesallTabPage(),
                      GymclassesallTabPage()
                    ],
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
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 52.h,
      title: Padding(
        padding: EdgeInsetsDirectional.only(start: 16.h),
        child: Row(
          children: [
            AppbarSubtitleOne(
              text: "←",
            ),
            AppbarSubtitle(
              text: "classes",
              margin: EdgeInsetsDirectional.only(start: 135.h),
            )
          ],
        ),
      ),
      styleType: Style.bgOutlineGray100,
    );
  }

  /// Section Widget
  Widget _buildDateSelector(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 8.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: SizedBox(
            height: 100.h,
            width: 660.h,
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.single,
                firstDate: DateTime(DateTime.now().year - 5),
                lastDate: DateTime(DateTime.now().year + 5),
                firstDayOfWeek: 0,
              ),
              value: selectedDatesFromCalendar,
              onValueChanged: (dates) {},
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildTabview(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(start: 8.h),
      child: TabBar(
        controller: tabviewController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: appTheme.whiteA700,
        labelStyle: TextStyle(
          fontSize: 16.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        unselectedLabelColor: appTheme.black900,
        unselectedLabelStyle: TextStyle(
          fontSize: 16.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(
            height: 32,
            child: Container(
              alignment: AlignmentDirectional.center,
              decoration: tabIndex == 0
                  ? BoxDecoration(
                      color: appTheme.deepOrange500,
                      borderRadius: BorderRadius.circular(
                        16.h,
                      ))
                  : BoxDecoration(
                      color: appTheme.blueGray50,
                      borderRadius: BorderRadius.circular(
                        16.h,
                      ),
                    ),
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 14.h,
                  vertical: 4.h,
                ),
                child: Text(
                  "All Classes",
                ),
              ),
            ),
          ),
          Tab(
            height: 32,
            child: Container(
              alignment: AlignmentDirectional.center,
              decoration: tabIndex == 1
                  ? BoxDecoration(
                      color: appTheme.deepOrange500,
                      borderRadius: BorderRadius.circular(
                        16.h,
                      ))
                  : BoxDecoration(
                      color: appTheme.blueGray50,
                      borderRadius: BorderRadius.circular(
                        16.h,
                      ),
                    ),
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 14.h,
                  vertical: 4.h,
                ),
                child: Text(
                  "Cardio",
                ),
              ),
            ),
          ),
          Tab(
            height: 32,
            child: Container(
              alignment: AlignmentDirectional.center,
              decoration: tabIndex == 2
                  ? BoxDecoration(
                      color: appTheme.deepOrange500,
                      borderRadius: BorderRadius.circular(
                        16.h,
                      ))
                  : BoxDecoration(
                      color: appTheme.blueGray50,
                      borderRadius: BorderRadius.circular(
                        16.h,
                      ),
                    ),
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 14.h,
                  vertical: 4.h,
                ),
                child: Text(
                  "Strength",
                ),
              ),
            ),
          ),
          Tab(
            height: 32,
            child: Container(
              alignment: AlignmentDirectional.center,
              decoration: tabIndex == 3
                  ? BoxDecoration(
                      color: appTheme.deepOrange500,
                      borderRadius: BorderRadius.circular(
                        16.h,
                      ))
                  : BoxDecoration(
                      color: appTheme.blueGray50,
                      borderRadius: BorderRadius.circular(
                        16.h,
                      ),
                    ),
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 14.h,
                  vertical: 4.h,
                ),
                child: Text(
                  "Yoga",
                ),
              ),
            ),
          )
        ],
        indicatorColor: Colors.transparent,
        onTap: (index) {
          tabIndex = index;
          setState(() {});
        },
      ),
    );
  }
}

class ClasslistItemWidget extends StatelessWidget {
  const ClasslistItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.center,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        margin: EdgeInsetsDirectional.zero,
        color: appTheme.whiteA700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusStyle.roundedBorder8,
        ),
        child: Container(
          height: 106.h,
          decoration: AppDecoration.outlineBlack900.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder8,
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: 16.h,
                    top: 12.h,
                  ),
                  child: Text(
                    "Spinning",
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: 16.h,
                    top: 36.h,
                  ),
                  child: Text(
                    "08:00 - 09:00",
                    style: CustomTextStyles.bodyMediumGray60001ExtraLight,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: Container(
                            margin: EdgeInsetsDirectional.only(bottom: 10.h),
                            padding: EdgeInsetsDirectional.symmetric(
                                horizontal: 12.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgEllipse3382,
                                  height: 32.h,
                                  width: 34.h,
                                  radius: BorderRadius.circular(
                                    16.h,
                                  ),
                                  margin:
                                      EdgeInsetsDirectional.only(start: 6.h),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsetsDirectional.only(start: 10.h),
                                  child: Text(
                                    " Emma Wilson",
                                    style: CustomTextStyles.bodySmallExtraLight,
                                  ),
                                ),
                                Spacer(),
                                _buildBookButtonSpinning(context)
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: Container(
                  width: double.maxFinite,
                  margin: EdgeInsetsDirectional.only(
                    start: 6.h,
                    top: 12.h,
                    end: 6.h,
                  ),
                  child: Column(
                    spacing: 4,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "12 spots left",
                        style: CustomTextStyles.bodySmallGreen600,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(end: 16.h),
                        child: Text(
                          "45 min",
                          style: CustomTextStyles.bodySmallGray60001,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 6.h,
                  vertical: 10.h,
                ),
                decoration: AppDecoration.outlineBlack900.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder8,
                ),
                child: Column(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 2.h),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsetsDirectional.only(start: 14.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Spinning",
                                  style: theme.textTheme.titleMedium,
                                ),
                                Text(
                                  "08:00 - 09:00",
                                  style: CustomTextStyles
                                      .bodyMediumGray60001ExtraLight,
                                )
                              ],
                            ),
                          ),
                          Column(
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "12 spots left",
                                style: CustomTextStyles.bodySmallGreen600,
                              ),
                              Text(
                                "45 min",
                                style: CustomTextStyles.bodySmallGray60001,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsetsDirectional.only(
                        start: 10.h,
                        end: 4.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgEllipse3382,
                            height: 32.h,
                            width: 34.h,
                            radius: BorderRadius.circular(
                              16.h,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(start: 12.h),
                            child: Text(
                              " Emma Wilson",
                              style: CustomTextStyles.bodySmallExtraLight,
                            ),
                          ),
                          Spacer(),
                          _buildBookButtonYoga(context)
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
  Widget _buildBookButtonSpinning(BuildContext context) {
    return CustomElevatedButton(
      height: 30.h,
      width: 64.h,
      text: "Book",
      buttonStyle: CustomButtonStyles.fillDeepOrangeTL6,
      buttonTextStyle: CustomTextStyles.titleSmallInterWhiteA700,
    );
  }

  /// Section Widget
  Widget _buildBookButtonYoga(BuildContext context) {
    return CustomElevatedButton(
      height: 30.h,
      width: 64.h,
      text: "Book",
      buttonStyle: CustomButtonStyles.fillDeepOrangeTL6,
      buttonTextStyle: CustomTextStyles.titleSmallInterWhiteA700,
    );
  }
}

class GymclassesallTabPage extends StatefulWidget {
  const GymclassesallTabPage({Key? key})
      : super(
          key: key,
        );

  @override
  GymclassesallTabPageState createState() => GymclassesallTabPageState();
}

class GymclassesallTabPageState extends State<GymclassesallTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 8.h,
        vertical: 12.h,
      ),
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildClassList(context),
                  VerticalDivider(
                    width: 5.h,
                    thickness: 5.h,
                    color: theme.colorScheme.onPrimaryContainer,
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
  Widget _buildClassList(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: AlignmentDirectional.center,
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: 32.h,
            top: 24.h,
          ),
          child: ListView.separated(
            padding: EdgeInsetsDirectional.zero,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 12.h,
              );
            },
            itemCount: 7,
            itemBuilder: (context, index) {
              return ClasslistItemWidget();
            },
          ),
        ),
      ),
    );
  }
}
