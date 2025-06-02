import '../models/class_model.dart';
import 'api_service.dart';
import 'auth_service.dart';

class ClassService {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  // Map from frontend display names to backend values
  final Map<String, String> _classTypeMap = {
    'All Classes': 'All Classes',
    'Cardio': 'Cardio',
    'Strength': 'Strength',
    'Yoga': 'Yoga',
    'CARDIO': 'Cardio',
    'STRENGTH': 'Strength',
    'YOGA': 'Yoga',
  };

  // Ensure the class type is in the format expected by the backend
  String _normalizeClassType(String classType) {
    return _classTypeMap[classType] ?? classType;
  }

  // Get all classes
  Future<List<GymClass>> getAllClasses() async {
    try {
      final response = await _apiService.get('/classes');

      if (response.runtimeType == List) {
        final List<dynamic> data = response;
        return data.map((json) => GymClass.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format for classes');
      }
    } catch (e) {
      // Return empty list instead of mock data
      return [];
    }
  }
  // Get classes by date and type
  Future<List<GymClass>> getClassesByDateAndType(
      DateTime date, String classType) async {
    try {
      final String formattedDate = date.toIso8601String().split('T')[0];
      final String normalizedClassType = _normalizeClassType(classType);
      final String endpoint =
          '/classes?date=$formattedDate${normalizedClassType != 'All Classes' ? '&type=$normalizedClassType' : ''}';

      print('Making GET request to: $endpoint');
      final response = await _apiService.get(endpoint);

      if (response.runtimeType == List) {
        final List<dynamic> data = response;
        
        // Get current user ID for checking booked status
        final userData = await _authService.getUserDetails();
        final currentUserId = userData?['id']?.toString();
        
        return data.map((json) {
          // Create GymClass from JSON
          final gymClass = GymClass.fromJson(json);
          
          // Check if current user has booked this class
          if (currentUserId != null && json['bookedUsers'] != null) {
            final List<dynamic> bookedUsers = json['bookedUsers'];
            gymClass.isUserBooked = bookedUsers.any((user) => 
              user['id'].toString() == currentUserId
            );
          }
          
          return gymClass;
        }).toList();
      } else {
        throw Exception('Invalid response format for classes');
      }
    } catch (e) {
      print('Error loading classes: $e');
      // Return empty list instead of filtered mock data
      return [];
    }
  }

  // Create a new class
  Future<GymClass> createClass(GymClass gymClass) async {
    try {
      final token = await _authService.getToken();
      // Clone the class data and ensure classType is in the correct format
      final Map<String, dynamic> classData = gymClass.toJson();
      classData['classType'] = _normalizeClassType(classData['classType']);

      print('Making POST request to: ${_apiService.baseUrl}/classes');
      final response = await _apiService.post(
        'classes',
        classData,
        token: token,
      );

      // Check if response is a Map (JSON object)
      if (response is Map<String, dynamic>) {
        return GymClass.fromJson(response);
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('Error creating class: $e');
      throw Exception('Failed to create class: $e');
    }
  }

  // Update a class
  Future<GymClass> updateClass(GymClass gymClass) async {
    try {
      final token = await _authService.getToken();
      // Clone the class data and ensure classType is in the correct format
      final Map<String, dynamic> classData = gymClass.toJson();
      classData['classType'] = _normalizeClassType(classData['classType']);

      final response = await _apiService.patch(
        'classes/${gymClass.id}',
        classData,
        token: token,
      );

      return GymClass.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update class: $e');
    }
  }

  // Delete a class
  Future<void> deleteClass(String classId) async {
    try {
      final token = await _authService.getToken();
      await _apiService.delete('classes/$classId', token: token);
    } catch (e) {
      throw Exception('Failed to delete class: $e');
    }
  }  // Book a class
  Future<GymClass> bookClass(String classId, String userId) async {
    try {
      final token = await _authService.getToken();
      // Explicitly include the userId in the request body
      final response = await _apiService.post(
        'classes/$classId/book',
        {'userId': userId},
        token: token,
      );
      
      // Return the updated class with isUserBooked set to true
      final updatedClass = GymClass.fromJson(response);
      updatedClass.isUserBooked = true;
      return updatedClass;
    } catch (e) {
      throw Exception('Failed to book class: $e');
    }
  }  // Cancel booking
  Future<void> cancelBooking(String classId, String userId) async {
    try {
      final token = await _authService.getToken();
      // Explicitly include the userId in the request body (fixes backend error)
      await _apiService.post(
        'classes/$classId/cancel',
        {'userId': userId}, // Send userId in body
        token: token,
      );
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }  // Get user bookings
  Future<List<GymClass>> getUserBookings(String userId) async {
    try {
      print('Fetching bookings for user ID: $userId');
      final token = await _authService.getToken();
      
      if (token == null) {
        print('Authentication token is null!');
      }
      
      // Create a custom endpoint that includes userId in the path
      final response = await _apiService.get(
        'classes/user/$userId/bookings',
        token: token,
      );

      print('Got response type: ${response.runtimeType}');
      
      if (response is List) {
        final List<dynamic> data = response;
        print('Received ${data.length} bookings from server');
        
        final classes = data.map((json) {
          final gymClass = GymClass.fromJson(json);
          gymClass.isUserBooked = true; // Set to true since these are user bookings
          return gymClass;
        }).toList();
        
        print('Processed ${classes.length} bookings successfully');
        return classes;
      } else {
        print('Unexpected response format: $response');
        throw Exception('Invalid response format for user bookings');
      }
    } catch (e) {
      print('Error loading user bookings: $e');
      // Return empty list
      return [];
    }
  }
}
