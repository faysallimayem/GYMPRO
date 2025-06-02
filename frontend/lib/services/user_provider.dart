import 'package:flutter/material.dart';
import 'auth_service.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  String _username = 'Guest';
  String _email = 'user@example.com';
  String? _photoUrl;
  bool _isPremium = false;
  int? _age;
  double? _height;
  double? _weight;
  String? _gender;
  String? _firstName;
  String? _lastName;
  int? _userId;
  String? _role;
  bool _isGymMember = false;
  DateTime? _membershipExpiresAt;
  String? _gymName;
  int? _gymId;
  
  // Getters
  String get username => _username;
  String get email => _email;
  String? get photoUrl => _photoUrl;
  bool get isPremium => _isPremium;
  int? get age => _age;
  double? get height => _height;
  double? get weight => _weight;
  String? get gender => _gender;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  int? get userId => _userId;
  String? get role => _role;
  bool get isGymMember => _isGymMember;
  DateTime? get membershipExpiresAt => _membershipExpiresAt;
  String? get gymName => _gymName;
  int? get gymId => _gymId;
  
  // Create a User model from the provider data
  User toUserModel() {
    return User(
      id: _userId ?? 0,
      email: _email,
      firstName: _firstName ?? '',
      lastName: _lastName ?? '',
      gender: _gender ?? '',
      role: _role ?? 'client',
      age: _age,
      height: _height,
      weight: _weight,
      isGymMember: _isGymMember,
      membershipExpiresAt: _membershipExpiresAt,
    );
  }
  
  // Initialize with AuthService data
  Future<void> syncWithAuthService() async {
    final authService = AuthService();
    final userData = await authService.getUserDetails();
      if (userData != null) {
      // Extract user data from the backend response format
      if (userData['id'] != null) {
        _userId = userData['id'] is int ? userData['id'] : int.tryParse(userData['id'].toString());
      }
      
      if (userData['firstName'] != null && userData['lastName'] != null) {
        _firstName = userData['firstName'];
        _lastName = userData['lastName'];
        _username = "${userData['firstName']} ${userData['lastName']}";
      } else if (userData['username'] != null) {
        _username = userData['username'];
      }
      
      if (userData['email'] != null) {
        _email = userData['email'];
      }
      
      if (userData['photoUrl'] != null) {
        _photoUrl = userData['photoUrl'];
      }
      
      if (userData['role'] != null) {
        _role = userData['role'];
      }
      
      // Extract gym membership data
      if (userData['isGymMember'] != null) {
        _isGymMember = userData['isGymMember'] is bool 
            ? userData['isGymMember'] 
            : userData['isGymMember'].toString().toLowerCase() == 'true';
      }
      
      if (userData['membershipExpiresAt'] != null) {
        try {
          _membershipExpiresAt = DateTime.parse(userData['membershipExpiresAt']);
        } catch (e) {
          print('Error parsing membership expiration date: $e');
        }
      }
      
      // Extract additional user profile fields
      if (userData['age'] != null) {
        _age = userData['age'] is int ? userData['age'] : int.tryParse(userData['age'].toString());
      }
      
      if (userData['height'] != null) {
        _height = userData['height'] is double ? userData['height'] : double.tryParse(userData['height'].toString());
      }
      
      if (userData['weight'] != null) {
        _weight = userData['weight'] is double ? userData['weight'] : double.tryParse(userData['weight'].toString());
      }
      
      if (userData['gender'] != null) {
        _gender = userData['gender'];
      }
        // Extract gym info for admins/coaches
      if (userData['managedGym'] != null) {
        _gymId = userData['managedGym']['id'];
        _gymName = userData['managedGym']['name'] ?? 'Unknown Gym';
      } 
      // Extract gym info for clients
      else if (userData['gym'] != null) {
        _gymId = userData['gym']['id'];
        _gymName = userData['gym']['name'] ?? 'Unknown Gym';
      } else {
        _gymId = null;
        _gymName = null;
      }
      
      notifyListeners();
    }
  }
    // Update user data
  Future<void> updateUserData({
    String? username,
    String? email,
    String? photoUrl,
    int? age,
    double? height,
    double? weight,
    String? gender,
    String? firstName,
    String? lastName,
    String? role,
    bool? isGymMember,
    DateTime? membershipExpiresAt,
    int? userId,
  }) async {
    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 500));
    
    if (username != null) _username = username;
    if (email != null) _email = email;
    if (photoUrl != null) _photoUrl = photoUrl;
    if (age != null) _age = age;
    if (height != null) _height = height;
    if (weight != null) _weight = weight;
    if (gender != null) _gender = gender;
    if (firstName != null) _firstName = firstName;
    if (lastName != null) _lastName = lastName;
    if (role != null) _role = role;
    if (isGymMember != null) _isGymMember = isGymMember;
    if (membershipExpiresAt != null) _membershipExpiresAt = membershipExpiresAt;
    if (userId != null) _userId = userId;
    
    notifyListeners();
  }
  
  // Update premium status
  Future<void> updatePremiumStatus(bool isPremium) async {
    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 500));
    
    _isPremium = isPremium;
    notifyListeners();
  }
  
  // Sign out
  Future<void> signOut() async {
    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 800));
    
    // Reset to default values
    _username = 'Guest';
    _email = '';
    _photoUrl = null;
    _isPremium = false;
    _age = null;
    _height = null;
    _weight = null;
    _gender = null;
    _firstName = null;
    _lastName = null;
    
    notifyListeners();
  }
}