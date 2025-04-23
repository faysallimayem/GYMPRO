import 'package:flutter/material.dart';
import '../add_exercise_one_screen/add_exercise_one_screen.dart';
import '../add_exercise_screen/add_exercise_screen.dart';
import '../add_nutrition_screen/add_nutrition_screen.dart';
import '../add_user_screen/add_user_screen.dart';
import '../admin_dashbord_screen/admin_dashbord_screen.dart';
import '../age_screen/age_screen.dart';
import '../authentication_screen/authentication_screen.dart';
import '../chat_screen/chat_screen.dart';
import '../coach_profile_screen/coach_profile_screen.dart';
import '../edit_nutrition_screen/edit_nutrition_screen.dart';
import '../edit_user_one_screen/edit_user_one_screen.dart';
import '../edit_user_profile_screen/edit_user_profile_screen.dart';
import '../edit_user_screen/edit_user_screen.dart';
import '../exercice_explication_screen/exercice_explication_screen.dart';
import '../exercice_managment_screen/exercice_managment_screen.dart';
import '../forgot_password_screen/forgot_password_screen.dart';
import '../gender_screen/gender_screen.dart';
import '../get_started_screen/get_started_screen.dart';
import '../height_screen/height_screen.dart';
import '../home_screen/home_screen.dart';
import '../nutrition_management_screen/nutrition_management_screen.dart';
import '../sign_up_screen/sign_up_screen.dart';
import '../user_managment_screen/user_managment_screen.dart';
import '../weight_screen/weight_screen.dart';
import '../workout_details_screen/workout_details_screen.dart';

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String getStartedScreen = '/get_started_screen';

  static const String authenticationScreen = '/authentication_screen';

  static const String signUpScreen = '/sign_up_screen';

  static const String forgotPasswordScreen = '/forgot_password_screen';

  static const String genderScreen = '/gender_screen';

  static const String ageScreen = '/age_screen';

  static const String weightScreen = '/weight_screen';

  static const String heightScreen = '/height_screen';

  static const String homeScreen = '/home_screen';

  static const String homeInitialPage = '/home_initial_page';

  static const String workoutsPage = '/workouts_page';

  static const String adminDashbordScreen = '/admin_dashbord_screen';

  static const String userManagmentScreen = '/user_managment_screen';

  static const String addUserScreen = '/add_user_screen';

  static const String editUserScreen = '/edit_user_screen';

  static const String editUserOneScreen = '/edit_user_one_screen';

  static const String nutritionManagementScreen =
      '/nutrition_management_screen';

  static const String addNutritionScreen = '/add_nutrition_screen';

  static const String editNutritionScreen = '/edit_nutrition_screen';

  static const String exerciceManagmentScreen = '/exercice_managment_screen';

  static const String addExerciseScreen = '/add_exercise_screen';

  static const String addExerciseOneScreen = '/add_exercise_one_screen';

  static const String chatScreen = '/chat_screen';

  static const String workoutDetailsScreen = '/workout_details_screen';

  static const String exerciceExplicationScreen =
      '/exercice_explication_screen';

  static const String gymClassesPage = '/gym_classes_page';

  static const String gymclassesallTabPage = '/gymclassesall_tab_page';

  static const String coachProfileScreen = '/coach_profile_screen';

  static const String userProfilePage = '/user_profile_page';

  static const String editUserProfileScreen = '/edit_user_profile_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    getStartedScreen: (context) => GetStartedScreen(),
    authenticationScreen: (context) => AuthenticationScreen(),
    signUpScreen: (context) => SignUpScreen(),
    forgotPasswordScreen: (context) => ForgotPasswordScreen(),
    genderScreen: (context) => GenderScreen(),
    ageScreen: (context) => AgeScreen(),
    weightScreen: (context) => WeightScreen(),
    heightScreen: (context) => HeightScreen(),
    homeScreen: (context) => HomeScreen(),
    adminDashbordScreen: (context) => AdminDashbordScreen(),
    userManagmentScreen: (context) => UserManagmentScreen(),
    addUserScreen: (context) => AddUserScreen(),
    editUserScreen: (context) => EditUserScreen(),
    editUserOneScreen: (context) => EditUserOneScreen(),
    nutritionManagementScreen: (context) => NutritionManagementScreen(),
    addNutritionScreen: (context) => AddNutritionScreen(),
    editNutritionScreen: (context) => EditNutritionScreen(),
    exerciceManagmentScreen: (context) => ExerciceManagmentScreen(),
    addExerciseScreen: (context) => AddExerciseScreen(),
    addExerciseOneScreen: (context) => AddExerciseOneScreen(),
    chatScreen: (context) => ChatScreen(),
    workoutDetailsScreen: (context) => WorkoutDetailsScreen(),
    exerciceExplicationScreen: (context) => ExerciceExplicationScreen(),
    coachProfileScreen: (context) => CoachProfileScreen(),
    editUserProfileScreen: (context) => EditUserProfileScreen(),
    initialRoute: (context) => HeightScreen(),
  };
}
