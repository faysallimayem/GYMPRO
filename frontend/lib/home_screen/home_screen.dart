import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../gym_classes_page/gym_classes_page.dart';
import '../responsive_utils.dart';
import '../routes/app_routes.dart';
import '../services/navigation_provider.dart';
import '../services/user_provider.dart';
import '../user_profile_page/user_profile_page.dart';
import '../widgets.dart';
import '../workouts_page/workouts_page.dart';
import '../nutrition_screen/nutrition_screen.dart';
import '../models/step_metrics.dart';
import '../models/supplement.dart';
import '../models/workout.dart';
import '../services/step_tracking_service.dart';
import '../widgets/step_counter_widget.dart';
import './home_screen_provider.dart';
import '../chat_screen/conversation_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeInitialPage(),
    WorkoutsPage(),
    NutritionScreen(),
    GymClassesPage(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _selectedIndex != 4 ? _buildAppBar(context) : null, // Don't show app bar on profile page which has its own
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          decoration: AppDecoration.outlineOnPrimaryContainer,
          child: _pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.maxFinite,
        margin: EdgeInsetsDirectional.only(
          start: 10.h,
          end: 10.h,
          bottom: 10.h,
        ),
        child: _buildBottombar(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: appTheme.deepOrange500,
      elevation: 0,
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "GYM",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                letterSpacing: 1.2,
              ),
            ),
            TextSpan(
              text: " PRO",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w300,
                fontFamily: 'Poppins',
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
      actions: [
        // User profile icon
        InkWell(
          onTap: () {
            setState(() {
              _selectedIndex = 4; // Switch to profile tab
            });
            Provider.of<NavigationProvider>(context, listen: false)
                .setCurrentRoute(AppRoutes.userProfilePage);
          },
          child: Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildBottombar(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, _) {
        return SizedBox(
          width: double.maxFinite,
          child: CustomBottomBar(
            onChanged: (BottomBarEnum type) {
              // Set current route in navigation provider
              String route = navigationProvider.getRouteForType(type);
              navigationProvider.setCurrentRoute(route);
              
              // Update the selected index to show the right page
              setState(() {
                switch (type) {
                  case BottomBarEnum.Home:
                    _selectedIndex = 0;
                    break;
                  case BottomBarEnum.Maximize:
                    _selectedIndex = 1;
                    break;
                  case BottomBarEnum.Medicaliconinutrition:
                    _selectedIndex = 2;
                    break;
                  case BottomBarEnum.Calendar:
                    _selectedIndex = 3;
                    break;
                  case BottomBarEnum.Lockgray600:
                    _selectedIndex = 4;
                    break;
                }
              });
            },
          ),
        );
      }
    );
  }
}

class HomeThreeItemWidget extends StatelessWidget {
  const HomeThreeItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 6.h,
        vertical: 8.h,
      ),
      decoration: AppDecoration.outline2.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      child: Column(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Your next workout:",
            style: CustomTextStyles.titleMediumTTCommonsPrimary,
          ),
          Text(
            "Push ups",
            style: CustomTextStyles.titleLargePoppins,
          ),
          Container(
            width: double.maxFinite,
            margin: EdgeInsetsDirectional.only(end: 12.h),
            child: Row(
              children: [
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Duration:",
                      style: CustomTextStyles.bodyMediumTTCommons,
                    ),
                    Text(
                      "30 minutes",
                      style: theme.textTheme.titleSmall,
                    )
                  ],
                ),
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reps:",
                      style: CustomTextStyles.bodyMediumTTCommons,
                    ),
                    Text(
                      "115",
                      style: theme.textTheme.titleSmall,
                    )
                  ],
                ),
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sets:",
                      style: CustomTextStyles.bodyMediumTTCommons,
                    ),
                    Text(
                      "15",
                      style: theme.textTheme.titleSmall,
                    )
                  ],
                ),
                Expanded(
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Exercise:",
                        style: CustomTextStyles.bodyMediumTTCommons,
                      ),
                      Text(
                        "5",
                        style: theme.textTheme.titleSmall,
                      )
                    ],
                  ),
                ),
                CustomOutlinedButton(
                  height: 30.h,
                  width: 90.h,
                  text: "Start workout",
                  buttonStyle: CustomButtonStyles.none,
                  decoration: CustomButtonStyles.outlineDecoration,
                  buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HomeFourItemWidget extends StatelessWidget {
  const HomeFourItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgEllipse10,
          height: 100.h,
          width: 100.h,
          radius: BorderRadius.circular(
            50.h,
          ),
        ),
        Text(
          "Sarah",
          style: CustomTextStyles.titleLargePoppins,
        )
      ],
    );
  }
}

class HomeInitialPage extends StatefulWidget {
  const HomeInitialPage({super.key});

  @override
  HomeInitialPageState createState() => HomeInitialPageState();
}

class HomeInitialPageState extends State<HomeInitialPage> {
  late StepTrackingService _stepTrackingService;
  late HomeScreenProvider _provider;
  
  @override
  void initState() {
    super.initState();
    _stepTrackingService = StepTrackingService();
    _stepTrackingService.init();
    
    // Initialize the provider
    _provider = Provider.of<HomeScreenProvider>(context, listen: false);
    
    // Use Future.microtask to avoid calling setState during build
    Future.microtask(() {
      _provider.refreshData();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(
      builder: (context, provider, _) {
        return provider.isLoading
            ? _buildLoadingView()
            : provider.error != null
                ? _buildErrorView(provider.error!)
                : _buildHomeContent(provider);
      },
    );
  }
  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: appTheme.deepOrange500),
          SizedBox(height: 16),
          Text(
            'Loading your fitness data...',
            style: TextStyle(
              fontSize: context.responsiveFontSize(16),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
          SizedBox(height: 16),          Text(
            'Oops! Something went wrong.',
            style: TextStyle(
              fontSize: context.responsiveFontSize(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: context.responsiveFontSize(14),
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.deepOrange500,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => _provider.refreshData(),
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(HomeScreenProvider provider) {
    return RefreshIndicator(
      color: appTheme.deepOrange500,
      onRefresh: provider.refreshData,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: [
            // Background top gradient
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    appTheme.deepOrange500,
                    appTheme.deepOrange500.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            
            // Content
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Content
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24.h),
                        
                        // Greeting Section with modern card design
                        _buildGreetingSection(),
                        SizedBox(height: 24.h),
                        
                        // Step Counter Widget with shadow and rounded corners
                        StepCounterWidget(
                          metrics: provider.stepMetrics,
                          onTap: () {
                            _showUpdateStepGoalDialog(provider);
                          },
                        ),
                        SizedBox(height: 24.h),
                        
                        // Recent Workouts - Visual cards with icons
                        if (provider.recentWorkouts.isNotEmpty)
                          _buildRecentWorkoutsSection(provider.recentWorkouts),
                        SizedBox(height: 24.h),
                        
                        // Quick Access Section with modern design
                        _buildQuickAccessSection(),
                        SizedBox(height: 24.h),
                        
                        // Featured Supplements Section
                        if (provider.featuredSupplements.isNotEmpty)
                          _buildFeaturedSupplementsSection(provider.featuredSupplements),
                        
                        SizedBox(height: 30.h), // Bottom padding
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGreetingSection() {
    final greeting = _getGreeting();
    final username = Provider.of<UserProvider>(context).username;
    
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: appTheme.deepOrange500.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.wb_sunny_rounded,
                  color: appTheme.deepOrange500,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: TextStyle(
                      fontSize: context.responsiveFontSize(14),
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    username,
                    style: TextStyle(
                      fontSize: context.responsiveFontSize(20),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 20),
          
          // Quick stat summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Workouts', '12', Icons.fitness_center),
              _buildStatDivider(),
              _buildStatItem('Classes', '5', Icons.group),
              _buildStatDivider(),
              _buildStatItem('Streak', '7', Icons.local_fire_department),
            ],
          ),
          
          SizedBox(height: 20),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Start Workout', 
                  Icons.play_circle_fill_rounded,
                  () => Navigator.pushNamed(context, AppRoutes.workoutsPage),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildActionButton(
                  'Find Class', 
                  Icons.event_available_rounded,
                  () => Navigator.pushNamed(context, AppRoutes.gymClassesPage),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: appTheme.deepOrange500,
          size: 22,
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: context.responsiveFontSize(16),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: context.responsiveFontSize(12),
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[300],
    );
  }
  
  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: appTheme.deepOrange500,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: context.responsiveFontSize(14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Access",
          style: TextStyle(
            fontSize: context.responsiveFontSize(18),
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 16.h),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.h,
          childAspectRatio: 1.0,
          padding: EdgeInsets.zero,
          children: [
            _buildQuickAccessItem(
              "Workouts",
              Icons.fitness_center_rounded,
              [Color(0xFF4A6FFF), Color(0xFF0044FF)],
              () => Navigator.pushNamed(context, AppRoutes.workoutsPage),
            ),
            _buildQuickAccessItem(
              "Nutrition",
              Icons.restaurant_menu_rounded,
              [Color(0xFF5CAF6C), Color(0xFF2F9A49)],
              () => Navigator.pushNamed(context, AppRoutes.nutritionScreen),
            ),            // Tender card for clients with active memberships
            _buildQuickAccessItem(
              "Tenders",
              Icons.campaign_rounded,
              [Color(0xFFFBBC05), Color(0xFFF57C00)],
              () {
                // Use the proper AppRoutes constant
                Navigator.pushNamed(context, AppRoutes.tenderScreen);
              },
            ),
            _buildQuickAccessItem(
              "Classes",
              Icons.group_rounded,
              [Color(0xFF9C56FF), Color(0xFF7317DF)],
              () => Navigator.pushNamed(context, AppRoutes.gymClassesPage),
            ),
            _buildQuickAccessItem(
              "Supplements",
              Icons.medication_rounded,
              [Color(0xFFFF5660), Color(0xFFE0232E)],
              () {
                print("Navigating to supplements screen from View All");
                Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.supplementsScreen);
              },
            ),
            _buildQuickAccessItem(
              "Messages",
              Icons.chat_bubble_outline_rounded,
              [Color(0xFF56C0FF), Color(0xFF0A96DF)],
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConversationListScreen(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAccessItem(String title, IconData icon, List<Color> gradientColors, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.3),
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32.h,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFontSize(13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentWorkoutsSection(List<Workout> recentWorkouts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Workouts",
              style: TextStyle(
                fontSize: context.responsiveFontSize(18),
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.workoutsPage),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                children: [
                  Text(
                    "View All",
                    style: TextStyle(
                      color: appTheme.deepOrange500,
                      fontSize: context.responsiveFontSize(14),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: appTheme.deepOrange500,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        
        // For the most recent workout, show a featured card
        if (recentWorkouts.isNotEmpty)
          _buildFeaturedWorkoutCard(recentWorkouts.first),
          
        SizedBox(height: 16.h),
        
        // For remaining workouts, show in a list
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: recentWorkouts.length > 1 ? recentWorkouts.length - 1 : 0,
          itemBuilder: (context, index) {
            final workout = recentWorkouts[index + 1];
            return _buildWorkoutItem(workout);
          },
        ),
      ],
    );
  }
  
  Widget _buildFeaturedWorkoutCard(Workout workout) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.workoutDetailsScreen,
          arguments: workout.id,
        );
      },
      child: Container(
        width: double.infinity,
        height: 160.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              appTheme.deepOrange500,
              Color(0xFFFF8956),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: appTheme.deepOrange500.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.workoutDetailsScreen,
                arguments: workout.id,
              );
            },
            child: Stack(
              children: [
                // Pattern overlay for visual interest
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                
                // Workout details
                Padding(
                  padding: EdgeInsets.all(20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Last Workout",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: context.responsiveFontSize(14),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            workout.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: context.responsiveFontSize(22),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      
                      Row(
                        children: [
                          _buildWorkoutStat(
                            "${workout.exercises.length}",
                            "Exercises",
                            Icons.fitness_center_rounded,
                          ),
                          SizedBox(width: 24),
                          if (workout.duration != null)
                            _buildWorkoutStat(
                              "${workout.duration}",
                              "Minutes",
                              Icons.timer_rounded,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Play icon overlay
                Positioned(
                  right: 20,
                  top: 20,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 24,
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
  
  Widget _buildWorkoutStat(String value, String label, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 16,
        ),
        SizedBox(width: 8),
        Text(
          "$value $label",
          style: TextStyle(
            color: Colors.white,
            fontSize: context.responsiveFontSize(14),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  Widget _buildWorkoutItem(Workout workout) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: appTheme.deepOrange500.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.fitness_center_rounded,
            color: appTheme.deepOrange500,
          ),
        ),
        title: Text(
          workout.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: context.responsiveFontSize(16),
          ),
        ),
        subtitle: Text(
          "${workout.exercises.length} exercises${workout.duration != null ? ' • ${workout.duration} mins' : ''}",
          style: TextStyle(
            fontSize: context.responsiveFontSize(14),
            color: Colors.grey[600],
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: appTheme.deepOrange500.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.play_arrow_rounded,
              color: appTheme.deepOrange500,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.workoutDetailsScreen,
                arguments: workout.id,
              );
            },
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.workoutDetailsScreen,
            arguments: workout.id,
          );
        },
      ),
    );
  }

  Widget _buildFeaturedSupplementsSection(List<Supplement> supplements) {
    if (supplements.isEmpty) {
      return SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Featured Supplements",
              style: TextStyle(
                fontSize: context.responsiveFontSize(18),
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            TextButton(
              onPressed: () {
                print("Navigating to supplements screen from View All");
                Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.supplementsScreen);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                children: [
                  Text(
                    "View All",
                    style: TextStyle(
                      color: appTheme.deepOrange500,
                      fontSize: context.responsiveFontSize(14),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: appTheme.deepOrange500,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        
        // Horizontal scrolling supplements with modern design
        SizedBox(
          height: 220.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: supplements.length,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 4),
            itemBuilder: (context, index) {
              final supplement = supplements[index];
              return _buildSupplementCard(supplement);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildSupplementCard(Supplement supplement) {
    final cardWidth = 160.h;
    
    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(right: 16.h, bottom: 4, top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Navigate to supplement screen
              print("Navigating to supplements screen from card");
              Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.supplementsScreen);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with gradient overlay
                Stack(
                  children: [
                    Container(
                      height: cardWidth * 0.8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: supplement.imageUrl != null
                          ? Hero(
                              tag: 'supplement_${supplement.id}',
                              child: Image.network(
                                supplement.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.image_not_supported_rounded,
                                      color: Colors.grey[400],
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.fitness_center_rounded,
                                color: Colors.grey[400],
                                size: 36,
                              ),
                            ),
                    ),
                    // Category badge
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: appTheme.deepOrange500,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          supplement.category ?? 'Supplement',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: context.responsiveFontSize(10),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Details
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supplement.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: context.responsiveFontSize(14),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${supplement.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: appTheme.deepOrange500,
                              fontWeight: FontWeight.w800,
                              fontSize: context.responsiveFontSize(14),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: appTheme.deepOrange500,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
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
        ),
      ),
    );
  }

  void _showUpdateStepGoalDialog(HomeScreenProvider provider) async {
    // Create a new StepMetrics instance for demonstration if needed
    StepMetrics currentMetrics = provider.stepMetrics;
    final TextEditingController controller = TextEditingController(
      text: currentMetrics.goal.toString(),
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: appTheme.deepOrange500.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.directions_walk_rounded,
                        color: appTheme.deepOrange500,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Daily Step Goal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: context.responsiveFontSize(18),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                
                // Description
                Text(
                  'Set your daily step goal. The recommended amount is 10,000 steps per day for an active lifestyle.',
                  style: TextStyle(
                    fontSize: context.responsiveFontSize(14),
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 24),
                
                // Input field
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Step Goal',
                    hintText: 'Enter your daily step goal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: appTheme.deepOrange500,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.directions_walk_rounded,
                      color: appTheme.deepOrange500,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: appTheme.deepOrange500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appTheme.deepOrange500,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          try {
                            final newGoal = int.parse(controller.text);
                            if (newGoal > 0) {
                              provider.updateStepGoal(newGoal);
                              Navigator.pop(context);
                            } else {
                              _showErrorSnackBar('Please enter a value greater than 0');
                            }
                          } catch (e) {
                            _showErrorSnackBar('Please enter a valid number');
                          }
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: context.responsiveFontSize(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}
