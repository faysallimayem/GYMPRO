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

    if (token == null) {
      throw Exception('No authentication token available');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  Future<List<Meal>> getAllMeals({int? userId}) async {
    final uri = Uri.parse(
        '${AppConfig.apiUrl}/nutrition/meals${userId != null ? "?userId=$userId" : ""}');

    final headers = await _getHeaders;
    final response = await http.get(
      uri,
      headers: headers,
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return [];
      }
      final List<dynamic> mealsJson = jsonDecode(response.body);
      return mealsJson.map((json) => Meal.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load meals: ${response.body}');
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
      final headers = await _getHeaders;
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(mealData),
      );

      if (response.statusCode == 201) {
        if (response.body.isEmpty) {
          throw Exception('Created meal response is empty');
        }
        return Meal.fromJson(jsonDecode(response.body));
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

    final headers = await _getHeaders;
    final response = await http.get(
      uri,
      headers: headers,
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return {};
      }
      final Map<String, dynamic> templates = jsonDecode(response.body);

      // Convert the nested JSON to the expected format
      final Map<String, List<dynamic>> result = {};
      templates.forEach((key, value) {
        if (value is List) {
          result[key] = value;
        }
      });

      return result;
    } else {
      throw Exception('Failed to load meal templates: ${response.body}');
    }
  }
}
