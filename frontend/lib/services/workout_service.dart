// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
// Import AuthService for consistent token key

class WorkoutService extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _workouts = [];
  Map<String, dynamic>? _selectedWorkout;
  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _favoriteWorkouts = [];
  List<Map<String, dynamic>> _favoriteExercises =
      []; // Added favorite exercises list
  List<Map<String, dynamic>> _workoutsByMuscleGroup = [];

  // Use the same token key as AuthService
  static const String _tokenKey = 'auth_token';

  // Getters
  List<Map<String, dynamic>> get workouts => _workouts;
  Map<String, dynamic>? get selectedWorkout => _selectedWorkout;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get favoriteWorkouts => _favoriteWorkouts;
  List<Map<String, dynamic>> get favoriteExercises =>
      _favoriteExercises; // Exercise favorites getter
  List<Map<String, dynamic>> get workoutsByMuscleGroup =>
      _workoutsByMuscleGroup;

  // Initialize favorites when app starts
  Future<void> initFavorites() async {
    try {
      // Only initialize if user is logged in (has a token)
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey); // Use consistent key

      if (token != null) {
        // If logged in, load favorites from server
        await fetchFavoriteExercises();
        await fetchFavoriteWorkouts();
      }
    } catch (e) {
      print('Error initializing favorites: $e');
    }
  }

  // Fetch all workouts from the API
  Future<void> fetchWorkouts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get token using consistent key
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token == null) {
        _error = 'You need to be logged in to view workouts';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await _apiService.get('workouts', token: token);

      if (response is List) {
        _workouts = _convertToMapList(response);
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['data'] is List) {
          _workouts = _convertToMapList(response['data'] as List);
        } else {
          // If it's a map but doesn't have the expected structure, create a list with this single item
          _workouts = [Map<String, dynamic>.from(response)];
        }
      } else {
        _workouts = [];
      }

      // Fetch favorite workouts and exercises from server
      await fetchFavoriteWorkouts();
      await fetchFavoriteExercises();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching workouts: $e');
      _error = 'Failed to load workouts: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch favorite exercises from the server
  Future<void> fetchFavoriteExercises() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey); // Use consistent key

      if (token == null) {
        print('Token is null, cannot fetch favorite exercises');
        return;
      }

      final response =
          await _apiService.get('favorites/exercises', token: token);

      if (response is List) {
        _favoriteExercises = _convertToMapList(response);
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['data'] is List) {
          _favoriteExercises = _convertToMapList(response['data'] as List);
        } else {
          _favoriteExercises = [Map<String, dynamic>.from(response)];
        }
      } else {
        _favoriteExercises = [];
      }

      notifyListeners();
    } catch (e) {
      print('Error fetching favorite exercises: $e');
      // Keep existing favorites in case of error
    }
  }

  // Fetch favorite workouts from the server
  Future<void> fetchFavoriteWorkouts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey); // Use consistent key

      if (token == null) {
        print('Token is null, cannot fetch favorite workouts');
        return;
      }

      final response =
          await _apiService.get('favorites/workouts', token: token);

      if (response is List) {
        _favoriteWorkouts = _convertToMapList(response);
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['data'] is List) {
          _favoriteWorkouts = _convertToMapList(response['data'] as List);
        } else {
          _favoriteWorkouts = [Map<String, dynamic>.from(response)];
        }
      } else {
        _favoriteWorkouts = [];
      }

      notifyListeners();
    } catch (e) {
      print('Error fetching favorite workouts: $e');
      // Keep existing favorites in case of error
    }
  }

  // Helper method to convert List<dynamic> to List<Map<String, dynamic>>
  List<Map<String, dynamic>> _convertToMapList(List<dynamic> list) {
    return list
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  // Create a new workout
  Future<bool> createWorkout(Map<String, dynamic> workoutData) async {
    // Existing code...
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get token using consistent key
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token == null) {
        _error = 'You need to be logged in to create a workout';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await _apiService.post('workouts', workoutData, token: token);

      // Add the new workout to the list
      await fetchWorkouts(); // Refresh the list after adding

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error creating workout: $e');
      _error = 'Failed to create workout: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get workout details by ID
  Future<void> getWorkoutDetails(int id) async {
    // Existing code...
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get token using consistent key
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token == null) {
        _error = 'You need to be logged in to view workout details';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await _apiService.get('workouts/$id', token: token);
      _selectedWorkout = response is Map<String, dynamic>
          ? response
          : {'error': 'Invalid response format'};

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching workout details: $e');
      _error = 'Failed to load workout details: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a workout to favorites (using server API)
  Future<void> addToFavorites(Map<String, dynamic> workout) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey); // Use consistent key

      if (token == null) {
        print('Token is null, cannot add to favorites');
        return;
      }

      // Check if already in favorites to avoid duplicates
      if (!_favoriteWorkouts.any((w) => w['id'] == workout['id'])) {
        // Optimistically add to local list first for responsive UI
        _favoriteWorkouts.add(workout);
        notifyListeners();

        // Then update on server
        await _apiService.post(
            'favorites/workouts', {'workoutId': workout['id']},
            token: token);

        // Refresh favorites from server
        await fetchFavoriteWorkouts();
      }
    } catch (e) {
      print('Error adding workout to favorites: $e');
      // If there's an error, remove from local list
      _favoriteWorkouts.removeWhere((w) => w['id'] == workout['id']);
      notifyListeners();
    }
  }

  // Remove a workout from favorites (using server API)
  Future<void> removeFromFavorites(int workoutId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey); // Use consistent key

      if (token == null) {
        print('Token is null, cannot remove from favorites');
        return;
      }

      // Optimistically remove from local list first for responsive UI
      _favoriteWorkouts.removeWhere((w) => w['id'] == workoutId);
      notifyListeners();

      // Then update on server
      await _apiService.delete('favorites/workouts/$workoutId', token: token);
    } catch (e) {
      print('Error removing workout from favorites: $e');
      // Refresh favorites from server in case of error
      await fetchFavoriteWorkouts();
    }
  }

  // Add an exercise to favorites (using server API)
  Future<void> addExerciseToFavorites(Map<String, dynamic> exercise) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey); // Use consistent key

      if (token == null) {
        print('Token is null, cannot add to favorites');
        return;
      }

      if (!isExerciseFavorite(exercise)) {
        // Optimistically add to local list first for responsive UI
        _favoriteExercises.add(exercise);
        notifyListeners();

        // Then update on server
        await _apiService.post(
            'favorites/exercises', {'exerciseId': exercise['id']},
            token: token);

        // Refresh favorites from server
        await fetchFavoriteExercises();
      }
    } catch (e) {
      print('Error adding exercise to favorites: $e');
      // Remove from local list if server update fails
      _favoriteExercises.removeWhere((e) => e['id'] == exercise['id']);
      notifyListeners();
    }
  }

  // Remove an exercise from favorites (using server API)
  Future<void> removeExerciseFromFavorites(
      Map<String, dynamic> exercise) async {
    final exerciseId = exercise['id'];

    if (exerciseId == null) {
      print('Exercise ID is null, cannot remove from favorites');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey); // Use consistent key

      if (token == null) {
        print('Token is null, cannot remove from favorites');
        return;
      }

      // Optimistically remove from local list first
      _favoriteExercises.removeWhere((e) => e['id'] == exerciseId);
      notifyListeners();

      // Then update on server
      await _apiService.delete('favorites/exercises/$exerciseId', token: token);
    } catch (e) {
      print('Error removing exercise from favorites: $e');
      // Refresh from server in case of error
      await fetchFavoriteExercises();
    }
  }

  // Toggle exercise favorite status
  Future<bool> toggleExerciseFavorite(Map<String, dynamic> exercise) async {
    if (isExerciseFavorite(exercise)) {
      await removeExerciseFromFavorites(exercise);
      return false;
    } else {
      await addExerciseToFavorites(exercise);
      return true;
    }
  }

  // Check if an exercise is a favorite
  bool isExerciseFavorite(Map<String, dynamic> exercise) {
    final exerciseId = exercise['id'];

    if (exerciseId == null) {
      return false;
    }

    return _favoriteExercises.any((e) => e['id'] == exerciseId);
  }

  // Check if a workout is in favorites
  bool isInFavorites(int workoutId) {
    return _favoriteWorkouts.any((w) => w['id'] == workoutId);
  }

  // Clear any errors
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Update an existing workout
  Future<bool> updateWorkout(int id, Map<String, dynamic> workoutData) async {
    // Existing code...
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get token using consistent key
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token == null) {
        _error = 'You need to be logged in to update a workout';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await _apiService.patch('workouts/$id', workoutData, token: token);

      // Refresh the workout list after updating
      await fetchWorkouts();

      // If the updated workout is the currently selected one, refresh it
      if (_selectedWorkout != null && _selectedWorkout!['id'] == id) {
        await getWorkoutDetails(id);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error updating workout: $e');
      _error = 'Failed to update workout: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete a workout
  Future<bool> deleteWorkout(int id) async {
    // Existing code...
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get token using consistent key
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token == null) {
        _error = 'You need to be logged in to delete a workout';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await _apiService.delete('workouts/$id', token: token);

      // Remove the workout from the list
      _workouts.removeWhere((workout) => workout['id'] == id);

      // If the deleted workout is in favorites, remove it
      if (_favoriteWorkouts.any((w) => w['id'] == id)) {
        await removeFromFavorites(id);
      }

      // If the deleted workout is the currently selected one, clear the selection
      if (_selectedWorkout != null && _selectedWorkout!['id'] == id) {
        _selectedWorkout = null;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error deleting workout: $e');
      _error = 'Failed to delete workout: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Fetch workouts by muscle group
  Future<void> fetchWorkoutsByMuscleGroup(String muscleGroup) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print(
          'WorkoutService: Starting to fetch workouts for muscle group: $muscleGroup');

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey); // Use consistent key

      if (token == null) {
        print('WorkoutService: ERROR - No auth token available');
        _error = 'You need to be logged in to view workouts';
        _isLoading = false;
        notifyListeners();
        return;
      }

      print('WorkoutService: Token available, proceeding with API call');

      try {
        print(
            'WorkoutService: Making API call to: exercises/muscle-group/$muscleGroup');
        final response = await _apiService
            .get('exercises/muscle-group/$muscleGroup', token: token);
        print('WorkoutService: Raw API response: $response');
        print('WorkoutService: Response type: ${response.runtimeType}');

        if (response is List) {
          // Convert the list of exercises into a format similar to a workout
          print(
              'WorkoutService: Received ${response.length} exercises for muscle group: $muscleGroup');

          // Create a synthetic workout with all the exercises
          final allExercises = _convertToMapList(response);

          if (allExercises.isNotEmpty) {
            Map<String, dynamic> muscleGroupWorkout = {
              'id': 0, // Synthetic ID
              'name':
                  '${muscleGroup.substring(0, 1).toUpperCase()}${muscleGroup.substring(1)} Exercises',
              'description': 'All $muscleGroup exercises',
              'exercises': allExercises,
              'duration': allExercises.length *
                  2, // Estimate duration based on exercise count
            };

            _workoutsByMuscleGroup = [muscleGroupWorkout];
            _selectedWorkout = muscleGroupWorkout;
            print(
                'WorkoutService: Created synthetic workout with ${allExercises.length} exercises');
          } else {
            print(
                'WorkoutService: No exercises found for muscle group: $muscleGroup');
            _workoutsByMuscleGroup = [];
            _error = 'No exercises found for this muscle group';
          }
        } else if (response is Map<String, dynamic>) {
          print('WorkoutService: Response is a Map, checking structure...');
          if (response.containsKey('data') && response['data'] is List) {
            print('WorkoutService: Found data array in response');

            final allExercises = _convertToMapList(response['data'] as List);

            if (allExercises.isNotEmpty) {
              Map<String, dynamic> muscleGroupWorkout = {
                'id': 0, // Synthetic ID
                'name':
                    '${muscleGroup.substring(0, 1).toUpperCase()}${muscleGroup.substring(1)} Exercises',
                'description': 'All $muscleGroup exercises',
                'exercises': allExercises,
                'duration': allExercises.length *
                    2, // Estimate duration based on exercise count
              };

              _workoutsByMuscleGroup = [muscleGroupWorkout];
              _selectedWorkout = muscleGroupWorkout;
              print(
                  'WorkoutService: Created synthetic workout with ${allExercises.length} exercises from map data');
            } else {
              _workoutsByMuscleGroup = [];
              print('WorkoutService: No exercises found in data array');
            }
          } else {
            print('WorkoutService: Unexpected response format: $response');
            _workoutsByMuscleGroup = [];
            _error = 'Failed to load exercise data from server';
          }
        } else {
          print(
              'WorkoutService: Unexpected response format: ${response.runtimeType}');
          _workoutsByMuscleGroup = [];
          _error = 'Failed to load exercise data from server';
        }
      } catch (e) {
        print('WorkoutService: API call failed: $e');
        _error = 'Failed to fetch exercise data: ${e.toString()}';
        rethrow;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('WorkoutService: CRITICAL ERROR: $e');
      _error = 'Failed to load workouts: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear muscle group data
  void clearMuscleGroupData() {
    _workoutsByMuscleGroup = [];
    notifyListeners();
  }

  // Set selected workout
  void setSelectedWorkout(Map<String, dynamic> workout) {
    _selectedWorkout = workout;
    notifyListeners();
  }
}
