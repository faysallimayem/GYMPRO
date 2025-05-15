import 'package:flutter/material.dart';
import '../add_user_screen/add_user_screen.dart';
import '../admin_dashbord_screen/admin_dashbord_screen.dart';
import '../age_screen/age_screen.dart';
import '../authentication_screen/authentication_screen.dart';
import '../chat_screen/chat_screen.dart';
import '../coach_profile_screen/coach_profile_screen.dart';
import '../course_management_screen/course_management_screen.dart';
import '../edit_user_profile_screen/edit_user_profile_screen.dart';
import '../edit_user_screen/edit_user_screen.dart';
import '../exercice_explication_screen/exercice_explication_screen.dart';
import '../exercice_managment_screen/exercice_managment_screen.dart';
import '../favorite_exercises_screen/favorite_exercises_screen.dart';
import '../forgot_password_screen/forgot_password_screen.dart';
import '../gender_screen/gender_screen.dart';
import '../get_started_screen/get_started_screen.dart';
import '../workout_details_screen/workout_details_screen.dart';
import '../height_screen/height_screen.dart';
import '../home_screen/home_screen.dart';
import '../nutrition_management_screen/nutrition_management_screen.dart';
import '../nutrition_screen/nutrition_screen.dart';
import '../reset_password_screen/reset_password_screen.dart';
import '../sign_up_screen/sign_up_screen.dart';
import '../user_management_screen/user_management_screen.dart';
import '../weight_screen/weight_screen.dart';
import '../nutrition_calculator_screen/nutrition_calculator_screen.dart';
import '../meal_creation_screen/meal_creation_screen.dart';

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String getStartedScreen = '/get_started_screen';

  static const String authenticationScreen = '/authentication_screen';

  static const String signUpScreen = '/sign_up_screen';

  static const String forgotPasswordScreen = '/forgot_password_screen';

  static const String resetPasswordScreen = '/reset_password_screen';

  static const String genderScreen = '/gender_screen';

  static const String ageScreen = '/age_screen';

  static const String weightScreen = '/weight_screen';

  static const String heightScreen = '/height_screen';

  static const String homeScreen = '/home_screen';

  static const String homeInitialPage = '/home_initial_page';

  static const String workoutsPage = '/workouts_page';

  static const String adminDashbordScreen = '/admin_dashbord_screen';

  static const String userManagmentScreen = '/user_managment_screen';

  static const String courseManagementScreen = '/course_management_screen';

  static const String addUserScreen = '/add_user_screen';

  static const String editUserScreen = '/edit_user_screen';

  static const String nutritionManagementScreen =
      '/nutrition_management_screen';

  static const String nutritionScreen = '/nutrition_screen';

  static const String nutritionCalculatorScreen =
      '/nutrition_calculator_screen';

  static const String mealCreationScreen = '/meal_creation_screen';

  static const String exerciceManagmentScreen = '/exercice_managment_screen';

  static const String chatScreen = '/chat_screen';

  static const String workoutDetailsScreen = '/workout_details_screen';

  static const String exerciceExplicationScreen =
      '/exercice_explication_screen';

  static const String gymClassesPage = '/gym_classes_page';

  static const String gymclassesallTabPage = '/gymclassesall_tab_page';

  static const String coachProfileScreen = '/coach_profile_screen';

  static const String userProfilePage = '/user_profile_page';

  static const String editUserProfileScreen = '/edit_user_profile_screen';

  static const String favoriteExercisesScreen = '/favorite_exercises_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    getStartedScreen: (context) => GetStartedScreen(),
    authenticationScreen: (context) => AuthenticationScreen(),
    signUpScreen: (context) => SignUpScreen(),
    forgotPasswordScreen: (context) => ForgotPasswordScreen(),
    resetPasswordScreen: (context) => ResetPasswordScreen(),
    genderScreen: (context) => GenderScreen(),
    ageScreen: (context) => AgeScreen(),
    weightScreen: (context) => WeightScreen(),
    heightScreen: (context) => HeightScreen(),
    homeScreen: (context) => HomeScreen(),
    adminDashbordScreen: (context) => AdminDashbordScreen(),
    userManagmentScreen: (context) => UserManagementScreen(),
    courseManagementScreen: (context) => CourseManagementScreen(),
    addUserScreen: (context) => AddUserScreen(),
    editUserScreen: (context) {
      final user = ModalRoute.of(context)!.settings.arguments as dynamic;
      return EditUserScreen(user: user);
    },
    nutritionManagementScreen: (context) => NutritionManagementScreen(),
    nutritionScreen: (context) => NutritionScreen(),
    nutritionCalculatorScreen: (context) => NutritionCalculatorScreen(),
    mealCreationScreen: (context) => MealCreationScreen(),
    exerciceManagmentScreen: (context) => ExerciceManagmentScreen(),
    chatScreen: (context) => ChatScreen(),
    workoutDetailsScreen: (context) => WorkoutDetailsScreen(),
    exerciceExplicationScreen: (context) => ExerciceExplicationScreen(),
    coachProfileScreen: (context) => CoachProfileScreen(),
    editUserProfileScreen: (context) => EditUserProfileScreen(),
    favoriteExercisesScreen: (context) => FavoriteExercisesScreen(),
    initialRoute: (context) => GetStartedScreen()
  };
}
