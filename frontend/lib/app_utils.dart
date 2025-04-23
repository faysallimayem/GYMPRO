import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../app_theme.dart';

final Map<String, String> en = {
  "lbl": "←",
  "lbl_00_00": "00:00",
  "lbl_00_45": "00:45",
  "lbl_08_00_09_00": "08:00 - 09:00",
  "lbl_10_00_11_00": "10:00 - 11:00",
  "lbl_10_24_am": "10:24 AM",
  "lbl_10_26_am": "10:26 AM",
  "lbl_10_28_am": "10:28 AM",
  "lbl_10_30_am": "10:30 AM",
  "lbl_115": "115",
  "lbl_12": "12",
  "lbl_12_spots_left": "12 spots left",
  "lbl_13_00_14_00": "13:00 - 14:00",
  "lbl_14_00_15_00": "14:00 - 15:00",
  "lbl_15": "15",
  "lbl_155": "155",
  "lbl_160": "160",
  "lbl_165": "165",
  "lbl_16_00_17_00": "16:00 - 17:00",
  "lbl_170": "170",
  "lbl_175": "175",
  "lbl_17_00_18_00": "17:00 - 18:00",
  "lbl_185cm": "185cm",
  "lbl_18_00_19_00": "18:00 - 19:00",
  "lbl_1_spots_left": "1 spots left",
  "lbl_25_completed": "25% completed",
  "lbl_26": "26",
  "lbl_27": "27",
  "lbl_28": "28",
  "lbl_29": "29",
  "lbl_30": "30",
  "lbl_30_min": "30 min",
  "lbl_30_minutes": "30 minutes",
  "lbl_350": "350",
  "lbl_3_sets_left": "3 sets left",
  "lbl_45": "45",
  "lbl_45_min": "45 min",
  "lbl_5": "5",
  "lbl_50_min": "50 min",
  "lbl_5_spots_left": "5 spots left",
  "lbl_60_min": "60 min",
  "lbl_73": "73",
  "lbl_74": "74",
  "lbl_75": "75",
  "lbl_76": "76",
  "lbl_77": "77",
  "lbl_80kg": "80kg",
  "lbl_8_spots_left": "8 spots left",
  "lbl_actions": "Actions",
  "lbl_add_exercise": "Add Exercise",
  "lbl_add_new_user": "Add new User",
  "lbl_add_number": "Add number",
  "lbl_add_nutrition": "Add Nutrition",
  "lbl_add_user": "Add User",
  "lbl_admin": "Admin",
  "lbl_admin_dashbrod": "Admin Dashbrod",
  "lbl_all_classes": "All Classes",
  "lbl_an_account": "an account",
  "lbl_back": "Back",
  "lbl_bench_press": "Bench Press",
  "lbl_biceps_curls": "Biceps Curls",
  "lbl_birth_date": "Birth Date",
  "lbl_body_jump": "Body Jump",
  "lbl_body_pump": "Body Pump",
  "lbl_book": "Book",
  "lbl_booked": " Booked",
  "lbl_calories": "Calories",
  "lbl_cancel": "Cancel",
  "lbl_carbs": "Carbs",
  "lbl_cardio": "Cardio",
  "lbl_chat": "Chat",
  "lbl_chest_arms": "Chest & Arms",
  "lbl_class_full": "Class Full",
  "lbl_classes": "classes",
  "lbl_client": "Client",
  "lbl_cm": "cm",
  "lbl_coach": "Coach",
  "lbl_coach_details": "Coach Details",
  "lbl_coach_name": "Coach Name",
  "lbl_coaches": "Coaches",
  "lbl_coachs": "Coachs",
  "lbl_confirm": "Confirm",
  "lbl_continue": "Continue",
  "lbl_crossfit": "CrossFit",
  "lbl_date_of_birth": "Date of Birth",
  "lbl_dd_mm_yy": "DD/MM/YY",
  "lbl_delete": "Delete",
  "lbl_description": "Description",
  "lbl_duration": "Duration:",
  "lbl_edit": "Edit",
  "lbl_edit_exercise": "Edit Exercise",
  "lbl_edit_nutrition": "Edit Nutrition ",
  "lbl_edit_profile": "Edit Profile",
  "lbl_edit_user": "Edit User",
  "lbl_eg_apple": "Eg: Apple",
  "lbl_eg_jhon": "Eg: Jhon",
  "lbl_eg_wick": "Eg: Wick",
  "lbl_email": "Email",
  "lbl_email_account": "Email account",
  "lbl_email_address": "Email Address",
  "lbl_emily_waterson": " Emily Waterson",
  "lbl_emma_jhonson": "Emma Jhonson",
  "lbl_emma_wilson": " Emma Wilson",
  "lbl_end_workout": "End Workout",
  "lbl_exercise": "Exercise:",
  "lbl_exercise_name": "Exercise Name",
  "lbl_exercises": "Exercises",
  "lbl_fat": "Fat",
  "lbl_female": "Female",
  "lbl_first_name": "First name",
  "lbl_first_name2": "First Name",
  "lbl_fitness_coach": "Fitness Coach",
  "lbl_forgot_password": "Forgot Password",
  "lbl_full": "Full",
  "lbl_full_body": "Full Body",
  "lbl_gender": "Gender",
  "lbl_get_started": "GET STARTED",
  "lbl_gym": "GYM",
  "lbl_gym_pro": "GYM PRO",
  "lbl_height": "Height",
  "lbl_hiit": "HIIT",
  "lbl_i_already_have": "I already have ",
  "lbl_id": "ID",
  "lbl_james": "James",
  "lbl_jhon": "Jhon",
  "lbl_john": "John",
  "lbl_katty_perry": "Katty Perry",
  "lbl_kg": "kg",
  "lbl_legs_core": "Legs & Core",
  "lbl_lisa": "Lisa",
  "lbl_log_in": "Log in",
  "lbl_log_out": "Log out",
  "lbl_male": "Male",
  "lbl_minutes": "Minutes",
  "lbl_mobile_number": "Mobile number ",
  "lbl_mohamed": "Mohamed",
  "lbl_muscle_group": "Muscle Group ",
  "lbl_muscle_group2": "Muscle Group",
  "lbl_name": "Name",
  "lbl_next": "Next",
  "lbl_nick": "Nick",
  "lbl_none": "None",
  "lbl_password": "Password",
  "lbl_per_100g": "Per 100g",
  "lbl_per_100g2": "per 100g",
  "lbl_pilates": "Pilates",
  "lbl_previous": "Previous",
  "lbl_pro": " PRO",
  "lbl_profile": "Profile",
  "lbl_protein": "Protein",
  "lbl_pull_ups": "Pull ups",
  "lbl_push_ups": "Push ups",
  "lbl_redo_workout": "Redo workout",
  "lbl_redo_workouts": "Redo workouts",
  "lbl_reps": "Reps:",
  "lbl_role": "Role",
  "lbl_sarah": "Sarah",
  "lbl_save_change": "Save change",
  "lbl_search_by_name": "Search by name",
  "lbl_second_name": "Second name",
  "lbl_second_name2": "Second Name",
  "lbl_send_via_email": "Send via Email",
  "lbl_set_2_4": "Set 2/4",
  "lbl_sets": "Sets:",
  "lbl_settings": "Settings",
  "lbl_sign_up": "Sign up ",
  "lbl_spinning": "Spinning",
  "lbl_start_workout": "Start workout",
  "lbl_start_workout2": "start Workout",
  "lbl_strength": "Strength",
  "lbl_today_10_24_am": "Today, 10:24 AM",
  "lbl_usa": "USA",
  "lbl_user_managment": "User Managment",
  "lbl_username": "Username",
  "lbl_weekly_progress": "Weekly Progress",
  "lbl_weight": "Weight",
  "lbl_yoga": "Yoga",
  "lbl_yoga_flow": "Yoga Flow",
  "lbl_your_name": "Your name",
  "lbl_your_name2": "your name",
  "msg": "*****************",
  "msg_10_exercises_40": "10 exercises • 40 min",
  "msg_12_exercises_45": "12 exercises • 45 min",
  "msg_15_exercises_60": "15 exercises • 60 min",
  "msg_3_sets_15_reps": "3 sets • 15 reps",
  "msg_4_sets_12_reps": "4 sets • 12 reps",
  "msg_8_exercises_35": "8 exercises • 35 min",
  "msg_achieve_greatness": "Achieve Greatness",
  "msg_add_your_message": "Add your message ",
  "msg_back_shoulders": "Back & Shoulders",
  "msg_coachname_example_com": "coachname@example.com",
  "msg_confirm_password": "Confirm password",
  "msg_create_an_account": "Create an Account",
  "msg_describe_the_exercise": "Describe the exercise...",
  "msg_eg_chest_legs": "eg:Chest/legs...",
  "msg_enter_your_email": "Enter your email address...",
  "msg_enter_your_first": "     Enter your first name..",
  "msg_enter_your_second": "     Enter your second name .. ",
  "msg_enter_your_username": "     Enter your username..",
  "msg_exercice_managment": "Exercice Managment",
  "msg_exercise_managment": "Exercise Managment",
  "msg_help_us_finish_setting": "Help us finish setting up your account.",
  "msg_how_old_are_you": "How Old Are You?",
  "msg_i_already_have_an": "I already have an account",
  "msg_login_to_your_account": "Login to your Account",
  "msg_nutrition_managment": "Nutrition Managment",
  "msg_personal_information": "Personal Information",
  "msg_please_select_the":
      "Please select the following options to reset your password.",
  "msg_today_s_workouts": "Today’s Workouts",
  "msg_welcome_back_nick": "Welcome back, Nick!",
  "msg_what_is_your_height": "What Is Your height?",
  "msg_what_is_your_weight": "What Is Your Weight?",
  "msg_what_s_your_gender": "What’s Your Gender",
  "msg_workout_programs": "Workout Programs",
  "msg_your_last_workout": "Your last workout:",
  "msg_your_next_workout": "Your next workout:",
  "msg_yourname_exapmle_com": "yourname@exapmle.com",
  "msg_yourname_gmail_com": "yourname@gmail.com",
  "msg_network_err": "Network Error",
  "msg_something_went_wrong": "Something Went Wrong!"
};
final Map<String, String> ar = {
  "lbl": "←",
  "lbl_00_00": "00:00",
  "lbl_00_45": "00:45",
  "lbl_08_00_09_00": "08:00 - 09:00",
  "lbl_10_00_11_00": "10:00 - 11:00",
  "lbl_10_24_am": "10:24 AM",
  "lbl_10_26_am": "10:26 AM",
  "lbl_10_28_am": "10:28 AM",
  "lbl_10_30_am": "10:30 AM",
  "lbl_115": "115",
  "lbl_12": "12",
  "lbl_12_spots_left": "12 spots left",
  "lbl_13_00_14_00": "13:00 - 14:00",
  "lbl_14_00_15_00": "14:00 - 15:00",
  "lbl_15": "15",
  "lbl_155": "155",
  "lbl_160": "160",
  "lbl_165": "165",
  "lbl_16_00_17_00": "16:00 - 17:00",
  "lbl_170": "170",
  "lbl_175": "175",
  "lbl_17_00_18_00": "17:00 - 18:00",
  "lbl_185cm": "185cm",
  "lbl_18_00_19_00": "18:00 - 19:00",
  "lbl_1_spots_left": "1 spots left",
  "lbl_25_completed": "25% completed",
  "lbl_26": "26",
  "lbl_27": "27",
  "lbl_28": "28",
  "lbl_29": "29",
  "lbl_30": "30",
  "lbl_30_min": "30 min",
  "lbl_30_minutes": "30 minutes",
  "lbl_350": "350",
  "lbl_3_sets_left": "3 sets left",
  "lbl_45": "45",
  "lbl_45_min": "45 min",
  "lbl_5": "5",
  "lbl_50_min": "50 min",
  "lbl_5_spots_left": "5 spots left",
  "lbl_60_min": "60 min",
  "lbl_73": "73",
  "lbl_74": "74",
  "lbl_75": "75",
  "lbl_76": "76",
  "lbl_77": "77",
  "lbl_80kg": "80kg",
  "lbl_8_spots_left": "8 spots left",
  "lbl_actions": "Actions",
  "lbl_add_exercise": "Add Exercise",
  "lbl_add_new_user": "Add new User",
  "lbl_add_number": "Add number",
  "lbl_add_nutrition": "Add Nutrition",
  "lbl_add_user": "Add User",
  "lbl_admin": "Admin",
  "lbl_admin_dashbrod": "Admin Dashbrod",
  "lbl_all_classes": "All Classes",
  "lbl_an_account": "an account",
  "lbl_back": "Back",
  "lbl_bench_press": "Bench Press",
  "lbl_biceps_curls": "Biceps Curls",
  "lbl_birth_date": "Birth Date",
  "lbl_body_jump": "Body Jump",
  "lbl_body_pump": "Body Pump",
  "lbl_book": "Book",
  "lbl_booked": " Booked",
  "lbl_calories": "Calories",
  "lbl_cancel": "Cancel",
  "lbl_carbs": "Carbs",
  "lbl_cardio": "Cardio",
  "lbl_chat": "Chat",
  "lbl_chest_arms": "Chest & Arms",
  "lbl_class_full": "Class Full",
  "lbl_classes": "classes",
  "lbl_client": "Client",
  "lbl_cm": "cm",
  "lbl_coach": "Coach",
  "lbl_coach_details": "Coach Details",
  "lbl_coach_name": "Coach Name",
  "lbl_coaches": "Coaches",
  "lbl_coachs": "Coachs",
  "lbl_confirm": "Confirm",
  "lbl_continue": "Continue",
  "lbl_crossfit": "CrossFit",
  "lbl_date_of_birth": "Date of Birth",
  "lbl_dd_mm_yy": "DD/MM/YY",
  "lbl_delete": "Delete",
  "lbl_description": "Description",
  "lbl_duration": "Duration:",
  "lbl_edit": "Edit",
  "lbl_edit_exercise": "Edit Exercise",
  "lbl_edit_nutrition": "Edit Nutrition ",
  "lbl_edit_profile": "Edit Profile",
  "lbl_edit_user": "Edit User",
  "lbl_eg_apple": "Eg: Apple",
  "lbl_eg_jhon": "Eg: Jhon",
  "lbl_eg_wick": "Eg: Wick",
  "lbl_email": "Email",
  "lbl_email_account": "Email account",
  "lbl_email_address": "Email Address",
  "lbl_emily_waterson": " Emily Waterson",
  "lbl_emma_jhonson": "Emma Jhonson",
  "lbl_emma_wilson": " Emma Wilson",
  "lbl_end_workout": "End Workout",
  "lbl_exercise": "Exercise:",
  "lbl_exercise_name": "Exercise Name",
  "lbl_exercises": "Exercises",
  "lbl_fat": "Fat",
  "lbl_female": "Female",
  "lbl_first_name": "First name",
  "lbl_first_name2": "First Name",
  "lbl_fitness_coach": "Fitness Coach",
  "lbl_forgot_password": "Forgot Password",
  "lbl_full": "Full",
  "lbl_full_body": "Full Body",
  "lbl_gender": "Gender",
  "lbl_get_started": "GET STARTED",
  "lbl_gym": "GYM",
  "lbl_gym_pro": "GYM PRO",
  "lbl_height": "Height",
  "lbl_hiit": "HIIT",
  "lbl_i_already_have": "I already have ",
  "lbl_id": "ID",
  "lbl_james": "James",
  "lbl_jhon": "Jhon",
  "lbl_john": "John",
  "lbl_katty_perry": "Katty Perry",
  "lbl_kg": "kg",
  "lbl_legs_core": "Legs & Core",
  "lbl_lisa": "Lisa",
  "lbl_log_in": "Log in",
  "lbl_log_out": "Log out",
  "lbl_male": "Male",
  "lbl_minutes": "Minutes",
  "lbl_mobile_number": "Mobile number ",
  "lbl_mohamed": "Mohamed",
  "lbl_muscle_group": "Muscle Group ",
  "lbl_muscle_group2": "Muscle Group",
  "lbl_name": "Name",
  "lbl_next": "Next",
  "lbl_nick": "Nick",
  "lbl_none": "None",
  "lbl_password": "Password",
  "lbl_per_100g": "Per 100g",
  "lbl_per_100g2": "per 100g",
  "lbl_pilates": "Pilates",
  "lbl_previous": "Previous",
  "lbl_pro": " PRO",
  "lbl_profile": "Profile",
  "lbl_protein": "Protein",
  "lbl_pull_ups": "Pull ups",
  "lbl_push_ups": "Push ups",
  "lbl_redo_workout": "Redo workout",
  "lbl_redo_workouts": "Redo workouts",
  "lbl_reps": "Reps:",
  "lbl_role": "Role",
  "lbl_sarah": "Sarah",
  "lbl_save_change": "Save change",
  "lbl_search_by_name": "Search by name",
  "lbl_second_name": "Second name",
  "lbl_second_name2": "Second Name",
  "lbl_send_via_email": "Send via Email",
  "lbl_set_2_4": "Set 2/4",
  "lbl_sets": "Sets:",
  "lbl_settings": "Settings",
  "lbl_sign_up": "Sign up ",
  "lbl_spinning": "Spinning",
  "lbl_start_workout": "Start workout",
  "lbl_start_workout2": "start Workout",
  "lbl_strength": "Strength",
  "lbl_today_10_24_am": "Today, 10:24 AM",
  "lbl_usa": "USA",
  "lbl_user_managment": "User Managment",
  "lbl_username": "Username",
  "lbl_weekly_progress": "Weekly Progress",
  "lbl_weight": "Weight",
  "lbl_yoga": "Yoga",
  "lbl_yoga_flow": "Yoga Flow",
  "lbl_your_name": "Your name",
  "lbl_your_name2": "your name",
  "msg": "*****************",
  "msg_10_exercises_40": "10 exercises • 40 min",
  "msg_12_exercises_45": "12 exercises • 45 min",
  "msg_15_exercises_60": "15 exercises • 60 min",
  "msg_3_sets_15_reps": "3 sets • 15 reps",
  "msg_4_sets_12_reps": "4 sets • 12 reps",
  "msg_8_exercises_35": "8 exercises • 35 min",
  "msg_achieve_greatness": "Achieve Greatness",
  "msg_add_your_message": "Add your message ",
  "msg_back_shoulders": "Back & Shoulders",
  "msg_coachname_example_com": "coachname@example.com",
  "msg_confirm_password": "Confirm password",
  "msg_create_an_account": "Create an Account",
  "msg_describe_the_exercise": "Describe the exercise...",
  "msg_eg_chest_legs": "eg:Chest/legs...",
  "msg_enter_your_email": "Enter your email address...",
  "msg_enter_your_first": "     Enter your first name..",
  "msg_enter_your_second": "     Enter your second name .. ",
  "msg_enter_your_username": "     Enter your username..",
  "msg_exercice_managment": "Exercice Managment",
  "msg_exercise_managment": "Exercise Managment",
  "msg_help_us_finish_setting": "Help us finish setting up your account.",
  "msg_how_old_are_you": "How Old Are You?",
  "msg_i_already_have_an": "I already have an account",
  "msg_login_to_your_account": "Login to your Account",
  "msg_nutrition_managment": "Nutrition Managment",
  "msg_personal_information": "Personal Information",
  "msg_please_select_the":
      "Please select the following options to reset your password.",
  "msg_today_s_workouts": "Today’s Workouts",
  "msg_welcome_back_nick": "Welcome back, Nick!",
  "msg_what_is_your_height": "What Is Your height?",
  "msg_what_is_your_weight": "What Is Your Weight?",
  "msg_what_s_your_gender": "What’s Your Gender",
  "msg_workout_programs": "Workout Programs",
  "msg_your_last_workout": "Your last workout:",
  "msg_your_next_workout": "Your next workout:",
  "msg_yourname_exapmle_com": "yourname@exapmle.com",
  "msg_yourname_gmail_com": "yourname@gmail.com",
  "msg_network_err": "Network Error",
  "msg_something_went_wrong": "Something Went Wrong!"
};
// These are the Viewport values of your Figma Design.
// These are used in the code as a reference to create your UI Responsively.
const num FIGMA_DESIGN_WIDTH = 430;
const num FIGMA_DESIGN_HEIGHT = 932;
const num FIGMA_DESIGN_STATUS_BAR = 0;
const String dateTimeFormatPattern = 'dd/MM/yyyy';

extension ResponsiveExtension on num {
  double get _width => SizeUtils.width;
  double get h => ((this * _width) / FIGMA_DESIGN_WIDTH);
  double get fSize => ((this * _width) / FIGMA_DESIGN_WIDTH);
}

extension FormatExtension on double {
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(this.toStringAsFixed(fractionDigits));
  }

  double isNonZero({num defaultValue = 0.0}) {
    return this > 0 ? this : defaultValue.toDouble();
  }
}

extension DateTimeExtension on DateTime {
  String format({
    String pattern = dateTimeFormatPattern,
    String? locale,
  }) {
    if (locale != null && locale.isNotEmpty) {
      initializeDateFormatting(locale);
    }
    return DateFormat(pattern, locale).format(this);
  }
}

enum DeviceType { mobile, tablet, desktop }

typedef ResponsiveBuild = Widget Function(
    BuildContext context, Orientation orientation, DeviceType deviceType);

// ignore_for_file: must_be_immutable
class ImageConstant {
  // Image folder path
  static String imagePath = 'assets/images';

// Common images
  static String img = '$imagePath/img_.png';

  static String imgLock = '$imagePath/img_lock.svg';

  static String imgBag = '$imagePath/img_bag.svg';

  static String imgEye = '$imagePath/img_eye.svg';

  static String imgFissuser = '$imagePath/img_fissuser.svg';

  static String imgLockPrimary = '$imagePath/img_lock_primary.svg';

  static String imgArrowleft = '$imagePath/img_arrowleft.svg';

  static String imgBotGenderMale = '$imagePath/img_bot_gender_male.svg';

  static String imgLaptop = '$imagePath/img_laptop.svg';

  static String imgPolygon1 = '$imagePath/img_polygon_1.svg';

  static String imgUser = '$imagePath/img_user.svg';

  static String imgRectangle37 = '$imagePath/img_rectangle_37.png';

  static String imgEllipse10 = '$imagePath/img_ellipse_10.png';

  static String imgEllipse5 = '$imagePath/img_ellipse_5.png';

  static String imgEllipse6 = '$imagePath/img_ellipse_6.png';

  static String imgHome = '$imagePath/img_home.svg';

  static String imgMaximize = '$imagePath/img_maximize.svg';

  static String imgMedicalIconINutrition ='$imagePath/img_medical_icon_i_nutrition.svg';

  static String imgCalendar = '$imagePath/img_calendar.svg';

  static String imgLockGray600 = '$imagePath/img_lock_gray_600.svg';

  static String img0x0 = '$imagePath/img__0x0.png';

  static String imgClock = '$imagePath/img_clock.svg';

  static String imgRectangle188 = '$imagePath/img_rectangle_188.png';

  static String imgRectangle190 = '$imagePath/img_rectangle_190.png';

  static String imgRectangle194 = '$imagePath/img_rectangle_194.png';

  static String imgRectangle192 = '$imagePath/img_rectangle_192.png';

  static String imgRectangle195 = '$imagePath/img_rectangle_195.png';

  static String imgRectangle198 = '$imagePath/img_rectangle_198.png';

  static String imgRectangle197 = '$imagePath/img_rectangle_197.png';

  static String imgRectangle196 = '$imagePath/img_rectangle_196.png';

  static String imgRectangle199 = '$imagePath/img_rectangle_199.png';

  static String imgLockBlack900 = '$imagePath/img_lock_black_900.svg';

  static String imgMedicalIconINutritionBlack900 ='$imagePath/img_medical_icon_i_nutrition_black_900.svg';

  static String imgMaximizeBlack900 = '$imagePath/img_maximize_black_900.svg';

  static String imgRewind = '$imagePath/img_rewind.svg';

  static String img10 = '$imagePath/img_10.png';

  static String imgArrowdown = '$imagePath/img_arrowdown.svg';

  static String img1062x48 = '$imagePath/img_10_62x48.png';

  static String img1062x62 = '$imagePath/img_10_62x62.png';

  static String imgArrowLeftBlack900 ='$imagePath/img_arrow_left_black_900.svg';

  static String imgCameraGray600 = '$imagePath/img_camera_gray_600.svg';

  static String imgImage = '$imagePath/img_image.svg';

  static String imgSave = '$imagePath/img_save.svg';

  static String imgRectangle211 = '$imagePath/img_rectangle_211.png';

  static String imgImage84x98 = '$imagePath/img_image_84x98.png';

  static String imgVectorOrangeA70001 ='$imagePath/img_vector_orange_a700_01.svg';

  static String imgImage1 = '$imagePath/img_image_1.png';

  static String imgFrame1000006648 = '$imagePath/img_frame_1000006648.png';

  static String imgContrast = '$imagePath/img_contrast.svg';

  static String imgVectorBlack900 = '$imagePath/img_vector_black_900.svg';

  static String imgSettingsBlack900 = '$imagePath/img_settings_black_900.svg';

  static String imgHeartLine = '$imagePath/img_heart_line.svg';

  static String imgArrowrightWhiteA700 ='$imagePath/img_arrowright_white_a700.svg';

  static String imgClose = '$imagePath/img_close.svg';

  static String imgEllipse3382 = '$imagePath/img_ellipse_3382.png';

  static String imgCheckmark = '$imagePath/img_checkmark.svg';

  static String imgUserPrimary = '$imagePath/img_user_primary.svg';

  static String imgCamera = '$imagePath/img_camera.svg';

  static String imgVectorPrimary = '$imagePath/img_vector_primary.svg';

  static String imgFormkitDate = '$imagePath/img_formkit_date.svg';

  static String imgVector = '$imagePath/img_vector.svg';

  static String imgSettingsPrimary = '$imagePath/img_settings_primary.svg';

  static String imgMaterialSymbol = '$imagePath/img_material_symbol.svg';

  static String imgCameraBlack900 = '$imagePath/img_camera_black_900.svg';

  static String imgLockPrimary48x48 = '$imagePath/img_lock_primary_48x48.svg';

  static String imgArrowRight = '$imagePath/img_arrow_right.svg';

  static String imgSearch = '$imagePath/img_search.svg';

  static String imgUserPrimary48x48 = '$imagePath/img_user_primary_48x48.svg';

  static String imgEllipse3370 = '$imagePath/img_ellipse_3370.png';

  static String imageNotFound = 'assets/images/image_not_found.png';
}

class Sizer extends StatelessWidget {
  const Sizer({Key? key, required this.builder}) : super(key: key);

  /// Builds the widget whenever the orientation changes.
  final ResponsiveBuild builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeUtils.setScreenSize(constraints, orientation);
        return builder(context, orientation, SizeUtils.deviceType);
      });
    });
  }
}

// ignore_for_file: must_be_immutable
class SizeUtils {
  /// Device's BoxConstraints
  static late BoxConstraints boxConstraints;

  /// Device's Orientation
  static late Orientation orientation;

  /// Type of Device
  ///
  /// This can either be mobile or tablet
  static late DeviceType deviceType;

  /// Device's Height
  static late double height;

  /// Device's Width
  static late double width;

  static void setScreenSize(
    BoxConstraints constraints,
    Orientation currentOrientation,
  ) {
    boxConstraints = constraints;
    orientation = currentOrientation;
    if (orientation == Orientation.portrait) {
      width =
          boxConstraints.maxWidth.isNonZero(defaultValue: FIGMA_DESIGN_WIDTH);
      height = boxConstraints.maxHeight.isNonZero();
    } else {
      width =
          boxConstraints.maxHeight.isNonZero(defaultValue: FIGMA_DESIGN_WIDTH);
      height = boxConstraints.maxWidth.isNonZero();
    }
    deviceType = DeviceType.mobile;
  }
}
