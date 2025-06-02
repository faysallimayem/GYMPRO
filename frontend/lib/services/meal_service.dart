import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/meal.dart';

class MealService {
  static const String _tokenKey =
      'auth_token'; // Use the same token key as other services
  // Get headers with token from SharedPreferences
  Future<Map<String, String>> get _getHeaders async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    print('MealService: Getting auth token: ${token != null ? 'Token available' : 'Token is NULL'}');

    if (token == null) {
      throw Exception('No authentication token available');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }  Future<List<Meal>> getAllMeals({int? userId, bool retryWithDelay = true}) async {
    // IMPORTANT: The backend may need a direct path instead of a query parameter
    // Try both approaches - first with the query parameter, then with direct paths
    try {
      var uri = Uri.parse(
          '${AppConfig.apiUrl}/nutrition/meals${userId != null ? "?userId=$userId" : ""}');

      print('getAllMeals called with userId: $userId, URI: $uri');
      final headers = await _getHeaders;
      var response = await http.get(uri, headers: headers);
      
      print('getAllMeals: Response status: ${response.statusCode}, body length: ${response.body.length}');
      
      if (response.statusCode == 200 && response.body.isNotEmpty && response.body != '[]') {
        try {
          final dynamic decoded = jsonDecode(response.body);
          print('getAllMeals: Successfully decoded JSON response');
          
          // Handle list response
          if (decoded is List) {
            print('getAllMeals: Found ${decoded.length} meals in list');
            return decoded.map<Meal>((json) => Meal.fromJson(json as Map<String, dynamic>)).toList();
          }
          
          // Handle object with meals inside
          if (decoded is Map<String, dynamic>) {
            // Try various possible response formats
            if (decoded.containsKey('meals') && decoded['meals'] is List) {
              final List<dynamic> meals = decoded['meals'] as List<dynamic>;
              print('getAllMeals: Found ${meals.length} meals in "meals" property');
              return meals.map<Meal>((json) => Meal.fromJson(json as Map<String, dynamic>)).toList();
            }
            
            if (decoded.containsKey('data') && decoded['data'] is List) {
              final List<dynamic> meals = decoded['data'] as List<dynamic>;
              print('getAllMeals: Found ${meals.length} meals in "data" property');
              return meals.map<Meal>((json) => Meal.fromJson(json as Map<String, dynamic>)).toList();
            }
            
            // Single meal object
            if (decoded.containsKey('id')) {
              print('getAllMeals: Found a single meal object');
              return [Meal.fromJson(decoded)];
            }
          }
          
          print('getAllMeals: Unexpected response format, trying alternative endpoints');
        } catch (e) {
          print('getAllMeals: Error parsing first response: $e');
        }
      }
      
      // Second attempt - try direct user meals path
      if (userId != null) {
        uri = Uri.parse('${AppConfig.apiUrl}/nutrition/users/$userId/meals');
        print('getAllMeals: Second attempt with userId in path: $uri');
        response = await http.get(uri, headers: headers);
        
        print('getAllMeals: Second attempt response status: ${response.statusCode}, body length: ${response.body.length}');
        
        if (response.statusCode == 200 && response.body.isNotEmpty && response.body != '[]') {
          try {
            final dynamic decoded = jsonDecode(response.body);
            
            if (decoded is List) {
              print('getAllMeals: Second attempt found ${decoded.length} meals');
              return decoded.map<Meal>((json) => Meal.fromJson(json as Map<String, dynamic>)).toList();
            }
            
            if (decoded is Map<String, dynamic> && decoded.containsKey('meals') && decoded['meals'] is List) {
              final List<dynamic> meals = decoded['meals'] as List<dynamic>;
              print('getAllMeals: Second attempt found ${meals.length} meals in "meals" property');
              return meals.map<Meal>((json) => Meal.fromJson(json as Map<String, dynamic>)).toList();
            }
          } catch (e) {
            print('getAllMeals: Error parsing second response: $e');
          }
        }
      }
      
      // Third attempt - try fetching all meals and filtering client-side 
      uri = Uri.parse('${AppConfig.apiUrl}/nutrition/meals/all');
      print('getAllMeals: Third attempt fetching all meals: $uri');
      response = await http.get(uri, headers: headers);
      
      if (response.statusCode == 200 && response.body.isNotEmpty && response.body != '[]') {
        try {
          final dynamic decoded = jsonDecode(response.body);
          
          if (decoded is List) {
            print('getAllMeals: Third attempt found ${decoded.length} meals');
            final allMeals = decoded.map<Meal>((json) => Meal.fromJson(json as Map<String, dynamic>)).toList();
            
            // Filter by userId if specified
            if (userId != null) {
              final userMeals = allMeals.where((meal) => meal.userId == userId).toList();
              print('getAllMeals: Filtered to ${userMeals.length} meals for user $userId');
              return userMeals;
            }
            return allMeals;
          }
        } catch (e) {
          print('getAllMeals: Error parsing third response: $e');
        }
      }
        // If we've recently created a meal but can't fetch it through normal endpoints,
      // Try to fetch the specific meal by ID directly as a last resort
      try {
        // Check if we can access the most recently created meal ID
        final prefs = await SharedPreferences.getInstance();
        final lastCreatedMealId = prefs.getInt('last_created_meal_id');
        
        if (lastCreatedMealId != null) {
          print('getAllMeals: Attempting to fetch last created meal with ID: $lastCreatedMealId');
          final meal = await getMealById(lastCreatedMealId);
          if (meal.userId == userId) {
            print('getAllMeals: Successfully retrieved last created meal');
            return [meal];
          }
        }
      } catch (e) {
        print('getAllMeals: Error fetching last created meal: $e');
      }
        // If we still haven't found any meals and this is the first retry, 
      // wait a bit and try again (eventual consistency mitigation)
      if (retryWithDelay) {
        print('getAllMeals: Trying one last time with delay for eventual consistency');
        // Wait 1.5 seconds before retrying
        await Future.delayed(Duration(milliseconds: 1500));
        return getAllMeals(userId: userId, retryWithDelay: false);
      }
      
      print('getAllMeals: No meals found after multiple attempts');
      return [];
    } catch (e) {
      print('getAllMeals: Exception during meal retrieval: $e');
      return [];
    }
  }
  Future<Meal> getMealById(int id) async {
    final uri = Uri.parse('${AppConfig.apiUrl}/nutrition/meals/$id');

    final headers = await _getHeaders;
    final response = await http.get(
      uri,
      headers: headers,
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        throw Exception('Meal data is empty');
      }
      return Meal.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load meal: ${response.body}');
    }
  }  Future<Meal> createMeal(Map<String, dynamic> mealData) async {
    final uri = Uri.parse('${AppConfig.apiUrl}/nutrition/meals');

    try {
      print('createMeal called with data: ${jsonEncode(mealData)}');
      final headers = await _getHeaders;
      print('Headers: $headers');
      
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(mealData),
      );

      print('createMeal response status: ${response.statusCode}');
      print('createMeal response body: ${response.body}');

      if (response.statusCode == 201) {
        if (response.body.isEmpty) {
          print('createMeal: Response body is empty');
          throw Exception('Created meal response is empty');
        }
        
        // Parse the response and create the meal object
        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          print('createMeal: Successfully parsed response data');
          
          // Validate the required fields are present
          if (responseData['id'] == null) {
            print('createMeal: Warning - Response is missing ID field');
          }
            final Meal createdMeal = Meal.fromJson(responseData);
          print('createMeal: Successfully created meal with ID: ${createdMeal.id}');
          
          // Check if the meal has the expected fields
          print('createMeal: Created meal name: ${createdMeal.name}');
          print('createMeal: Created meal has ${createdMeal.items.length} items');
          
          // Store the last created meal ID for fallback retrieval
          if (createdMeal.id != null) {
            try {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setInt('last_created_meal_id', createdMeal.id!);
              print('createMeal: Stored meal ID ${createdMeal.id} in SharedPreferences');
            } catch (e) {
              print('createMeal: Error storing meal ID in SharedPreferences: $e');
            }
          }
          
          return createdMeal;
        } catch (e) {
          print('createMeal: Error parsing response: $e');
          rethrow;
        }
      } else {
        print('Failed to create meal: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to create meal: ${response.body}');
      }
    } catch (e) {
      print('Exception creating meal: $e');
      rethrow;
    }
  }
  Future<Meal> updateMeal(int id, Map<String, dynamic> mealData) async {
    final uri = Uri.parse('${AppConfig.apiUrl}/nutrition/meals/$id');

    final headers = await _getHeaders;
    final response = await http.patch(
      uri,
      headers: headers,
      body: jsonEncode(mealData),
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        throw Exception('Updated meal response is empty');
      }
      return Meal.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update meal: ${response.body}');
    }
  }

  Future<void> deleteMeal(int id) async {
    final uri = Uri.parse('${AppConfig.apiUrl}/nutrition/meals/$id');

    final headers = await _getHeaders;
    final response = await http.delete(
      uri,
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete meal: ${response.body}');
    }
  }
  Future<Map<String, List<dynamic>>> getMealTemplates() async {
    final uri = Uri.parse('${AppConfig.apiUrl}/nutrition/meal-templates');

    print('getMealTemplates called, URI: $uri');
    final headers = await _getHeaders;
    final response = await http.get(
      uri,
      headers: headers,
    );

    print('getMealTemplates response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        print('getMealTemplates: Response body is empty');
        return {};
      }
      
      print('getMealTemplates response body length: ${response.body.length}');
      final Map<String, dynamic> templates = jsonDecode(response.body);
      print('getMealTemplates: Retrieved templates for ${templates.keys.length} categories');

      // Convert the nested JSON to the expected format
      final Map<String, List<dynamic>> result = {};
      templates.forEach((key, value) {
        if (value is List) {
          print('getMealTemplates: Category $key has ${value.length} items');
          result[key] = value;
        } else {
          print('getMealTemplates: Category $key has invalid format: $value');
        }
      });

      return result;
    } else {
      print('getMealTemplates failed with status: ${response.statusCode}, body: ${response.body}');
      throw Exception('Failed to load meal templates: ${response.body}');
    }
  }
}
