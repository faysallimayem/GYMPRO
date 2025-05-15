import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/user_model.dart';

class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginatedResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    List<T> items =
        (json['items'] as List).map((item) => fromJsonT(item)).toList();

    return PaginatedResponse(
      items: items,
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? items.length,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

class UserService {
  static const String _tokenKey = 'auth_token';

  // Get auth headers with token
  Future<Map<String, String>> get _getHeaders async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null) {
      throw Exception('No authentication token available');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Get all users - Admin only (without pagination)
  // This method is maintained for backward compatibility while transitioning to the paginated API
  Future<List<User>> getAllUsers() async {
    try {
      // Call the paginated method and just return the items
      final paginatedResponse =
          await getPaginatedUsers(limit: 1000); // Large limit to get all users
      return paginatedResponse.items;
    } catch (e) {
      throw Exception('Error getting users: ${e.toString()}');
    }
  }

  // Get paginated users - Admin only
  Future<PaginatedResponse<User>> getPaginatedUsers({
    int page = 1,
    int limit = 10,
    String? searchQuery,
  }) async {
    try {
      final headers = await _getHeaders;

      // Build the query parameters
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      // Add search query if provided
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }

      final uri = Uri.parse('${AppConfig.apiUrl}/user').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(
        uri,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // If the backend returns a paginated response
        if (data is Map && data.containsKey('items')) {
          return PaginatedResponse.fromJson(
              data as Map<String, dynamic>, User.fromJson);
        }

        // If the backend returns just an array without pagination metadata
        final List<dynamic> items = data is List ? data : [data];
        return PaginatedResponse(
          items: items.map((json) => User.fromJson(json)).toList(),
          total: items.length,
          page: 1,
          limit: items.length,
          totalPages: 1,
        );
      } else {
        throw Exception('Failed to load users: ${_getErrorMessage(response)}');
      }
    } catch (e) {
      throw Exception('Error getting users: ${e.toString()}');
    }
  }

  // Get user by ID - Admin only
  Future<User> getUserById(int userId) async {
    try {
      final headers = await _getHeaders;
      final response = await http.get(
        Uri.parse('${AppConfig.apiUrl}/user/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Failed to load user: ${_getErrorMessage(response)}');
      }
    } catch (e) {
      throw Exception('Error getting user: ${e.toString()}');
    }
  }

  // Create a new user - Admin only
  Future<User> createUser(Map<String, dynamic> userData) async {
    try {
      final headers = await _getHeaders;
      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}/user'),
        headers: headers,
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Failed to create user: ${_getErrorMessage(response)}');
      }
    } catch (e) {
      throw Exception('Error creating user: ${e.toString()}');
    }
  }

  // Update user role - Admin only
  Future<User> updateUserRole(int userId, String role) async {
    try {
      final headers = await _getHeaders;
      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}/user/$userId/role'),
        headers: headers,
        body: jsonEncode({'role': role}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception(
            'Failed to update user role: ${_getErrorMessage(response)}');
      }
    } catch (e) {
      throw Exception('Error updating user role: ${e.toString()}');
    }
  }

  // Update user details - Admin only
  Future<User> updateUserDetails(
      int userId, Map<String, dynamic> userData) async {
    try {
      final headers = await _getHeaders;
      final response = await http.patch(
        Uri.parse('${AppConfig.apiUrl}/user/$userId'),
        headers: headers,
        body: jsonEncode(userData),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception(
            'Failed to update user details: ${_getErrorMessage(response)}');
      }
    } catch (e) {
      throw Exception('Error updating user details: ${e.toString()}');
    }
  }

  // Delete user - Admin only
  Future<Map<String, dynamic>> deleteUser(int userId) async {
    try {
      final headers = await _getHeaders;
      final response = await http.delete(
        Uri.parse('${AppConfig.apiUrl}/user/$userId'),
        headers: headers,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Handle all success status codes (200-299)
        return response.body.isNotEmpty
            ? jsonDecode(response.body)
            : {'success': true};
      } else {
        throw Exception('Failed to delete user: ${_getErrorMessage(response)}');
      }
    } catch (e) {
      throw Exception('Error deleting user: ${e.toString()}');
    }
  }

  // Helper method to extract error message from API response
  String _getErrorMessage(http.Response response) {
    try {
      final responseBody = jsonDecode(response.body);
      if (responseBody['message'] != null) {
        return responseBody['message'];
      } else if (responseBody['error'] != null) {
        return responseBody['error'];
      }
      return 'Status code: ${response.statusCode}';
    } catch (_) {
      return 'Status code: ${response.statusCode}';
    }
  }
}
