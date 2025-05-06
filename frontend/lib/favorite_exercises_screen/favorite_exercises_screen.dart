import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../widgets.dart';
import '../services/workout_service.dart';
import '../exercice_explication_screen/exercice_explication_screen.dart';

class FavoriteExercisesScreen extends StatefulWidget {
  const FavoriteExercisesScreen({super.key});

  @override
  State<FavoriteExercisesScreen> createState() => _FavoriteExercisesScreenState();
}

class _FavoriteExercisesScreenState extends State<FavoriteExercisesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: _buildFavoriteExercisesList(context),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
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
                  text: "My Favorite Exercises",
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
  Widget _buildFavoriteExercisesList(BuildContext context) {
    return Consumer<WorkoutService>(
      builder: (context, workoutService, child) {
        final favoriteExercises = workoutService.favoriteExercises;

        if (favoriteExercises.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "No favorite exercises yet",
                  style: CustomTextStyles.titleMediumWorkSansOnPrimary,
                ),
                SizedBox(height: 8),
                Text(
                  "Mark exercises as favorites to see them here",
                  style: CustomTextStyles.bodySmallGray60001,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.h),
          itemCount: favoriteExercises.length,
          itemBuilder: (context, index) {
            final exercise = favoriteExercises[index];
            return FavoriteExerciseItem(
              exercise: exercise,
              onRemove: () async {
                await workoutService.removeExerciseFromFavorites(exercise);
                setState(() {}); // Refresh the UI
              },
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ExerciceExplicationScreen(exercise: exercise),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class FavoriteExerciseItem extends StatelessWidget {
  final Map<String, dynamic> exercise;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const FavoriteExerciseItem({
    super.key,
    required this.exercise,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = exercise['name'] ?? 'Exercise';
    final muscleGroup = exercise['muscleGroup']?.toString().toLowerCase() ?? '';
    final description = exercise['description'] ?? 'No description';
    final sets = exercise['sets'] ?? exercise['defaultSets'] ?? 4;
    final reps = exercise['reps'] ?? exercise['defaultReps'] ?? 12;

    // Select image based on muscle group
    String imagePath;
    if (exercise['imageUrl'] != null && exercise['imageUrl'].toString().isNotEmpty) {
      imagePath = exercise['imageUrl'];
    } else if (exercise['videoUrl'] != null && exercise['videoUrl'].toString().isNotEmpty) {
      imagePath = exercise['videoUrl'];
    } else {
      // Use specific images based on muscle group
      if (muscleGroup.contains('chest')) {
        imagePath = ImageConstant.imgRectangle188;
      } else if (muscleGroup.contains('leg')) {
        imagePath = ImageConstant.imgRectangle190;
      } else if (muscleGroup.contains('back') || muscleGroup.contains('shoulder')) {
        imagePath = ImageConstant.imgRectangle194;
      } else if (muscleGroup.contains('full')) {
        imagePath = ImageConstant.imgRectangle192;
      } else {
        // Default image
        imagePath = ImageConstant.imgImage84x98;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsetsDirectional.only(
          bottom: 12.h,
        ),
        padding: EdgeInsetsDirectional.all(12.h),
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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ExerciceExplicationScreen(exercise: exercise),
                      ),
                    );
                  },
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
                  onTap: onRemove,
                  child: Icon(
                    Icons.favorite,
                    color: theme.colorScheme.primary,
                    size: 24.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}