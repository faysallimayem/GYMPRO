// ignore_for_file: depend_on_referenced_packages, use_super_parameters, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../widgets.dart';
import 'package:intl/intl.dart';

class GymClassesPage extends StatefulWidget {
  const GymClassesPage({Key? key})
      : super(
          key: key,
        );

  @override
  GymClassesPageState createState() => GymClassesPageState();
}

class GymClassesPageState extends State<GymClassesPage>
    with TickerProviderStateMixin {
  List<DateTime?> selectedDatesFromCalendar = [];

  late TabController tabviewController;

  int tabIndex = 0;

  int selectedDateIndex = 0;

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 4, vsync: this);
  }

  /// Build the app bar for the gym classes page
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 52.h,
      centerTitle: true, // Center the title
      title: AppbarSubtitle(
        text: "classes",
      ),
      // Remove the styleType to eliminate the grey line
    );
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
  Widget _buildDateSelector(BuildContext context) {
    // Get the current date
    final today = DateTime.now();
    
    // Create list of dates for the next 7 days
    final dates = List.generate(
      7, 
      (index) => today.add(Duration(days: index))
    );
    
    // Calculate adaptive size based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth < 600 ? 70.0 : (screenWidth < 1200 ? 80.0 : 90.0);
    final containerHeight = screenWidth < 600 ? 110.0 : (screenWidth < 1200 ? 120.0 : 130.0);
    
    return Container(
      height: containerHeight,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        padding: EdgeInsets.symmetric(horizontal: 12.h),
        itemBuilder: (context, index) {
          final date = dates[index];
          final dayName = DateFormat('E').format(date); // Short day name
          final dayNumber = date.day.toString();
          final monthName = DateFormat('MMM').format(date); // Short month name
          
          final isSelected = index == selectedDateIndex;
          
          // Calculate text sizes based on screen width
          final dayNameSize = screenWidth < 600 ? 12.0 : (screenWidth < 1200 ? 14.0 : 16.0);
          final dayNumberSize = screenWidth < 600 ? 20.0 : (screenWidth < 1200 ? 22.0 : 24.0);
          final monthNameSize = screenWidth < 600 ? 12.0 : (screenWidth < 1200 ? 14.0 : 16.0);
          
          return Container(
            width: itemWidth,
            margin: EdgeInsets.symmetric(horizontal: 5.h),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedDateIndex = index;
                });
              },
              child: AspectRatio(
                aspectRatio: 1.0, // Keep it circular
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? theme.colorScheme.primary : appTheme.gray300,
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayName,
                        style: TextStyle(
                          fontSize: dayNameSize,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? appTheme.whiteA700 : appTheme.black900,
                        ),
                      ),
                      SizedBox(height: screenWidth < 600 ? 1.h : 2.h),
                      Text(
                        dayNumber,
                        style: TextStyle(
                          fontSize: dayNumberSize,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? appTheme.whiteA700 : appTheme.black900,
                        ),
                      ),
                      SizedBox(height: screenWidth < 600 ? 1.h : 2.h),
                      Text(
                        monthName,
                        style: TextStyle(
                          fontSize: monthNameSize,
                          fontWeight: FontWeight.w400,
                          color: isSelected ? appTheme.whiteA700 : appTheme.black900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildTabview(BuildContext context) {
    // Calculate adaptive sizes based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth < 600 ? 14.0 : (screenWidth < 1200 ? 16.0 : 18.0);
    final tabPadding = screenWidth < 600 ? 10.0 : (screenWidth < 1200 ? 14.0 : 18.0);
    
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      child: TabBar(
        controller: tabviewController,
        isScrollable: true,
        tabAlignment: TabAlignment.center, // Center the tabs
        labelColor: appTheme.whiteA700,
        labelStyle: TextStyle(
          fontSize: fontSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        unselectedLabelColor: appTheme.black900,
        unselectedLabelStyle: TextStyle(
          fontSize: fontSize,
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
                padding: EdgeInsets.symmetric(
                  horizontal: tabPadding,
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
                padding: EdgeInsets.symmetric(
                  horizontal: tabPadding,
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
                padding: EdgeInsets.symmetric(
                  horizontal: tabPadding,
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
                padding: EdgeInsets.symmetric(
                  horizontal: tabPadding,
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
        margin: EdgeInsets.symmetric(horizontal: 8.h),
        color: appTheme.whiteA700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusStyle.roundedBorder8,
        ),
        child: Container(
          constraints: BoxConstraints(minHeight: 90.h),
          decoration: AppDecoration.outlineBlack900.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder8,
          ),
          child: Padding(
            padding: EdgeInsets.all(12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Spinning",
                            style: theme.textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "08:00 - 09:00",
                            style: CustomTextStyles.bodyMediumGray60001ExtraLight,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "12 spots left",
                          style: CustomTextStyles.bodySmallGreen600,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "45 min",
                          style: CustomTextStyles.bodySmallGray60001,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgEllipse3382,
                            height: 30.h,
                            width: 30.h,
                            radius: BorderRadius.circular(15.h),
                          ),
                          SizedBox(width: 10.h),
                          Expanded(
                            child: Text(
                              "Emma Wilson",
                              style: CustomTextStyles.bodySmallExtraLight,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildBookButton(context)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildBookButton(BuildContext context) {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 600 ? 8.0 : (screenWidth < 1200 ? 12.0 : 16.0);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 12.h,
      ),
      child: _buildClassList(context),
    );
  }

  /// Section Widget
  Widget _buildClassList(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = screenWidth < 600 ? 16.0 : 24.0;
    
    return ListView.separated(
      padding: EdgeInsets.only(top: topPadding),
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
    );
  }
}
