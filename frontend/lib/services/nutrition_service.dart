import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/nutrition.dart';

class NutritionService {
  static const String _tokenKey = 'auth_token';
  List<Nutrition> _nutritionItems = [];
  bool _isLoading = false;
  String? _error;

  List<Nutrition> get nutritionItems => _nutritionItems;
  bool get isLoading => _isLoading;
  String? get error => _error;  // Get headers with token from SharedPreferences
  Future<Map<String, String>> get _getHeaders async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      print('NutritionService: Token retrieved: ${token != null ? 'Yes' : 'No'}');
      
      if (token == null) {
        print('NutritionService: Authentication token not found in SharedPreferences');
        throw Exception('No authentication token available. You might need to log in again.');
      }
      
      if (token.isEmpty) {
        print('NutritionService: Authentication token is empty');
        throw Exception('Authentication token is empty');
      }

      print('NutritionService: Using token for request: ${token.substring(0, 10)}...');
      
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    } catch (e) {
      print('NutritionService: Error retrieving authentication token: $e');
      rethrow;
    }
  }

  // Added getAllNutrition method
  Future<List<Nutrition>> getAllNutrition() async {
    return fetchNutrition();
  }
  // Added getAllCategories method
  Future<List<String>> getAllCategories() async {
    try {
      _isLoading = true;
      print('NutritionService: Fetching all categories');

      final headers = await _getHeaders;
      final url = Uri.parse('${AppConfig.apiUrl}/nutrition/categories');
      print('NutritionService: Request URL: $url');
      
      final response = await http.get(
        url,
        headers: headers,
      );

      print('NutritionService: Categories response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print('NutritionService: Response body is empty for categories');
          return [];
        }
        
        try {
          final List<dynamic> categoriesJson = jsonDecode(response.body);
          final categories = categoriesJson.map((category) => category.toString()).toList();
          print('NutritionService: Found ${categories.length} categories: $categories');
          return categories;
        } catch (parseError) {
          print('NutritionService: Error parsing categories response: $parseError');
          print('NutritionService: Response body: ${response.body}');
          throw Exception('Failed to parse categories data: $parseError');
        }
      } else {
        print('NutritionService: Error response for categories: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to fetch categories: ${response.body}');
      }
    } catch (e) {
      _error = e.toString();
      print('NutritionService: Exception in getAllCategories: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }
  // Added getNutritionByCategory method
  Future<List<Nutrition>> getNutritionByCategory(String category) async {
    try {
      _isLoading = true;
      print('NutritionService: Fetching nutrition items for category: $category');

      final headers = await _getHeaders;
      final url = Uri.parse('${AppConfig.apiUrl}/nutrition/category/$category');
      print('NutritionService: Request URL: $url');
      
      final response = await http.get(
        url,
        headers: headers,
      );

      print('NutritionService: Category response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print('NutritionService: Response body is empty for category: $category');
          return [];
        }
        
        try {
          final List<dynamic> nutritionJson = jsonDecode(response.body);
          print('NutritionService: Found ${nutritionJson.length} items for category: $category');
          return nutritionJson.map((json) => Nutrition.fromJson(json)).toList();
        } catch (parseError) {
          print('NutritionService: Error parsing response: $parseError');
          print('NutritionService: Response body: ${response.body}');
          throw Exception('Failed to parse nutrition data: $parseError');
        }
      } else {
        print('NutritionService: Error response for category $category: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Failed to fetch nutrition by category: ${response.body}');
      }
    } catch (e) {
      _error = e.toString();
      print('NutritionService: Exception in getNutritionByCategory: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }  Future<List<Nutrition>> fetchNutrition() async {
    try {
      _isLoading = true;
      print('NutritionService: Fetching all nutrition items');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(_tokenKey);
      print('NutritionService: Token available: ${token != null && token.isNotEmpty ? 'Yes' : 'No'}');

      // Always try public endpoint first for reliability
      try {
        final url = Uri.parse('${AppConfig.apiUrl}/nutrition/public');
        print('NutritionService: Request URL: $url (public)');
        
        final response = await http.get(
          url,
          headers: {'Content-Type': 'application/json'},
        );

        print('NutritionService: Public nutrition response status: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          if (response.body.isEmpty) {
            print('NutritionService: Response body is empty for public nutrition');
            _nutritionItems = [];
            return _nutritionItems;
          }
          
          try {
            final List<dynamic> nutritionJson = jsonDecode(response.body);
            print('NutritionService: Found ${nutritionJson.length} public nutrition items');
            _nutritionItems = nutritionJson.map((json) => Nutrition.fromJson(json)).toList();
            
            if (_nutritionItems.isNotEmpty) {
              print('NutritionService: Successfully loaded ${_nutritionItems.length} nutrition items');
              return _nutritionItems;
            } else {
              print('NutritionService: No nutrition items found in public endpoint, will try authenticated endpoint');
            }
          } catch (parseError) {
            print('NutritionService: Error parsing response: $parseError');
            print('NutritionService: Response body: ${response.body}');
            // Continue to try authenticated endpoint instead of throwing
          }
        } else {
          print('NutritionService: Public endpoint failed: ${response.statusCode}, trying authenticated endpoint');
        }
      } catch (publicError) {
        print('NutritionService: Error accessing public endpoint: $publicError');
        // Continue to try authenticated endpoint
      }
      
      // Try authenticated endpoint if public failed or returned empty
      if (token != null && token.isNotEmpty) {
        try {
          final headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          };
          final url = Uri.parse('${AppConfig.apiUrl}/nutrition/all');
          print('NutritionService: Request URL: $url (authenticated)');
          
          final response = await http.get(
            url,
            headers: headers,
          );

          print('NutritionService: Authenticated nutrition response status: ${response.statusCode}');
          
          if (response.statusCode == 200) {
            if (response.body.isEmpty) {
              print('NutritionService: Response body is empty for authenticated nutrition');
              _nutritionItems = [];
              return _nutritionItems;
            }
            
            try {
              final List<dynamic> nutritionJson = jsonDecode(response.body);
              print('NutritionService: Found ${nutritionJson.length} authenticated nutrition items');
              _nutritionItems = nutritionJson.map((json) => Nutrition.fromJson(json)).toList();
              return _nutritionItems;
            } catch (parseError) {
              print('NutritionService: Error parsing authenticated response: $parseError');
              throw Exception('Failed to parse nutrition data: $parseError');
            }
          } else {
            print('NutritionService: Authenticated endpoint failed: ${response.statusCode} - ${response.body}');
            throw Exception('Failed to fetch nutrition data: ${response.statusCode}');
          }
        } catch (authError) {
          print('NutritionService: Error with authenticated request: $authError');
          throw authError;
        }
      } else {
        // If we've reached here and nutritionItems is still empty, throw an error
        if (_nutritionItems.isEmpty) {
          throw Exception('Could not fetch nutrition data from either endpoint');
        }
      }
      
      return _nutritionItems;
    } catch (e) {
      _error = e.toString();
      print('NutritionService: Exception in fetchNutrition: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  Future<List<Nutrition>> searchNutrition(String query) async {
    try {
      _isLoading = true;

      final headers = await _getHeaders;
      final response = await http.get(
        Uri.parse('${AppConfig.apiUrl}/nutrition/search?query=$query'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return [];
        }
        final List<dynamic> nutritionJson = jsonDecode(response.body);
        return nutritionJson.map((json) => Nutrition.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search nutrition items: ${response.body}');
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  Future<Nutrition> getNutritionById(int id) async {
    final uri = Uri.parse('${AppConfig.apiUrl}/nutrition/$id');

    final headers = await _getHeaders;
    final response = await http.get(
      uri,
      headers: headers,
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        throw Exception('Nutrition item not found');
      }
      return Nutrition.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load nutrition item: ${response.body}');
    }
  }

  // Added getMealTemplates method
  Future<Map<String, List<Nutrition>>> getMealTemplates() async {
    try {
      _isLoading = true;

      final headers = await _getHeaders;
      final response = await http.get(
        Uri.parse('${AppConfig.apiUrl}/nutrition/meal-templates'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return {};
        }
        final Map<String, dynamic> templatesJson = jsonDecode(response.body);
        Map<String, List<Nutrition>> templates = {};

        templatesJson.forEach((key, value) {
          if (value is List) {
            templates[key] =
                (value).map((item) => Nutrition.fromJson(item)).toList();
          }
        });

        return templates;
      } else {
        throw Exception('Failed to fetch meal templates: ${response.body}');
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Added getAllMeals method
  Future<List<dynamic>> getAllMeals({int? userId}) async {
    try {
      _isLoading = true;

      final headers = await _getHeaders;
      String url = '${AppConfig.apiUrl}/nutrition/meals';
      if (userId != null) {
        url += '?userId=$userId';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return [];
        }
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load meals: ${response.body}');
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Added getMealById method
  Future<dynamic> getMealById(int mealId) async {
    try {
      _isLoading = true;

      final headers = await _getHeaders;
      final response = await http.get(
        Uri.parse('${AppConfig.apiUrl}/nutrition/meals/$mealId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return {};
        }
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load meal: ${response.body}');
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Added createMeal method
  Future<dynamic> createMeal(Map<String, dynamic> mealData) async {
    try {
      _isLoading = true;

      final headers = await _getHeaders;
      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}/nutrition/meals'),
        headers: headers,
        body: jsonEncode(mealData),
      );

      if (response.statusCode == 201) {
        if (response.body.isEmpty) {
          return {};
        }
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create meal: ${response.body}');
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Added updateMeal method
  Future<dynamic> updateMeal(int mealId, Map<String, dynamic> mealData) async {
    try {
      _isLoading = true;

      final headers = await _getHeaders;
      final response = await http.patch(
        Uri.parse('${AppConfig.apiUrl}/nutrition/meals/$mealId'),
        headers: headers,
        body: jsonEncode(mealData),
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return {};
        }
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update meal: ${response.body}');
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Added deleteMeal method
  Future<void> deleteMeal(int mealId) async {
    try {
      _isLoading = true;

      final headers = await _getHeaders;
      final response = await http.delete(
        Uri.parse('${AppConfig.apiUrl}/nutrition/meals/$mealId'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete meal: ${response.body}');
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  Future<Nutrition> createNutrition(Map<String, dynamic> nutritionData) async {
    try {
      _isLoading = true;

      final headers = await _getHeaders;
      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}/nutrition'),
        headers: headers,
        body: jsonEncode(nutritionData),
      );

      if (response.statusCode == 201) {
        if (response.body.isEmpty) {
          throw Exception('No nutrition data returned');
        }
        final newNutrition = Nutrition.fromJson(jsonDecode(response.body));
        _nutritionItems.add(newNutrition);
        return newNutrition;
      } else {
        throw Exception('Failed to create nutrition item: ${response.body}');
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  Future<Nutrition> updateNutrition(
      int id, Map<String, dynamic> nutritionData) async {
    try {
      _isLoading = true;

      final headers = await _getHeaders;
      final response = await http.put(
        Uri.parse('${AppConfig.apiUrl}/nutrition/$id'),
        headers: headers,
        body: jsonEncode(nutritionData),
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('No nutrition data returned');
        }
        final updatedNutrition = Nutrition.fromJson(jsonDecode(response.body));
        final index = _nutritionItems.indexWhere((item) => item.id == id);
        if (index != -1) {
          _nutritionItems[index] = updatedNutrition;
        }
        return updatedNutrition;
      } else {
        throw Exception('Failed to update nutrition item: ${response.body}');
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  Future<void> deleteNutrition(int id) async {
    try {
      _isLoading = true;

      final headers = await _getHeaders;
      final response = await http.delete(
        Uri.parse('${AppConfig.apiUrl}/nutrition/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        _nutritionItems.removeWhere((item) => item.id == id);
      } else {
        throw Exception('Failed to delete nutrition item: ${response.body}');
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  Future<Map<String, dynamic>> calculateNutrition(
      Map<String, dynamic> data) async {
    final uri = Uri.parse('${AppConfig.apiUrl}/nutrition/calculate');

    final headers = await _getHeaders;
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return {};
      }
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to calculate nutrition: ${response.body}');
    }
  }

  Future<List<Nutrition>> getRecommendedNutrition({
    double? targetProtein,
    double? targetCalories,
  }) async {
    String queryParams = '';

    if (targetProtein != null) {
      queryParams += 'targetProtein=$targetProtein';
    }

    if (targetCalories != null) {
      if (queryParams.isNotEmpty) queryParams += '&';
      queryParams += 'targetCalories=$targetCalories';
    }

    final uri = Uri.parse(
        '${AppConfig.apiUrl}/nutrition/recommend${queryParams.isNotEmpty ? "?$queryParams" : ""}');

    final headers = await _getHeaders;
    final response = await http.get(
      uri,
      headers: headers,
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return [];
      }
      final List<dynamic> nutritionJson = jsonDecode(response.body);
      return nutritionJson.map((json) => Nutrition.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get recommendations: ${response.body}');
    }
  }
}
