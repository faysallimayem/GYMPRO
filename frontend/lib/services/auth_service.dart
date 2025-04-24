import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // User token
  String? _token;
  
  // User data
  Map<String, dynamic>? _userData;
  
  // Getters
  String? get token => _token;
  Map<String, dynamic>? get userData => _userData;
  bool get isAuthenticated => _token != null;
  
  // Initialize auth state from storage
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      _userData = json.decode(userDataString);
    }
    notifyListeners();
  }
  
  // Sign up
  Future<Map<String, dynamic>> signUp(Map<String, dynamic> userData) async {
    try {
      // Debug print to check the exact endpoint being called
      print('Calling signup endpoint: auth/signup');
      
      // Make sure to use the exact endpoint path
      final response = await _apiService.post('auth/signup', userData);
      _token = response['access_token'];
      
      // Save token to storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      
      // Fetch user profile
      await _fetchUserProfile();
      
      notifyListeners();
      return response;
    } catch (e) {
      print('Signup error: $e'); // Debug
      rethrow;
    }
  }
  
  // Login
  Future<void> login(String email, String password) async {
    try {
      final response = await _apiService.post('auth/login', {
        'email': email,
        'mot_de_passe': password,
      });
      
      _token = response['access_token'];
      
      // Save token to storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      
      // Fetch user profile
      await _fetchUserProfile();
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  
  // Fetch user profile
  Future<void> _fetchUserProfile() async {
    if (_token == null) return;
    
    try {
      final profileData = await _apiService.get('auth/me', token: _token);
      _userData = profileData;
      
      // Save user data to storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', json.encode(_userData));
      
      notifyListeners();
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }
  
  // Logout
  Future<void> logout() async {
    _token = null;
    _userData = null;
    
    // Clear storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_data');
    
    notifyListeners();
  }
}