import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../exercice_explication_screen/exercice_explication_screen.dart';
import '../services/workout_service.dart';
import '../widgets.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  final int? workoutId;
  final String? queryFilter;

  const WorkoutDetailsScreen({super.key, this.workoutId, this.queryFilter});

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  bool isLoading = true;
  String? error;
  int? workoutId;
  bool isFavorite = false;
  String? muscleGroup;

  @override
  void initState() {
    super.initState();
    // Clear any previous data on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final workoutService =
          Provider.of<WorkoutService>(context, listen: false);
      workoutService.clearMuscleGroupData();
      _loadContent();
    });
  }

  void _loadContent() {
    // Check if values were passed directly in the constructor
    if (widget.queryFilter != null) {
      // It's a muscle group filter
      muscleGroup = widget.queryFilter;
      print('DEBUG: Processing constructor queryFilter: $muscleGroup');
      _fetchWorkoutsForMuscleGroup(muscleGroup!);
      return;
    } else if (widget.workoutId != null) {
      // It's a workout ID
      workoutId = widget.workoutId;
      print('DEBUG: Processing constructor workoutId: $workoutId');
      _fetchWorkoutById(workoutId!);
      return;
    }

    // If not found in constructor, check if argument was passed through route
    final argument = ModalRoute.of(context)?.settings.arguments;
    if (argument == null) {
      print('ERROR: No arguments provided via constructor or route');
      setState(() {
        error = 'No navigation parameters found';
        isLoading = false;
      });
      return;
    }

    print('DEBUG: Received argument type: ${argument.runtimeType}');
    print('DEBUG: Received argument value: $argument');

    // Handle different types of arguments
    if (argument is String) {
      // It's a muscle group
      muscleGroup = argument;
      print('DEBUG: Processing as muscle group: $muscleGroup');
      _fetchWorkoutsForMuscleGroup(muscleGroup!);
    } else if (argument is int) {
      // It's a workout ID
      workoutId = argument;
      print('DEBUG: Processing as workout ID: $workoutId');
      _fetchWorkoutById(workoutId!);
    } else {
      print('ERROR: Unknown argument type: ${argument.runtimeType}');
      setState(() {
        error = 'Invalid navigation parameter';
        isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // We don't need to do anything here anymore as we're handling it in initState
  }

  Future<void> _fetchWorkoutsForMuscleGroup(String muscleGroup) async {
    print('DEBUG: Fetching workouts for muscle group: $muscleGroup');
    try {
      final workoutService =
          Provider.of<WorkoutService>(context, listen: false);
      await workoutService.fetchWorkoutsByMuscleGroup(muscleGroup);

      final workouts = workoutService.workoutsByMuscleGroup;
      print('DEBUG: Fetched ${workouts.length} workouts for $muscleGroup');
      if (workouts.isEmpty) {
        print('WARN: No workouts found for muscle group: $muscleGroup');
      } else {
        // Set the selected workout to the first one in the list
        if (workouts.isNotEmpty) {
          print('DEBUG: Setting selected workout to: ${workouts[0]['name']}');
          workoutService.setSelectedWorkout(workouts[0]);

          // Check if this workout is a favorite
          if (workouts[0]['id'] != null) {
            isFavorite = workoutService.isInFavorites(workouts[0]['id']);
          }
        }

        // Print first workout details for debugging
        print(
            'DEBUG: First workout: ${workouts[0]['name']}, exercises: ${workouts[0]['exercises']?.length ?? 0}');
        final exercises = workouts[0]['exercises'];
        if (exercises != null && exercises is List) {
          print('DEBUG: Number of exercises: ${exercises.length}');
          if (exercises.isNotEmpty) {
            print('DEBUG: First exercise: ${exercises[0]['name']}');
          }
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('ERROR: Failed to load workouts for $muscleGroup: $e');
      setState(() {
        error = 'Failed to load workouts for $muscleGroup: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchWorkoutById(int workoutId) async {
    print('DEBUG: Fetching workout details for ID: $workoutId');
    try {
      final workoutService =
          Provider.of<WorkoutService>(context, listen: false);
      await workoutService.getWorkoutDetails(workoutId);

      final workout = workoutService.selectedWorkout;
      if (workout != null) {
        print('DEBUG: Successfully fetched workout: ${workout['name']}');
        isFavorite = workoutService.isInFavorites(workoutId);
      } else {
        print('WARN: No workout found with ID: $workoutId');
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('ERROR: Failed to load workout details for ID $workoutId: $e');
      setState(() {
        error = 'Failed to load workout details: $e';
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final workoutService = Provider.of<WorkoutService>(context);
    final selectedWorkout = workoutService.selectedWorkout;

    // Use MediaQuery to adjust layout based on screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 600 ? 12.0 : 24.0;

    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: selectedWorkout == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildExerciseSummary(context, selectedWorkout),
                    SizedBox(height: 16.h),
                    _buildExerciseList(context, selectedWorkout),
                    SizedBox(height: 24.h), // Added bottom padding for scroll
                  ],
                ),
              ),
      ),
      floatingActionButton: selectedWorkout == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                // Start workout
                final exercises = selectedWorkout['exercises'] as List? ?? [];
                if (exercises.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciceExplicationScreen(
                        exercise: exercises[0],
                        workoutExercises: exercises,
                        currentExerciseIndex: 0,
                        isWorkoutMode: true,
                      ),
                    ),
                  );
                }
              },
              backgroundColor: theme.colorScheme.primary,
              label: Text('Start Workout'),
              icon: Icon(Icons.play_arrow),
            ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final workoutService = Provider.of<WorkoutService>(context, listen: false);
    final workoutName =
        workoutService.selectedWorkout?['name'] ?? 'Workout Details';

    return CustomAppBar(
      height: 46.h,
      title: Padding(
        padding: EdgeInsetsDirectional.only(start: 16.h),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: AppbarSubtitleOne(
                text: "←",
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Expanded(
              child: Center(
                child: AppbarSubtitle(
                  text: workoutName,
                ),
              ),
            ),
          ],
        ),
      ),
      styleType: Style.bgOutlineGray100,
    );
  }

  /// Section Widget
  Widget _buildExerciseSummary(
      BuildContext context, Map<String, dynamic> workout) {
    final exercises = (workout['exercises'] as List?)?.length ?? 0;
    final duration = workout['duration'] ?? 0;
    final calories = workout['calories'] ?? 0;

    return Container(
      margin: EdgeInsetsDirectional.only(end: 2.h),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 2.h),
      width: double.maxFinite,
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 2.h),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ExercisesummaryItem(value: exercises, label: "Exercises"),
            SizedBox(width: 38.h),
            ExercisesummaryItem(value: duration, label: "Minutes"),
            SizedBox(width: 38.h),
            ExercisesummaryItem(value: calories, label: "Calories"),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildExerciseList(
      BuildContext context, Map<String, dynamic> workout) {
    print('WorkoutDetailsScreen: Building exercise list');

    if (workout.isEmpty) {
      print('WorkoutDetailsScreen: No workout available for exercise list');
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Text(
            "No workout found",
            style: CustomTextStyles.bodyMediumGray60001,
          ),
        ),
      );
    }

    // Get the selected workout from the service
    final workoutService = Provider.of<WorkoutService>(context, listen: false);
    final selectedWorkout = workoutService.selectedWorkout;

    print('WorkoutDetailsScreen: Selected workout: $selectedWorkout');

    if (selectedWorkout == null) {
      print('WorkoutDetailsScreen: No workout selected');
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Text(
            "No workout selected",
            style: CustomTextStyles.bodyMediumGray60001,
          ),
        ),
      );
    }

    final exercises = selectedWorkout['exercises'] as List? ?? [];
    print(
        'WorkoutDetailsScreen: Number of exercises found: ${exercises.length}');

    if (exercises.isEmpty) {
      print('WorkoutDetailsScreen: No exercises in selected workout');
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Text(
            "No exercises found in this workout",
            style: CustomTextStyles.bodyMediumGray60001,
          ),
        ),
      );
    }

    print('WorkoutDetailsScreen: Building exercise items');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Text(
              "Exercises",
              style: CustomTextStyles.headlineSmallWorkSansSemiBold,
            ),
          ),
          // Display exercises from the selected workout
          ...exercises.map((exercise) {
            print(
                'WorkoutDetailsScreen: Processing exercise: ${exercise['name']}');
            // Convert exercise to Map if it's not already
            Map<String, dynamic> exerciseMap = {};
            if (exercise is Map) {
              exerciseMap = Map<String, dynamic>.from(exercise);
            }

            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: ExerciselistItem(
                exercise: exerciseMap,
                onPlay: () {
                  _navigateToExerciseExplication(exerciseMap);
                },
                onFavorite: () {
                  // Optional: implement favoriting individual exercises
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  void _navigateToExerciseExplication(Map<String, dynamic> exercise) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ExerciceExplicationScreen(exercise: exercise),
    ));
  }
}

class ExercisesummaryItem extends StatelessWidget {
  final int value;
  final String label;

  const ExercisesummaryItem({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110.h,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 26.h,
        vertical: 8.h,
      ),
      decoration: AppDecoration.fillGray100.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$value",
            style: CustomTextStyles.titleMediumOrangeA70001,
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              label,
              style: CustomTextStyles.bodySmallGray60001_1,
            ),
          ),
          SizedBox(height: 12.h)
        ],
      ),
    );
  }
}

/// Updated Exercise List Item
class ExerciselistItem extends StatelessWidget {
  final Map<String, dynamic> exercise;
  final VoidCallback? onPlay;
  final VoidCallback? onFavorite;

  const ExerciselistItem({
    super.key,
    required this.exercise,
    this.onPlay,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final name = exercise['name'] ?? 'Exercise';
    final muscleGroup = exercise['muscleGroup']?.toString().toLowerCase() ?? '';
    final description = exercise['description'] ?? 'No description';
    final sets = exercise['sets'] ?? exercise['defaultSets'] ?? 4;
    final reps = exercise['reps'] ?? exercise['defaultReps'] ?? 12;

    // Check if exercise is a favorite
    final workoutService = Provider.of<WorkoutService>(context, listen: true);
    final isFavorite = workoutService.isExerciseFavorite(exercise);
    // Select image based on muscle group and exercise name
    String imagePath;
    if (exercise['imageUrl'] != null &&
        exercise['imageUrl'].toString().isNotEmpty) {
      // Use our utility function to get a full URL for backend images
      imagePath = getFullImageUrl(exercise['imageUrl']);
    } else {
      // First check by exercise name for more specific matches
      final exerciseName = name.toLowerCase();

      if (exerciseName.contains('pull-up') || exerciseName.contains('pullup')) {
        imagePath =
            'https://images.unsplash.com/photo-1598971639058-a4a678c30ed6?q=80';
      } else if (exerciseName.contains('push') && exerciseName.contains('up')) {
        imagePath =
            'https://images.unsplash.com/photo-1598971639058-a4a678c30ed6?q=80';
      } else if (exerciseName.contains('bench press') ||
          exerciseName.contains('chest press')) {
        imagePath =
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80';
      } else if (exerciseName.contains('squat')) {
        imagePath =
            'https://images.unsplash.com/photo-1574680096145-d05b474e2155?q=80';
      } else if (exerciseName.contains('deadlift')) {
        imagePath =
            'https://images.unsplash.com/photo-1603287681836-b174ce5074c2?q=80';
      } else if (exerciseName.contains('row')) {
        imagePath =
            'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?q=80';
      } else if (exerciseName.contains('curl')) {
        imagePath =
            'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?q=80';
      } else if (exerciseName.contains('press') &&
          (exerciseName.contains('shoulder') ||
              exerciseName.contains('overhead'))) {
        imagePath =
            'https://images.unsplash.com/photo-1532029837206-abbe2b7620e3?q=80';
      } else {
        // Fall back to muscle group based images
        if (muscleGroup.contains('chest')) {
          imagePath =
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80';
        } else if (muscleGroup.contains('leg')) {
          imagePath =
              'https://images.unsplash.com/photo-1574680096145-d05b474e2155?q=80';
        } else if (muscleGroup.contains('back')) {
          imagePath =
              'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80';
        } else if (muscleGroup.contains('shoulder')) {
          imagePath =
              'https://images.unsplash.com/photo-1532029837206-abbe2b7620e3?q=80';
        } else if (muscleGroup.contains('arm') ||
            muscleGroup.contains('bicep') ||
            muscleGroup.contains('tricep')) {
          imagePath =
              'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?q=80';
        } else if (muscleGroup.contains('full')) {
          imagePath =
              'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80';
        } else {
          // Default image
          imagePath =
              'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80';
        }
      }
    }

    return Container(
      margin: EdgeInsetsDirectional.only(
        bottom: 10.h,
      ),
      padding: EdgeInsetsDirectional.all(10.h),
      decoration: AppDecoration.fillGray100.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
            imagePath: imagePath,
            height: 84.h,
            width: 98.h,
            radius: BorderRadius.circular(12.h),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: CustomTextStyles.titleLargeInter,
                ),
                SizedBox(height: 4.h),
                Text(
                  "$sets sets • $reps reps",
                  style: CustomTextStyles.bodyMediumGray60001,
                ),
                SizedBox(height: 4.h),
                Text(
                  "Target: $muscleGroup",
                  style: CustomTextStyles.bodySmallGray60001,
                ),
                SizedBox(height: 2.h),
                Text(
                  description,
                  style: CustomTextStyles.bodySmallGray60001,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: onPlay,
                child: Container(
                  padding: EdgeInsets.all(8.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: theme.colorScheme.primary,
                    size: 24.h,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: () async {
                  // Toggle favorite status when clicked
                  await workoutService.toggleExerciseFavorite(exercise);

                  // Show feedback to the user
                  final isNowFavorite =
                      workoutService.isExerciseFavorite(exercise);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isNowFavorite
                          ? 'Added $name to favorites'
                          : 'Removed $name from favorites'),
                      duration: Duration(seconds: 1),
                    ),
                  );

                  // Call the provided onFavorite callback if available
                  if (onFavorite != null) {
                    onFavorite!();
                  }
                },
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                  size: 22.h,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
