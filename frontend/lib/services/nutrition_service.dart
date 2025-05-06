import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/nutrition.dart';
import '../models/meal.dart';

class NutritionService {
  static const String _tokenKey = 'auth_token';
  List<Nutrition> _nutritionItems = [];
  bool _isLoading = false;
  String? _error;

  List<Nutrition> get nutritionItems => _nutritionItems;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Get headers with token from SharedPreferences
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

  // Added getAllNutrition method
  Future<List<Nutrition>> getAllNutrition() async {
    return fetchNutrition();
  }

  // Added getAllCategories method
  Future<List<String>> getAllCategories() async {
    try {
      _isLoading = true;
      
      final headers = await _getHeaders;
      final response = await http.get(
        Uri.parse('${AppConfig.apiUrl}/nutrition/categories'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> categoriesJson = jsonDecode(response.body);
        return categoriesJson.map((category) => category.toString()).toList();
      } else {
        throw Exception('Failed to fetch categories: ${response.body}');
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Added getNutritionByCategory method
  Future<List<Nutrition>> getNutritionByCategory(String category) async {
    try {
      _isLoading = true;
      
      final headers = await _getHeaders;
      final response = await http.get(
        Uri.parse('${AppConfig.apiUrl}/nutrition/category/$category'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> nutritionJson = jsonDecode(response.body);
        return nutritionJson.map((json) => Nutrition.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch nutrition by category: ${response.body}');
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
    }
  }
  
  Future<List<Nutrition>> fetchNutrition() async {
    try {
      _isLoading = true;
      
      final headers = await _getHeaders;
      final response = await http.get(
        Uri.parse('${AppConfig.apiUrl}/nutrition/all'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> nutritionJson = jsonDecode(response.body);
        _nutritionItems = nutritionJson.map((json) => Nutrition.fromJson(json)).toList();
        return _nutritionItems;
      } else {
        throw Exception('Failed to fetch nutrition items: ${response.body}');
      }
    } catch (e) {
      _error = e.toString();
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
        final Map<String, dynamic> templatesJson = jsonDecode(response.body);
        Map<String, List<Nutrition>> templates = {};
        
        templatesJson.forEach((key, value) {
          if (value is List) {
            templates[key] = (value).map((item) => Nutrition.fromJson(item)).toList();
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
  
  Future<Nutrition> updateNutrition(int id, Map<String, dynamic> nutritionData) async {
    try {
      _isLoading = true;
      
      final headers = await _getHeaders;
      final response = await http.put(
        Uri.parse('${AppConfig.apiUrl}/nutrition/$id'),
        headers: headers,
        body: jsonEncode(nutritionData),
      );

      if (response.statusCode == 200) {
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
  
  Future<Map<String, dynamic>> calculateNutrition(Map<String, dynamic> data) async {
    final uri = Uri.parse('${AppConfig.apiUrl}/nutrition/calculate');
    
    final headers = await _getHeaders;
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );
    
    if (response.statusCode == 200) {
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
    
    final uri = Uri.parse('${AppConfig.apiUrl}/nutrition/recommend${queryParams.isNotEmpty ? "?$queryParams" : ""}');
    
    final headers = await _getHeaders;
    final response = await http.get(
      uri,
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> nutritionJson = jsonDecode(response.body);
      return nutritionJson.map((json) => Nutrition.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get recommendations: ${response.body}');
    }
  }
}