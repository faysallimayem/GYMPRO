import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../services/workout_service.dart';
import '../services/coach_service.dart';
import '../widgets.dart';
import '../services/user_provider.dart';
import '../models/coach_model.dart';
import '../workout_details_screen/workout_details_screen.dart';
import '../services/navigation_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/gym_pro_logo.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  bool isLoading = false;
  String? error;
  // Add a refresh controller
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // Fetch workouts when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWorkouts();
    });
  }

  // Combine fetchWorkouts and refreshWorkouts into one method
  Future<void> _fetchWorkouts() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final workoutService =
          Provider.of<WorkoutService>(context, listen: false);
      await workoutService.fetchWorkouts();
    } catch (e) {
      setState(() {
        error = 'Failed to load workouts: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            color: theme.colorScheme.primary,
            onRefresh: _fetchWorkouts,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsetsDirectional.only(top: 12.h),
                child: Column(
                  spacing: 14,
                  children: [
                    _buildHeaderSection(context),
                    _buildMuscleGroupsSection(context),
                    _buildWorkoutsGrid(context),
                    _buildCoachesSection(context),
                    SizedBox(height: 18.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildHeaderSection(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userName = userProvider.username;

    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(
        start: 10.h,
        end: 6.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsetsDirectional.symmetric(horizontal: 10.h),
                    decoration: AppDecoration.fillGray.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [                        Container(
                          width: double.maxFinite,
                          padding: EdgeInsetsDirectional.only(start: 12.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadiusStyle.roundedBorder8,
                          ),
                          child: Column(
                            spacing: 4,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GymProLogo(
                                size: 22.h,
                              ),
                              Container(
                                height: 200.h, // Adjust height as needed
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage(ImageConstant.imgRectangle37),
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.4), 
                                      BlendMode.darken
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Welcome to the workout section",
                                        style: TextStyle(
                                          fontSize: 24.h,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        "$userName",
                                        style: TextStyle(
                                          fontSize: 28.h,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 26.h),
                ],
              ),
            ),
          ),
          VerticalDivider(
            width: 5.h,
            thickness: 5.h,
            color: theme.colorScheme.onPrimaryContainer,
            indent: 132.h,
          )
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String errorMessage) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.h),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 8.h),
          Expanded(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: theme.colorScheme.primary),
            onPressed: _fetchWorkouts,
          )
        ],
      ),
    );
  }


  void _navigateToWorkoutDetails(int workoutId) {
    // Use direct navigation with MaterialPageRoute instead of Navigator.pushNamed
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => WorkoutDetailsScreen(workoutId: workoutId),
    ));
  }

  /// Section Widget
  Widget _buildWorkoutsGrid(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 10.h,
        end: 16.h,
      ),
      child: Consumer<WorkoutService>(
        builder: (context, workoutService, child) {
          // Display any errors from the workout service
          if (error != null) {
            return _buildErrorMessage(error!);
          }
          
          if (workoutService.isLoading &&
              workoutService.favoriteWorkouts.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child:
                    CircularProgressIndicator(color: theme.colorScheme.primary),
              ),
            );
          }

          final workouts = workoutService.favoriteWorkouts;

          // Use MediaQuery to determine screen width and adjust grid accordingly
          final screenWidth = MediaQuery.of(context).size.width;
          final crossAxisCount =
              screenWidth < 600 ? 2 : (screenWidth < 1200 ? 3 : 4);
          final aspectRatio = screenWidth < 600 ? 0.8 : 0.9;

          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10.h,
              mainAxisSpacing: 10.h,
              childAspectRatio: aspectRatio,
            ),
            itemCount: workouts.isEmpty ? 1 : workouts.length,
            itemBuilder: (context, index) {
              if (workouts.isEmpty) {
                return _buildAddWorkoutCard(context);
              } else {
                return WorkoutsgridItem(
                  workout: workouts[index],
                  onTap: () => _navigateToWorkoutDetails(workouts[index]['id']),
                  onRemove: () => _removeFromFavorites(workouts[index]['id']),
                );
              }
            },
          );
        },
      ),
    );
  }

  void _removeFromFavorites(int workoutId) {
    final workoutService = Provider.of<WorkoutService>(context, listen: false);
    workoutService.removeFromFavorites(workoutId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Workout removed from favorites"),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            final removedWorkout =
                workoutService.workouts.firstWhere((w) => w['id'] == workoutId);
            workoutService.addToFavorites(removedWorkout);
          },
        ),
      ),
    );
  }

  Widget _buildAddWorkoutCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to browse workouts page
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Browse Workouts"),
            content: Text(
                "This feature will allow you to browse the workout library and add more workouts to your favorites."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
      },
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsetsDirectional.all(14.h),
        decoration: AppDecoration.fillBlueGray.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 48.h,
              color: theme.colorScheme.primary,
            ),
            SizedBox(height: 10.h),
            Text(
              "Add New Workout",
              style: CustomTextStyles.titleMediumPoppinsPrimary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  /// Section Widget
  Widget _buildCoachesSection(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final gymId = userProvider.gymId;
    
    // If user is not a gym member or gymId is null, don't show coaches section
    if (!userProvider.isGymMember || gymId == null) {
      return SizedBox.shrink();
    }
    
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.only(start: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(start: 4.h),
            child: Text(
              "Coaches",
              style: CustomTextStyles.headlineSmallPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          FutureBuilder<List<Coach>>(
            future: CoachService().getCoachesByGymId(gymId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 100.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Container(
                  padding: EdgeInsets.all(10.h),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red),
                      SizedBox(width: 8.h),
                      Expanded(
                        child: Text(
                          "Failed to load coaches: ${snapshot.error}",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(16.h),
                  child: Text(
                    "No coaches available for this gym yet.",
                    style: CustomTextStyles.bodyMediumRegular,
                  ),
                );
              }
              
              final coaches = snapshot.data!;
              return Container(
                height: 120.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 4.h),
                  itemCount: coaches.length,
                  separatorBuilder: (context, index) => SizedBox(width: 14.h),
                  itemBuilder: (context, index) {
                    final coach = coaches[index];
                    // Only allow navigation if coach is not null
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/coach_profile_screen',
                          arguments: {'coachId': coach.id, 'gymId': gymId},
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 80.h,
                            width: 80.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              image: coach.photoUrl != null && coach.photoUrl!.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(coach.photoUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              color: coach.photoUrl == null || coach.photoUrl!.isEmpty
                                  ? appTheme.deepOrange500.withOpacity(0.1)
                                  : null,
                            ),
                            child: coach.photoUrl == null || coach.photoUrl!.isEmpty
                                ? Center(
                                    child: Text(
                                      coach.firstName.isNotEmpty && coach.lastName.isNotEmpty
                                          ? "${coach.firstName[0]}${coach.lastName[0]}"
                                          : "C",
                                      style: TextStyle(
                                        fontSize: 24.h,
                                        color: appTheme.deepOrange500,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            coach.firstName.isNotEmpty ? coach.firstName : "Coach",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: CustomTextStyles.titleSmallInterBluegray70001,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Muscle Groups Section
  Widget _buildMuscleGroupsSection(BuildContext context) {
    final muscleGroups = [
      {
        'name': 'Chest & Arms',
        'image': ImageConstant.imgRectangle188,
        'query': 'chest-arms'
      },
      {
        'name': 'Legs & Core',
        'image': ImageConstant.imgRectangle190,
        'query': 'legs-core'
      },
      {
        'name': 'Back & Shoulders',
        'image': ImageConstant.imgRectangle194,
        'query': 'back-shoulders'
      },
      {
        'name': 'Full Body',
        'image': ImageConstant.imgRectangle192,
        'query': 'full body'
      },
    ];

    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 10.h, end: 10.h, top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Muscle Groups",
            style: CustomTextStyles.headlineSmallWorkSansSemiBold,
          ),
          SizedBox(height: 12.h),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.h,
              mainAxisSpacing: 10.h,
              childAspectRatio: 1.2,
            ),
            itemCount: muscleGroups.length,
            itemBuilder: (context, index) {
              final group = muscleGroups[index];
              return GestureDetector(
                onTap: () {
                  // Use navigation provider for direct navigation
                  navigationProvider.navigateDirectly(
                    context,
                    WorkoutDetailsScreen(
                      queryFilter: group['query'] as String,
                    ),
                    AppRoutes.workoutDetailsScreen
                  );

                  print('Navigating to muscle group: ${group['query']}');
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.h),
                    image: DecorationImage(
                      image: AssetImage(group['image'] as String),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.all(8.h),
                  child: Text(
                    group['name'] as String,
                    style: CustomTextStyles.titleLargeInterWhiteA700SemiBold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ListpushUpsItem extends StatelessWidget {
  final Map<String, dynamic> workout;
  final VoidCallback? onTap;

  const ListpushUpsItem({
    super.key,
    required this.workout,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = workout['name'] ?? 'Workout';
    final duration = workout['duration'] ?? 30;

    // Calculate some stats based on the exercises
    final exercises = (workout['exercises'] as List?)?.length ?? 0;
    final reps = 10 * exercises; // Just a placeholder calculation
    final sets = 3; // Default placeholder

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 172.h,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgClock,
              height: 6.h,
              width: 8.h,
              alignment: AlignmentDirectional.bottomStart,
              margin: EdgeInsetsDirectional.only(
                start: 44.h,
                bottom: 56.h,
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 6.h,
                vertical: 8.h,
              ),
              decoration: AppDecoration.outline2.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Your next workout:",
                    style: CustomTextStyles.bodyLargeInterPrimary,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    name,
                    style: CustomTextStyles.titleLargeInterMedium,
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsetsDirectional.only(
                      start: 8.h,
                      end: 26.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Duration:",
                                style: CustomTextStyles.titleSmallInter,
                              ),
                              Text(
                                "$duration minutes",
                                style: CustomTextStyles.bodyMediumRegular,
                              )
                            ],
                          ),
                        ),
                        Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Reps:",
                              style: CustomTextStyles.titleSmallInter,
                            ),
                            Text(
                              "$reps",
                              style: CustomTextStyles.bodyMediumRegular,
                            )
                          ],
                        ),
                        Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sets:",
                              style: CustomTextStyles.titleSmallInter,
                            ),
                            Text(
                              "$sets",
                              style: CustomTextStyles.bodyMediumRegular,
                            )
                          ],
                        ),
                        Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Exercise:",
                              style: CustomTextStyles.titleSmallInter,
                            ),
                            Text(
                              "$exercises",
                              style: CustomTextStyles.bodyMediumRegular,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CustomOutlinedButton(
                    height: 40.h,
                    text: "Start workout",
                    margin: EdgeInsetsDirectional.only(
                      start: 12.h,
                      end: 14.h,
                    ),
                    buttonStyle: CustomButtonStyles.none,
                    decoration: CustomButtonStyles.outlineTL8Decoration,
                    buttonTextStyle: CustomTextStyles.headlineSmallWhiteA700,
                    onPressed: onTap,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WorkoutsgridItem extends StatelessWidget {
  final Map<String, dynamic> workout;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const WorkoutsgridItem({
    super.key,
    required this.workout,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final name = workout['name'] ?? 'Workout';
    final duration = workout['duration'] ?? 45;
    final exercises = (workout['exercises'] as List?)?.length ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsetsDirectional.all(14.h),
        decoration: AppDecoration.fillBlueGray.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: SizedBox()), // Push the icon to the right
                if (onRemove != null)
                  GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      padding: EdgeInsets.all(4.h),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite,
                        size: 20.h,
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4.h),
            CustomImageView(
              imagePath: ImageConstant.imgRectangle188,
              height: 138.h,
              width: double.maxFinite,
              radius: BorderRadius.circular(
                16.h,
              ),
              margin: EdgeInsetsDirectional.only(end: 8.h),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 4.h, top: 8.h),
              child: Text(
                name,
                style: CustomTextStyles.titleLargeInterBluegray70001,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 6.h),
              child: Text(
                "$exercises exercises • $duration min",
                style: CustomTextStyles.labelMediumInterBluegray70001,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ListsarahOneItemWidget extends StatelessWidget {
  const ListsarahOneItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgRectangle195,
          height: 80.h,
          width: 80.h,
          radius: BorderRadius.circular(
            40.h,
          ),
        ),
        Text(
          "Sarah",
          overflow: TextOverflow.ellipsis,
          style: CustomTextStyles.titleSmallInterBluegray70001,
        )
      ],
    );
  }
}
