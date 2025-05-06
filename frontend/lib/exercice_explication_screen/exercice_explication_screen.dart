import 'dart:async';
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../widgets.dart';

class ExerciceExplicationScreen extends StatefulWidget {
  final Map<String, dynamic>? exercise;
  final List<dynamic>? workoutExercises;
  final int? currentExerciseIndex;
  final bool? isWorkoutMode;
  
  const ExerciceExplicationScreen({
    super.key, 
    this.exercise,
    this.workoutExercises,
    this.currentExerciseIndex = 0,
    this.isWorkoutMode = false
  });

  @override
  State<ExerciceExplicationScreen> createState() => _ExerciceExplicationScreenState();
}

class _ExerciceExplicationScreenState extends State<ExerciceExplicationScreen> {
  Map<String, dynamic>? exercise;
  List<dynamic>? workoutExercises;
  int currentExerciseIndex = 0;
  int currentSet = 1;
  int totalSets = 4;
  bool isWorkoutMode = false;
  int secondsElapsed = 0;
  Timer? _timer;
  double progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // First, check if we have parameters from constructor
    if (widget.exercise != null) {
      exercise = widget.exercise;
    }
    
    if (widget.workoutExercises != null) {
      workoutExercises = widget.workoutExercises;
      currentExerciseIndex = widget.currentExerciseIndex ?? 0;
      isWorkoutMode = widget.isWorkoutMode ?? false;
      
      // Ensure exercise is set
      if (exercise == null && workoutExercises!.isNotEmpty) {
        exercise = workoutExercises![currentExerciseIndex];
      }
      
      // Calculate progress
      if (isWorkoutMode && workoutExercises != null && workoutExercises!.isNotEmpty) {
        progressValue = (currentExerciseIndex + 1) / workoutExercises!.length;
      }
    }
    
    // If no constructor parameters, try to get from route arguments as fallback
    if (exercise == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      
      if (args is Map<String, dynamic>) {
        // Single exercise mode
        if (args['exercise'] != null) {
          exercise = args['exercise'];
        }
        
        // Workout mode (multiple exercises)
        if (args['workoutExercises'] != null) {
          workoutExercises = args['workoutExercises'];
          currentExerciseIndex = args['currentExerciseIndex'] ?? 0;
          isWorkoutMode = args['isWorkoutMode'] ?? false;
          
          // Ensure exercise is set
          if (exercise == null && workoutExercises!.isNotEmpty) {
            exercise = workoutExercises![currentExerciseIndex];
          }
          
          // Calculate progress
          if (isWorkoutMode && workoutExercises != null && workoutExercises!.isNotEmpty) {
            progressValue = (currentExerciseIndex + 1) / workoutExercises!.length;
          }
        }
      } else if (args is Map<String, dynamic>) {
        // Direct exercise viewing (from search or listing)
        exercise = args;
      }
    }
    
    // Set defaults if still null
    exercise ??= {'name': 'Exercise', 'description': 'No details available'};
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  String get formattedTime {
    final minutes = (secondsElapsed ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsElapsed % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _nextExercise() {
    if (!isWorkoutMode || workoutExercises == null || workoutExercises!.isEmpty) {
      // Simply exit if not in workout mode
      Navigator.pop(context);
      return;
    }

    if (currentSet < totalSets) {
      // Move to next set of the same exercise
      setState(() {
        currentSet++;
        progressValue = (currentExerciseIndex * totalSets + currentSet) / 
                       (workoutExercises!.length * totalSets);
      });
    } else {
      // Move to next exercise
      final nextIndex = currentExerciseIndex + 1;
      
      if (nextIndex < workoutExercises!.length) {
        setState(() {
          currentExerciseIndex = nextIndex;
          exercise = workoutExercises![nextIndex];
          currentSet = 1; // Reset sets for new exercise
          progressValue = (currentExerciseIndex * totalSets + currentSet) / 
                         (workoutExercises!.length * totalSets);
        });
      } else {
        // Workout completed
        _showWorkoutCompleted();
      }
    }
  }
  
  void _previousExercise() {
    if (!isWorkoutMode || workoutExercises == null || workoutExercises!.isEmpty) {
      // Simply exit if not in workout mode
      Navigator.pop(context);
      return;
    }

    if (currentSet > 1) {
      // Move to previous set of the same exercise
      setState(() {
        currentSet--;
        progressValue = (currentExerciseIndex * totalSets + currentSet) / 
                       (workoutExercises!.length * totalSets);
      });
    } else {
      // Move to previous exercise
      final prevIndex = currentExerciseIndex - 1;
      
      if (prevIndex >= 0) {
        setState(() {
          currentExerciseIndex = prevIndex;
          exercise = workoutExercises![prevIndex];
          currentSet = totalSets; // Go to last set of previous exercise
          progressValue = (currentExerciseIndex * totalSets + currentSet) / 
                         (workoutExercises!.length * totalSets);
        });
      } else {
        // Already at first exercise and first set
        Navigator.pop(context); // Go back to workout details
      }
    }
  }
  
  void _endWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('End Workout'),
        content: Text('Are you sure you want to end this workout?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('End Workout', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to workout details
            },
          ),
        ],
      ),
    );
  }
  
  void _showWorkoutCompleted() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Workout Completed'),
        content: Text('Congratulations! You have completed your workout.'),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to workout details
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exerciseName = exercise?['name'] ?? 'Exercise';
    
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppbar(context, exerciseName),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsetsDirectional.only(top: 20.h),
              child: Column(
                children: [
                  SizedBox(height: 34.h),
                  Container(
                    height: 200.h,
                    width: 202.h,
                    decoration: AppDecoration.outlineGray100.copyWith(
                      borderRadius: BorderRadiusStyle.circleBorder100,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Set $currentSet/$totalSets",
                          style: CustomTextStyles.headlineSmallBold,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildProgressIndicator(context),
                  SizedBox(height: 68.h),
                  _buildExerciseVideo(context),
                  SizedBox(height: 20.h),
                  if (exercise?['description'] != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: Text(
                        exercise!['description'],
                        style: CustomTextStyles.bodyMediumGray60001,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  SizedBox(height: 50.h),
                  _buildNavigationControls(context)
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildEndWorkoutButton(context),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context, String title) {
    return CustomAppBar(
      height: 46.h,
      title: Padding(
        padding: EdgeInsetsDirectional.only(start: 16.h),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: AppbarSubtitleOne(
                text: "←",
              ),
            ),
            AppbarSubtitle(
              text: title,
              margin: EdgeInsetsDirectional.only(start: 109.h),
            )
          ],
        ),
      ),
      actions: [
        AppbarSubtitleThree(
          text: formattedTime,
          margin: EdgeInsetsDirectional.only(end: 12.h),
        )
      ],
      styleType: Style.bgOutlineGray100,
    );
  }

  /// Section Widget
  Widget _buildProgressIndicator(BuildContext context) {
    int progressPercent = (progressValue * 100).round();
    
    return Container(
      width: double.maxFinite,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 10.h),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 4.h),
      child: Column(
        spacing: 18,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsetsDirectional.only(
              start: 4.h,
              end: 2.h,
            ),
            child: Container(
              height: 8.h,
              width: 400.h,
              decoration: BoxDecoration(
                color: appTheme.gray100,
                borderRadius: BorderRadius.circular(
                  4.h,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  4.h,
                ),
                child: LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: appTheme.gray100,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    appTheme.orangeA70001,
                  ),
                ),
              ),
            ),
          ),
          Text(
            "$progressPercent% completed",
            style: CustomTextStyles.bodySmallGray60001_1,
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildExerciseVideo(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(
        start: 52.h,
        end: 58.h,
      ),
      decoration: BoxDecoration(
        color: appTheme.gray200,
        borderRadius: BorderRadius.circular(12.h),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgFrame1000006648, 
            height: 190.h,
            width: double.maxFinite,
            fit: BoxFit.cover,
            radius: BorderRadius.circular(12.h),
          ),
          Container(
            height: 50.h,
            width: 50.h,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 30.h,
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildNavigationControls(BuildContext context) {
    // Calculate sets left
    final setsLeft = totalSets - currentSet;
    
    return Container(
      width: double.maxFinite,
      padding: EdgeInsetsDirectional.all(12.h),
      decoration: AppDecoration.outlineGray1001,
      child: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsetsDirectional.only(
              start: 24.h,
              end: 34.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.h,
                  width: 22.h,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgContrast,
                        height: 20.h,
                        width: 20.h,
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgVectorBlack900,
                        height: 8.h,
                        width: 6.h,
                        alignment: AlignmentDirectional.topEnd,
                        margin: EdgeInsetsDirectional.only(
                          top: 4.h,
                          end: 6.h,
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 6.h),
                    child: Text(
                      formattedTime,
                      style: CustomTextStyles.bodyMediumLight,
                    ),
                  ),
                ),
                Spacer(
                  flex: 34,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgSettingsBlack900,
                  height: 24.h,
                  width: 26.h,
                ),
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 6.h),
                    child: Text(
                      "$setsLeft sets left",
                      style: CustomTextStyles.bodyMediumLight,
                    ),
                  ),
                ),
                Spacer(
                  flex: 65,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgHeartLine,
                  height: 24.h,
                  width: 26.h,
                )
              ],
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    height: 48.h,
                    text: "Previous",
                    buttonStyle: CustomButtonStyles.fillGray,
                    buttonTextStyle: CustomTextStyles.titleLargeInterGray60001,
                    onPressed: _previousExercise,
                  ),
                ),
                Expanded(
                  child: CustomElevatedButton(
                    height: 48.h,
                    text: "Next",
                    rightIcon: Container(
                      margin: EdgeInsetsDirectional.only(start: 16.h),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgArrowrightWhiteA700,
                        height: 24.h,
                        width: 24.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    buttonStyle: CustomButtonStyles.fillOrangeA,
                    buttonTextStyle: CustomTextStyles.titleLargeInterWhiteA700,
                    onPressed: _nextExercise,
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
  Widget _buildEndWorkoutButton(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            height: 48.h,
            text: "End Workout",
            margin: EdgeInsetsDirectional.only(bottom: 12.h),
            leftIcon: Container(
              margin: EdgeInsetsDirectional.only(end: 6.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgClose,
                height: 12.h,
                width: 12.h,
                fit: BoxFit.contain,
              ),
            ),
            buttonStyle: CustomButtonStyles.fillDeepOrange,
            buttonTextStyle: CustomTextStyles.titleLargeInterRed500,
            onPressed: _endWorkout,
          )
        ],
      ),
    );
  }
}
