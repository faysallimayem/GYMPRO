import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../widgets.dart';

class ExerciceExplicationScreen extends StatefulWidget {
  final Map<String, dynamic>? exercise;
  final List<dynamic>? workoutExercises;
  final int? currentExerciseIndex;
  final bool? isWorkoutMode;

  const ExerciceExplicationScreen(
      {super.key,
      this.exercise,
      this.workoutExercises,
      this.currentExerciseIndex = 0,
      this.isWorkoutMode = false});

  @override
  State<ExerciceExplicationScreen> createState() =>
      _ExerciceExplicationScreenState();
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

  // Video player controllers
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;
  YoutubePlayerController? _youtubePlayerController;

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
      if (isWorkoutMode &&
          workoutExercises != null &&
          workoutExercises!.isNotEmpty) {
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
          if (isWorkoutMode &&
              workoutExercises != null &&
              workoutExercises!.isNotEmpty) {
            progressValue =
                (currentExerciseIndex + 1) / workoutExercises!.length;
          }
        }
      } else if (args is Map<String, dynamic>) {
        // Direct exercise viewing (from search or listing)
        exercise = args;
      }
    }

    // Set defaults if still null
    exercise ??= {'name': 'Exercise', 'description': 'No details available'};

    // Initialize video player after exercise is set
    _initializeVideoPlayer();
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
    if (!isWorkoutMode ||
        workoutExercises == null ||
        workoutExercises!.isEmpty) {
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
    if (!isWorkoutMode ||
        workoutExercises == null ||
        workoutExercises!.isEmpty) {
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
              // First pop closes the dialog
              Navigator.pop(context);

              // Return workout completion data to previous screen
              Navigator.pop(context, {
                'completed': false,
                'timeSpent': secondsElapsed,
                'lastExerciseIndex': currentExerciseIndex,
                'lastSet': currentSet,
                'totalSets': totalSets * workoutExercises!.length,
                'completedSets':
                    (currentExerciseIndex * totalSets) + currentSet,
              });
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
              // First pop closes the dialog
              Navigator.pop(context);

              // Return workout completion data to previous screen
              Navigator.pop(context, {
                'completed': true,
                'timeSpent': secondsElapsed,
                'totalSets': totalSets * workoutExercises!.length,
                'completedSets': totalSets * workoutExercises!.length,
              });
            },
          ),
        ],
      ),
    );
  }

  void _initializeVideoPlayer() {
    // Get the video URL from the exercise data or use a placeholder
    final videoUrl = exercise?['videoUrl'];

    if (videoUrl == null) {
      // No video URL available, show placeholder
      return;
    }

    // Handle YouTube URLs by extracting the video ID
    if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
      String? extractedVideoId;

      // Extract YouTube video ID
      if (videoUrl.contains('youtube.com/watch?v=')) {
        extractedVideoId = Uri.parse(videoUrl).queryParameters['v'];
      } else if (videoUrl.contains('youtu.be/')) {
        extractedVideoId = videoUrl.split('youtu.be/')[1];
        if (extractedVideoId != null && extractedVideoId.contains('?')) {
          extractedVideoId = extractedVideoId.split('?')[0];
        }
      }

      // Only proceed if we have a valid video ID
      final String videoId = extractedVideoId ?? '';
      if (videoId.isNotEmpty) {
        try {
          // Initialize YouTube player controller with late binding
          // This ensures the controller is only accessed when ready
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _youtubePlayerController = YoutubePlayerController(
                initialVideoId: videoId, // Now using a non-nullable String
                flags: YoutubePlayerFlags(
                  autoPlay: false,
                  mute: false,
                  disableDragSeek: false,
                  loop: false,
                  isLive: false,
                  forceHD: false,
                  enableCaption: true,
                  captionLanguage: 'en',
                  useHybridComposition: true,
                ),
              );

              _youtubePlayerController!.addListener(() {
                // Only update state if widget is still mounted
                if (mounted) {
                  setState(() {
                    _isVideoInitialized = true;
                  });
                }
              });
            }
          });
        } catch (e) {
          print('Error initializing YouTube player: $e');
        }
      }
      return;
    }

    // For direct video URLs (not YouTube)
    try {
      if (videoUrl.startsWith('http')) {
        _videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      } else {
        _videoPlayerController = VideoPlayerController.asset(videoUrl);
      }

      _videoPlayerController!.initialize().then((_) {
        // Only update state if widget is still mounted
        if (mounted) {
          // Once the video has been loaded, create the controller
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController!,
            autoPlay: false,
            looping: true,
            aspectRatio: 16 / 9,
            errorBuilder: (context, errorMessage) {
              return Center(
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          );

          setState(() {
            _isVideoInitialized = true;
          });
        }
      }).catchError((error) {
        print('Error initializing video: $error');
        // Keep the default state (showing placeholder)
      });
    } catch (e) {
      print('Exception setting up video player: $e');
      // Keep the default state (showing placeholder)
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    _youtubePlayerController?.dispose();
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
              child: AppbarSubtitleOne(
                text: "←",
                onTap: () {
                  // If in a workout, ask for confirmation before leaving
                  if (isWorkoutMode) {
                    _endWorkout();
                  } else {
                    // If it's just a single exercise view, simply go back
                    Navigator.pop(context);
                  }
                },
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
    final videoUrl = exercise?['videoUrl'];
    final imageUrl =
        exercise?['imageUrl']; // Get the image URL from the exercise
    final bool isYoutubeVideo = videoUrl != null &&
        (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be'));

    // Extract YouTube video ID for thumbnail
    String? youtubeVideoId;
    if (isYoutubeVideo) {
      if (videoUrl.contains('youtube.com/watch?v=')) {
        youtubeVideoId = Uri.parse(videoUrl).queryParameters['v'];
      } else if (videoUrl.contains('youtu.be/')) {
        youtubeVideoId = videoUrl.split('youtu.be/')[1];
        // Use null-safe methods to handle the potential null youtubeVideoId
        if (youtubeVideoId != null && youtubeVideoId.contains('?')) {
          youtubeVideoId = youtubeVideoId.split('?')[0];
        }
      }
    }

    return Container(
      margin: EdgeInsetsDirectional.only(
        start: 24.h,
        end: 24.h,
      ),
      height: 220.h,
      decoration: BoxDecoration(
        color: appTheme.gray200,
        borderRadius: BorderRadius.circular(12.h),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.h),
        child: isYoutubeVideo
            ? _buildYoutubePreview(youtubeVideoId, videoUrl)
            : _isVideoInitialized && _chewieController != null
                ? Chewie(controller: _chewieController!)
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      // Use the custom image URL if available, otherwise fallback to placeholder
                      _buildExerciseImage(imageUrl),
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
      ),
    );
  }

  // Helper method to build exercise image with proper URL handling
  Widget _buildExerciseImage(String? imageUrl) {
    // If no image URL provided, use placeholder
    if (imageUrl == null || imageUrl.isEmpty) {
      return CustomImageView(
        imagePath: ImageConstant.imgFrame1000006648,
        height: 220.h,
        width: double.maxFinite,
        fit: BoxFit.cover,
      );
    }

    // Use replacement URLs for problematic image sources like Shutterstock
    if (imageUrl.contains('shutterstock.com') ||
        imageUrl.contains('stockphoto') ||
        imageUrl.contains('gettyimages')) {
      // Use appropriate exercise image based on muscle group
      String muscleGroup =
          exercise?['muscleGroup']?.toString().toLowerCase() ?? '';

      if (muscleGroup.contains('chest')) {
        return Image.network(
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80',
          height: 220.h,
          width: double.maxFinite,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      } else if (muscleGroup.contains('back')) {
        return Image.network(
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80',
          height: 220.h,
          width: double.maxFinite,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      } else if (muscleGroup.contains('leg')) {
        return Image.network(
          'https://images.unsplash.com/photo-1574680178050-55c6a6a96e0a?q=80',
          height: 220.h,
          width: double.maxFinite,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      } else if (muscleGroup.contains('shoulder')) {
        return Image.network(
          'https://images.unsplash.com/photo-1532029837206-abbe2b7620e3?q=80',
          height: 220.h,
          width: double.maxFinite,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      } else {
        // Default fitness image
        return Image.network(
          'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80',
          height: 220.h,
          width: double.maxFinite,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      }
    } // Get the full image URL or asset path using our helper function
    String fullImageUrl = getFullImageUrl(imageUrl);

    // Handle asset paths
    if (fullImageUrl.startsWith('assets/')) {
      return Image.asset(
        fullImageUrl,
        height: 220.h,
        width: double.maxFinite,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("Error loading asset image: $fullImageUrl - $error");
          return _buildPlaceholder();
        },
      );
    }

    // Try to load as network image with error handling
    return Image.network(
      fullImageUrl,
      height: 220.h,
      width: double.maxFinite,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print("Error loading network image: $fullImageUrl - $error");
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 220.h,
      width: double.maxFinite,
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.fitness_center,
          size: 50.h,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  /// Build a YouTube video player directly in the app
  Widget _buildYoutubePreview(String? videoId, String videoUrl) {
    // If we have a videoId but controller is not yet initialized, show loading state
    if (_youtubePlayerController == null && videoId != null) {
      return Stack(
        alignment: Alignment.center,
        children: [
          // Use a solid background color instead of potentially problematic network images
          Container(
            height: 220.h,
            width: double.maxFinite,
            color: Colors.black,
            child: Center(
              child: CustomImageView(
                imagePath: ImageConstant.imgFrame1000006648,
                height: 220.h,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Loading indicator
          CircularProgressIndicator(
            color: appTheme.orangeA70001,
          ),

          // Loading text
          Positioned(
            bottom: 10.h,
            child: Container(
              padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 8.h, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4.h),
              ),
              child: Text(
                "Loading video player...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.h,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // If controller is initialized, show the player
    if (_youtubePlayerController != null) {
      try {
        return YoutubePlayer(
          controller: _youtubePlayerController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: appTheme.orangeA70001,
          progressColors: ProgressBarColors(
            playedColor: appTheme.orangeA70001,
            handleColor: appTheme.orangeA70001,
          ),
          onReady: () {
            print('YouTube Player Ready');
          },
          onEnded: (_) {
            // Handle video end
          },
          bottomActions: [
            CurrentPosition(),
            ProgressBar(
              isExpanded: true,
              colors: ProgressBarColors(
                playedColor: appTheme.orangeA70001,
                handleColor: appTheme.orangeA70001,
              ),
            ),
            RemainingDuration(),
            FullScreenButton(),
          ],
        );
      } catch (e) {
        print('Error rendering YouTube player: $e');
        // Fall through to error state
      }
    }

    // If YouTube player initialization failed or we have no videoId, show error state
    return Stack(
      alignment: Alignment.center,
      children: [
        // Fallback image
        CustomImageView(
          imagePath: ImageConstant.imgFrame1000006648,
          height: 220.h,
          width: double.maxFinite,
          fit: BoxFit.cover,
        ),

        // Play button overlay
        Container(
          height: 60.h,
          width: 60.h,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 40.h,
          ),
        ),

        // Error message overlay
        Positioned(
          bottom: 10.h,
          child: Container(
            padding:
                EdgeInsetsDirectional.symmetric(horizontal: 8.h, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(4.h),
            ),
            child: Text(
              "Could not load YouTube video",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.h,
              ),
            ),
          ),
        ),
      ],
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
