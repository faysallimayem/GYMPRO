import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class AuthService extends ChangeNotifier {
  // Singleton pattern to ensure one instance throughout the app
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _roleKey = 'user_role';

  bool _isAuthenticated = false;
  Map<String, dynamic>? _userData;
  String? _userRole;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userData => _userData;
  String? get userRole => _userRole;

  bool get isAdmin => _userRole == 'admin';

  // Initialize the auth service
  Future<void> initialize() async {
    final token = await getToken();
    _isAuthenticated = token != null;

    if (_isAuthenticated) {
      _userData = await getUserDetails();
      _userRole = await getUserRole();
    }

    notifyListeners();
  }

  // Get the stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Store token
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    _isAuthenticated = true;
    notifyListeners();
  }

  // Get user role
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  // Store user role
  Future<void> setUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role);
    _userRole = role;
    notifyListeners();
  }

  // Remove token (logout)
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_roleKey);
    _isAuthenticated = false;
    _userData = null;
    _userRole = null;
    notifyListeners();
  }

  // Get stored user details
  Future<Map<String, dynamic>?> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;

    return jsonDecode(userJson);
  }

  // Store user details
  Future<void> setUserDetails(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(userData));
    _userData = userData;
    notifyListeners();
  }

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Login response: $responseData');

        // Store token and user data
        final token = responseData['access_token'] ?? responseData['token'];
        if (token != null) {
          await setToken(token);

          // Extract role from JWT token
          final roleFromToken = extractRoleFromToken(token);
          if (roleFromToken != null) {
            print('Role extracted from token: $roleFromToken');
            await setUserRole(roleFromToken.toLowerCase());
          }
        }

        // Extract user data if available in response
        final userData = responseData['user'];
        if (userData != null) {
          print('User data from login: $userData');
          await setUserDetails(userData);

          // Extract role from user data if available
          if (userData['role'] != null) {
            print('Role from user data: ${userData['role']}');
            await setUserRole(userData['role'].toString().toLowerCase());
          }
        } else {
          // If user data is not provided, fetch it from profile endpoint
          try {
            await getUserProfile();
          } catch (e) {
            print('Error fetching user profile after login: $e');
          }
        }

        print('After login - isAdmin: $isAdmin, userRole: $_userRole');
        return responseData;
      } else {
        throw Exception('Login failed: ${_getErrorMessage(response)}');
      }
    } catch (e) {
      throw Exception('Login error: ${e.toString()}');
    }
  }

  // Extract role from JWT token
  String? extractRoleFromToken(String token) {
    try {
      // JWT token has three parts separated by dots
      final parts = token.split('.');
      if (parts.length != 3) return null;

      // Decode the payload (second part)
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> decodedJson = jsonDecode(decoded);

      // Extract role from decoded payload
      final role = decodedJson['role'] as String?;
      print('Role extracted from token: $role');
      return role;
    } catch (e) {
      print('Error extracting role from token: $e');
      return null;
    }
  }

  // Register
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Registration failed: ${_getErrorMessage(response)}');
      }
    } catch (e) {
      throw Exception('Registration error: ${e.toString()}');
    }
  }

  // Request password reset
  Future<String> requestPasswordReset(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      // Always treat 200 status code as success, regardless of the message
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        try {
          responseData = jsonDecode(response.body);
          return responseData['message'] ?? 'Reset link sent! Check your email';
        } catch (e) {
          // If JSON parsing fails, return a default message
          return 'Reset link sent! Check your email';
        }
      } else {
        throw Exception('Password reset request failed');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      // Return success message even if there's an error
      // This approach prioritizes user experience over technical accuracy
      return 'If an account exists, a reset link has been sent to your email';
    }
  }

  // Reset password
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'password': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Password reset failed: ${_getErrorMessage(response)}');
      }
    } catch (e) {
      throw Exception('Password reset error: ${e.toString()}');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      final token = await getToken();

      if (token != null) {
        // Call logout endpoint if your API has one
        try {
          await http.post(
            Uri.parse('${AppConfig.apiUrl}/auth/logout'),
            headers: {
              'Authorization': 'Bearer $token',
            },
          );
        } catch (e) {
          // Even if server logout fails, we still want to clear local data
          print(
              'Server logout failed but proceeding with local logout: ${e.toString()}');
        }
      }

      // Always clear local data
      await removeToken();
    } catch (e) {
      throw Exception('Logout error: ${e.toString()}');
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final token = await getToken();

      if (token == null) {
        throw Exception('Not authenticated');
      }

      print('Fetching user profile with token: ${token.substring(0, 10)}...');
      final response = await http.get(
        Uri.parse('${AppConfig.apiUrl}/users/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Profile response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        print('Profile data received: $userData');

        // If role is present in the profile data, update it
        if (userData['role'] != null) {
          await setUserRole(userData['role'].toString().toLowerCase());
        }

        await setUserDetails(userData); // Update stored user data
        return userData;
      } else {
        print('Failed to get profile: ${response.body}');
        // Don't throw an exception for 403 errors as the role info may already be extracted from token
        if (response.statusCode == 403) {
          print('Using role from token instead of profile data');
          return {'message': 'Using role from token'};
        } else {
          throw Exception(
              'Failed to get user profile: ${_getErrorMessage(response)}');
        }
      }
    } catch (e) {
      print('Get profile error: $e');
      // Don't rethrow if we already have a role from token
      if (_userRole != null) {
        return {'message': 'Using role from token'};
      }
      throw Exception('Get profile error: ${e.toString()}');
    }
  }

  // Update user profile
  Future<Map<String, dynamic>> updateProfile(
      Map<String, dynamic> userData) async {
    try {
      final token = await getToken();

      if (token == null) {
        throw Exception('Not authenticated');
      }      // Using the correct endpoint URL
      final response = await http.patch(
        Uri.parse('${AppConfig.apiUrl}/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        final updatedData = jsonDecode(response.body);
        await setUserDetails(updatedData); // Update stored user data
        return updatedData;
      } else {
        throw Exception(
            'Failed to update profile: ${_getErrorMessage(response)}');
      }
    } catch (e) {
      throw Exception('Update profile error: ${e.toString()}');
    }
  }

  // Change password
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final token = await getToken();

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}/user/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to change password: ${_getErrorMessage(response)}');
      }
    } catch (e) {
      throw Exception('Change password error: ${e.toString()}');
    }
  }

  // Helper method to extract error message from response
  String _getErrorMessage(http.Response response) {
    try {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final message = body['message'] ?? body['error'] ?? response.body;
      return message is String ? message : jsonEncode(message);
    } catch (e) {
      return response.body;
    }
  }
  
  // Generate an admin access code
  Future<String> generateAdminAccessCode() async {
    try {
      final token = await getToken();
      
      if (token == null) {
        throw Exception('Not authenticated');
      }
      
      if (!isAdmin) {
        throw Exception('You do not have permission to generate access codes');
      }
      
      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}/auth/generate-access-code'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData['code'] ?? '';
      } else {
        throw Exception('Failed to generate access code: ${_getErrorMessage(response)}');
      }
    } catch (e) {
      throw Exception('Error generating access code: ${e.toString()}');
    }
  }
}
