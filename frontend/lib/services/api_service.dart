// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class ApiService {
  final String baseUrl = AppConfig.apiUrl;

  Future<dynamic> post(String endpoint, Map<String, dynamic> data, {String? token}) async {
    try {
      // Print the full URL for debugging
      final url = '$baseUrl/$endpoint';
      print('Making POST request to: $url');
      
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(data),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Handle successful responses
      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          return json.decode(response.body);
        } catch (e) {
          // Handle empty responses
          if (response.body.isEmpty) {
            return {'message': 'Operation successful'};
          }
          // Handle non-JSON responses
          throw ApiException(
            statusCode: response.statusCode,
            message: 'Invalid response format: ${e.toString()}',
          );
        }
      } else {
        // Handle error responses
        try {
          final errorBody = json.decode(response.body);
          throw ApiException(
            statusCode: response.statusCode,
            message: errorBody['message'] ?? 'Server error occurred',
          );
        } catch (e) {
          // Handle non-JSON error responses
          throw ApiException(
            statusCode: response.statusCode,
            message: 'Server error: ${response.body}',
          );
        }
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      // Handle network errors
      throw ApiException(statusCode: 0, message: 'Network error: ${e.toString()}');
    }
  }

  Future<dynamic> get(String endpoint, {String? token}) async {
    try {
      // Print the full URL for debugging
      final url = '$baseUrl/$endpoint';
      print('Making GET request to: $url');
      
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Handle successful responses
      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          return json.decode(response.body);
        } catch (e) {
          // Handle empty responses
          if (response.body.isEmpty) {
            return {'message': 'Operation successful'};
          }
          // Handle non-JSON responses
          throw ApiException(
            statusCode: response.statusCode,
            message: 'Invalid response format: ${e.toString()}',
          );
        }
      } else {
        // Handle error responses
        try {
          final errorBody = json.decode(response.body);
          throw ApiException(
            statusCode: response.statusCode,
            message: errorBody['message'] ?? 'Server error occurred',
          );
        } catch (e) {
          // Handle non-JSON error responses
          throw ApiException(
            statusCode: response.statusCode,
            message: 'Server error: ${response.body}',
          );
        }
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      // Handle network errors
      throw ApiException(statusCode: 0, message: 'Network error: ${e.toString()}');
    }
  }
  
  // Add patch method
  Future<dynamic> patch(String endpoint, Map<String, dynamic> data, {String? token}) async {
    try {
      final url = '$baseUrl/$endpoint';
      print('Making PATCH request to: $url');
      
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: json.encode(data),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          return json.decode(response.body);
        } catch (e) {
          if (response.body.isEmpty) {
            return {'message': 'Operation successful'};
          }
          throw ApiException(
            statusCode: response.statusCode,
            message: 'Invalid response format: ${e.toString()}',
          );
        }
      } else {
        try {
          final errorBody = json.decode(response.body);
          throw ApiException(
            statusCode: response.statusCode,
            message: errorBody['message'] ?? 'Server error occurred',
          );
        } catch (e) {
          throw ApiException(
            statusCode: response.statusCode,
            message: 'Server error: ${response.body}',
          );
        }
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(statusCode: 0, message: 'Network error: ${e.toString()}');
    }
  }
  
  // Add delete method
  Future<dynamic> delete(String endpoint, {String? token}) async {
    try {
      final url = '$baseUrl/$endpoint';
      print('Making DELETE request to: $url');
      
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          return response.body.isNotEmpty ? json.decode(response.body) : {'message': 'Operation successful'};
        } catch (e) {
          if (response.body.isEmpty) {
            return {'message': 'Operation successful'};
          }
          throw ApiException(
            statusCode: response.statusCode,
            message: 'Invalid response format: ${e.toString()}',
          );
        }
      } else {
        try {
          final errorBody = json.decode(response.body);
          throw ApiException(
            statusCode: response.statusCode,
            message: errorBody['message'] ?? 'Server error occurred',
          );
        } catch (e) {
          throw ApiException(
            statusCode: response.statusCode,
            message: 'Server error: ${response.body}',
          );
        }
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(statusCode: 0, message: 'Network error: ${e.toString()}');
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException: $statusCode - $message';
}