import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../widgets.dart';
import '../models/class_model.dart';
import '../services/class_service.dart';
import '../services/auth_service.dart';
import '../responsive_utils.dart';
import 'package:intl/intl.dart';

class GymClassesPage extends StatefulWidget {
  const GymClassesPage({super.key});

  @override
  GymClassesPageState createState() => GymClassesPageState();
}

class GymClassesPageState extends State<GymClassesPage>
    with TickerProviderStateMixin {
  List<DateTime?> selectedDatesFromCalendar = [];
  List<GymClass> _classes = [];
  bool _isLoading = true;
  final ClassService _classService = ClassService();

  late TabController tabviewController;

  int tabIndex = 0;
  int selectedDateIndex = 0;

  // List of dates for the week
  List<DateTime> _weekDates = [];

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 4, vsync: this);

    // Initialize the week dates
    final today = DateTime.now();
    _weekDates = List.generate(
        7, (index) => DateTime(today.year, today.month, today.day + index));

    // Load classes for the selected date and tab
    _loadClasses();

    // Listen for tab changes
    tabviewController.addListener(() {
      if (tabviewController.indexIsChanging) {
        setState(() {
          tabIndex = tabviewController.index;
        });
        _loadClasses();
      }
    });
  }

  String _getClassTypeForTab(int tab) {
    switch (tab) {
      case 0:
        return 'All Classes';
      case 1:
        return 'Cardio';
      case 2:
        return 'Strength';
      case 3:
        return 'Yoga';
      default:
        return 'All Classes';
    }
  }

  Future<void> _loadClasses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final selectedDate = _weekDates[selectedDateIndex];
      final classType = _getClassTypeForTab(tabIndex);

      final classes =
          await _classService.getClassesByDateAndType(selectedDate, classType);

      setState(() {
        _classes = classes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _classes = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load classes: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
    Future<void> _bookClass(GymClass gymClass) async {
    try {
      // Get the current user data from AuthService
      final authService = AuthService();
      final userData = await authService.getUserDetails();
      
      if (userData == null || userData['id'] == null) {
        throw Exception('User not logged in or user ID not available');
      }
      
      // Get the user ID as a string
      final userId = userData['id'].toString();
      
      // Book the class and get updated class data
      await _classService.bookClass(gymClass.id, userId);
      
      // Always refresh the class list after booking
      await _loadClasses();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booked successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (e.toString().contains("Conflict") || e.toString().contains("already booked")) {
        // Refresh the class list to reflect booking state
        await _loadClasses();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You have already booked this class'),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to book class: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> _cancelBooking(GymClass gymClass) async {
    try {
      // Get the current user data from AuthService
      final authService = AuthService();
      final userData = await authService.getUserDetails();
      
      if (userData == null || userData['id'] == null) {
        throw Exception('User not logged in or user ID not available');
      }
      
      // Get the user ID as a string
      final userId = userData['id'].toString();
      await _classService.cancelBooking(gymClass.id, userId);

      // Always refresh the class list after cancelling
      await _loadClasses();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking cancelled'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to cancel booking: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadClasses();
        },
        color: appTheme.deepOrange500,
        backgroundColor: appTheme.whiteA700,
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                // Hero header section with motivational text
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Find your workout",
                        style: CustomTextStyles.displaySmallBlack900.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "Book your favorite classes today",
                        style: CustomTextStyles.bodyLargeBluegray70001.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                _buildDateSelector(context),
                SizedBox(height: 24.h),
                _buildTabview(context),
                SizedBox(height: 16.h),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: appTheme.gray100.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: TabBarView(
                        controller: tabviewController,
                        children: [
                          GymClassesTabPage(
                            classes: _classes,
                            isLoading: _isLoading,
                            onBookClass: _bookClass,
                            onCancelBooking: _cancelBooking,
                          ),
                          GymClassesTabPage(
                            classes: _classes,
                            isLoading: _isLoading,
                            onBookClass: _bookClass,
                            onCancelBooking: _cancelBooking,
                          ),
                          GymClassesTabPage(
                            classes: _classes,
                            isLoading: _isLoading,
                            onBookClass: _bookClass,
                            onCancelBooking: _cancelBooking,
                          ),
                          GymClassesTabPage(
                            classes: _classes,
                            isLoading: _isLoading,
                            onBookClass: _bookClass,
                            onCancelBooking: _cancelBooking,
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
      ),
    );
  }
  
  /// Section Widget - Improved modern date selector with animated selection
  Widget _buildDateSelector(BuildContext context) {
    // Use responsive_utils.dart helpers for adaptive sizing
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;
    // Removed unused isDesktop
    final itemWidth = isMobile ? 65.0 : (isTablet ? 75.0 : 85.0);
    final containerHeight = isMobile ? 90.0 : (isTablet ? 100.0 : 110.0);

    return Container(
      height: containerHeight,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _weekDates.length,
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        itemBuilder: (context, index) {
          final date = _weekDates[index];
          final dayName = DateFormat('E').format(date); // Short day name
          final dayNumber = date.day.toString();
          final monthName = DateFormat('MMM').format(date); // Short month name
          final isSelected = index == selectedDateIndex;
          final isToday = DateTime.now().day == date.day && 
                         DateTime.now().month == date.month &&
                         DateTime.now().year == date.year;

          // Responsive text sizes
          final dayNameSize = isMobile ? 12.0 : (isTablet ? 14.0 : 16.0);
          final dayNumberSize = isMobile ? 22.0 : (isTablet ? 24.0 : 26.0);
          final monthNameSize = isMobile ? 11.0 : (isTablet ? 12.0 : 14.0);

          return TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.8, end: 1.0),
            duration: Duration(milliseconds: 300 + (index * 50)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: itemWidth,
                  margin: EdgeInsets.symmetric(horizontal: 6.h),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDateIndex = index;
                      });
                      _loadClasses();
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: isSelected 
                          ? theme.colorScheme.primary
                          : isToday 
                            ? appTheme.gray100 
                            : appTheme.gray300.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16.h),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          )
                        ] : null,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Prevent overflow
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              dayName,
                              style: TextStyle(
                                fontSize: dayNameSize,
                                fontWeight: FontWeight.w500,                                color: isSelected
                                  ? appTheme.whiteA700
                                  : appTheme.blueGray700,
                              ),
                            ),
                            SizedBox(height: isMobile ? 3.h : 4.h),
                            Text(
                              dayNumber,
                              style: TextStyle(
                                fontSize: dayNumberSize,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                  ? appTheme.whiteA700
                                  : appTheme.black900,
                              ),
                            ),
                            SizedBox(height: isMobile ? 2.h : 3.h),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 2.h),
                              decoration: isToday && !isSelected ? BoxDecoration(
                                color: appTheme.deepOrange500.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8.h),
                              ) : null,
                              child: Text(
                                isToday ? "TODAY" : monthName,
                                style: TextStyle(
                                  fontSize: monthNameSize,
                                  fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected
                                    ? appTheme.whiteA700
                                    : isToday 
                                      ? appTheme.deepOrange500
                                      : appTheme.blueGray70001,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  
  /// Section Widget - Improved modern tab view with animated transitions
  Widget _buildTabview(BuildContext context) {
    // Calculate adaptive sizes based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth < 600 ? 14.0 : (screenWidth < 1200 ? 16.0 : 18.0);
    final tabPadding = screenWidth < 600 ? 12.0 : (screenWidth < 1200 ? 16.0 : 20.0);

    // Define tab options with icons
    final tabOptions = [
      {"text": "All Classes", "icon": Icons.calendar_view_day_rounded},
      {"text": "Cardio", "icon": Icons.directions_run_rounded},
      {"text": "Strength", "icon": Icons.fitness_center_rounded},
      {"text": "Yoga", "icon": Icons.self_improvement_rounded},
    ];

    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.h, bottom: 12.h),
            child: Text(
              "Choose a workout",
              style: CustomTextStyles.titleLargeInter.copyWith(
                fontSize: fontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TabBar(
            controller: tabviewController,
            isScrollable: true,
            tabAlignment: TabAlignment.start, // Left-align for modern look
            labelColor: appTheme.whiteA700,
            labelStyle: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelColor: appTheme.blueGray70001,
            unselectedLabelStyle: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicatorPadding: EdgeInsets.zero,
            tabs: List.generate(tabOptions.length, (index) {
              bool isSelected = tabIndex == index;
              return Tab(
                height: 40,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? appTheme.deepOrange500
                        : appTheme.blueGray50.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20.h),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: appTheme.deepOrange500.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: tabPadding,
                      vertical: 8.h,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tabOptions[index]["icon"] as IconData,
                          size: fontSize + 2,
                          color: isSelected
                              ? appTheme.whiteA700
                              : appTheme.blueGray70001,
                        ),
                        SizedBox(width: 8.h),
                        Text(
                          tabOptions[index]["text"] as String,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            indicatorColor: Colors.transparent,
            onTap: (index) {
              setState(() {
                tabIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}

class ClasslistItemWidget extends StatelessWidget {
  final GymClass gymClass;
  final Function(GymClass) onBookClass;
  final Function(GymClass) onCancelBooking;
  const ClasslistItemWidget({
    super.key,
    required this.gymClass,
    required this.onBookClass,
    required this.onCancelBooking,
  });

  // Map class types to appropriate icons
  IconData _getClassTypeIcon() {
    switch (gymClass.classType.toLowerCase()) {
      case 'cardio':
        return Icons.directions_run_rounded;
      case 'strength':
        return Icons.fitness_center_rounded;
      case 'yoga':
        return Icons.self_improvement_rounded;
      default:
        return Icons.fitness_center_rounded;
    }
  }
  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;
    // Responsive paddings and sizes
    final horizontalPadding = isMobile ? 8.0 : (isTablet ? 12.0 : 24.0);
    final verticalPadding = isMobile ? 4.0 : (isTablet ? 8.0 : 12.0);
    final minHeight = isMobile ? 110.0 : (isTablet ? 120.0 : 140.0);
    final borderRadius = isMobile ? 16.0 : (isTablet ? 20.0 : 24.0);
    final bookedFontSize = isMobile ? 10.0 : (isTablet ? 12.0 : 14.0);
    final bookedIconSize = isMobile ? 12.0 : (isTablet ? 14.0 : 16.0);

    return Align(
      alignment: AlignmentDirectional.center,
      child: Hero(
        tag: 'class-${gymClass.id}',
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 1,
          margin: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          color: appTheme.whiteA700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Container(
            constraints: BoxConstraints(
              minHeight: minHeight,
              maxWidth: double.infinity,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(
                colors: [appTheme.whiteA700, appTheme.gray100.withOpacity(0.3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Class type indicator - left side color band
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: gymClass.classType.toLowerCase() == 'cardio'
                          ? appTheme.deepOrange500
                          : gymClass.classType.toLowerCase() == 'strength'
                              ? appTheme.green600
                              : appTheme.orangeA70001,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        bottomLeft: Radius.circular(borderRadius),
                      ),
                    ),
                  ),
                ),
                // Main content
                Padding(
                  padding: EdgeInsets.fromLTRB(16.h, 16.h, 16.h, 16.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row with class name and availability
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Class type icon and name
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(isMobile ? 8 : 10),
                                  decoration: BoxDecoration(
                                    color: gymClass.classType.toLowerCase() == 'cardio'
                                        ? appTheme.deepOrange500.withOpacity(0.1)
                                        : gymClass.classType.toLowerCase() == 'strength'
                                            ? appTheme.green600.withOpacity(0.1)
                                            : appTheme.orangeA70001.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                                  ),
                                  child: Icon(
                                    _getClassTypeIcon(),
                                    color: gymClass.classType.toLowerCase() == 'cardio'
                                        ? appTheme.deepOrange500
                                        : gymClass.classType.toLowerCase() == 'strength'
                                            ? appTheme.green600
                                            : appTheme.orangeA70001,
                                    size: isMobile ? 22 : (isTablet ? 26 : 30),
                                  ),
                                ),
                                SizedBox(width: isMobile ? 12 : 16),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        gymClass.className,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: isMobile ? 16 : (isTablet ? 18 : 20),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: isMobile ? 4 : 6),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_rounded,
                                            size: isMobile ? 14 : 16,
                                            color: appTheme.blueGray70001,
                                          ),
                                          SizedBox(width: isMobile ? 4 : 6),
                                          Text(
                                            "${gymClass.startTime} - ${gymClass.endTime}",
                                            style: CustomTextStyles.bodyMediumGray60001ExtraLight.copyWith(
                                              fontSize: isMobile ? 12 : 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            " • ${gymClass.duration} min",
                                            style: CustomTextStyles.bodySmallGray60001.copyWith(
                                              fontSize: isMobile ? 11 : 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Availability indicator
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 14, vertical: isMobile ? 5 : 7),
                            decoration: BoxDecoration(
                              color: gymClass.isFull
                                  ? appTheme.red500.withOpacity(0.1)
                                  : gymClass.spotsLeft <= 3
                                      ? appTheme.orangeA70001.withOpacity(0.1)
                                      : appTheme.green600.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                              border: Border.all(
                                color: gymClass.isFull
                                    ? appTheme.red500.withOpacity(0.3)
                                    : gymClass.spotsLeft <= 3
                                        ? appTheme.orangeA70001.withOpacity(0.3)
                                        : appTheme.green600.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  gymClass.isFull
                                      ? Icons.person_off_outlined
                                      : gymClass.spotsLeft <= 3
                                          ? Icons.person_outline
                                          : Icons.group_outlined,
                                  size: isMobile ? 14 : 16,
                                  color: gymClass.isFull
                                      ? appTheme.red500
                                      : gymClass.spotsLeft <= 3
                                          ? appTheme.orangeA70001
                                          : appTheme.green600,
                                ),
                                SizedBox(width: isMobile ? 4 : 6),
                                Text(
                                  gymClass.isFull
                                      ? "Full"
                                      : "${gymClass.spotsLeft} spot${gymClass.spotsLeft > 1 ? 's' : ''}",
                                  style: TextStyle(
                                    fontSize: isMobile ? 12 : 14,
                                    fontWeight: FontWeight.w500,
                                    color: gymClass.isFull
                                        ? appTheme.red500
                                        : gymClass.spotsLeft <= 3
                                            ? appTheme.orangeA70001
                                            : appTheme.green600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isMobile ? 16 : 20),
                      // Instructor info and booking button
                      Row(
                        children: [
                          // Instructor avatar
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: appTheme.gray300.withOpacity(0.5),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
                            ),
                            child: gymClass.instructorImageUrl.isNotEmpty
                                ? CustomImageView(
                                    imagePath: gymClass.instructorImageUrl,
                                    height: isMobile ? 36 : 44,
                                    width: isMobile ? 36 : 44,
                                    radius: BorderRadius.circular(isMobile ? 18 : 22),
                                    fit: BoxFit.cover,
                                  )
                                : CircleAvatar(
                                    radius: isMobile ? 18 : 22,
                                    backgroundColor: appTheme.blueGray50,
                                    child: Text(
                                      gymClass.instructor.isNotEmpty
                                          ? gymClass.instructor[0]
                                          : '?',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: appTheme.blueGray700,
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(width: isMobile ? 10 : 14),
                          // Instructor name with leading text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Instructor",
                                  style: TextStyle(
                                    fontSize: isMobile ? 11 : 13,
                                    color: appTheme.blueGray70001.withOpacity(0.7),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: isMobile ? 2 : 4),
                                Text(
                                  gymClass.instructor,
                                  style: CustomTextStyles.bodyMediumWorkSans.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: isMobile ? 13 : 15,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _buildActionButton(context),
                    ],
                  ),
                ),
                // Booked indicator
                if (gymClass.isUserBooked)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: appTheme.green600,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          topRight: Radius.circular(borderRadius),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: bookedIconSize,
                            color: appTheme.whiteA700,
                          ),
                          SizedBox(width: 4.h),
                          Text(
                            "Booked",
                            style: TextStyle(
                              fontSize: bookedFontSize,
                              fontWeight: FontWeight.w500,
                              color: appTheme.whiteA700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// Section Widget - Modern action buttons with improved design
  Widget _buildActionButton(BuildContext context) {
    if (gymClass.isUserBooked) {
      return SizedBox(
        height: 36.h,
        child: ElevatedButton.icon(
          icon: Icon(
            Icons.close_rounded,
            size: 16,
          ),
          label: Text("Cancel"),
          style: ElevatedButton.styleFrom(
            backgroundColor: appTheme.blueGray50,
            foregroundColor: appTheme.blueGray70001,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            textStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: appTheme.gray300, width: 1),
            ),
          ),
          onPressed: () => onCancelBooking(gymClass),
        ),
      );
    } else if (gymClass.isFull) {
      return SizedBox(
        height: 36.h,
        child: ElevatedButton.icon(
          icon: Icon(
            Icons.block_rounded,
            size: 16,
          ),
          label: Text("Full"),
          style: ElevatedButton.styleFrom(
            backgroundColor: appTheme.red500.withOpacity(0.08),
            foregroundColor: appTheme.red500,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            textStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: null, // Disabled button
        ),
      );
    } else {
      return SizedBox(
        height: 36.h,
        child: ElevatedButton.icon(
          icon: Icon(
            Icons.add_rounded,
            size: 18,
          ),
          label: Text("Book"),
          style: ElevatedButton.styleFrom(
            backgroundColor: appTheme.deepOrange500,
            foregroundColor: appTheme.whiteA700,
            elevation: 2,
            shadowColor: appTheme.deepOrange500.withOpacity(0.3),
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: () => onBookClass(gymClass),
        ),
      );
    }
  }
}

class GymClassesTabPage extends StatelessWidget {
  final List<GymClass> classes;
  final bool isLoading;
  final Function(GymClass) onBookClass;
  final Function(GymClass) onCancelBooking;
  const GymClassesTabPage({
    super.key,
    required this.classes,
    required this.isLoading,
    required this.onBookClass,
    required this.onCancelBooking,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 600 ? 8.0 : (screenWidth < 1200 ? 12.0 : 16.0);

    if (isLoading) {
      return _buildLoadingState();
    }

    if (classes.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 12.h,
      ),
      child: _buildClassList(context),
    );
  }

  /// Loading state with smooth animation
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              strokeWidth: 3,              valueColor: AlwaysStoppedAnimation<Color>(appTheme.deepOrange500),
              backgroundColor: appTheme.deepOrange500.withOpacity(0.2),
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Loading classes...", 
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: appTheme.blueGray70001,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Empty state with visual feedback
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 70,
            color: appTheme.blueGray100,
          ),
          SizedBox(height: 16),
          Text(
            "No classes available",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: appTheme.blueGray70001,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Try another date or class type",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: appTheme.blueGray70001.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  /// Section Widget - Improved class list with animation
  Widget _buildClassList(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = screenWidth < 600 ? 8.0 : 16.0;

    return ListView.builder(      padding: EdgeInsets.only(top: topPadding, bottom: 20),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true, // Add this to prevent unbounded height issue
      primary: false, // This helps with nested scroll views
      itemCount: classes.length,
      itemBuilder: (context, index) {
        // Add staggered animation effect
        return AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: 1.0,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 300 + (index * 50)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: ClasslistItemWidget(
              gymClass: classes[index],
              onBookClass: onBookClass,
              onCancelBooking: onCancelBooking,
            ),
          ),
        );
      },
    );
  }
}
