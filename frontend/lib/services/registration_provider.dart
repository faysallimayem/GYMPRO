// ignore_for_file: non_constant_identifier_names, unnecessary_this

import 'package:flutter/foundation.dart';

class RegistrationProvider extends ChangeNotifier {
  String? lastName;   
  String? firstName; 
  String? email;
  String? password;  
  String? gender;    
  int? age;          
  int? height;       
  int? weight;       
  String role = 'client';
  
  void setBasicInfo({
    required String lastName,
    required String firstName,
    required String email,
    required String password,
  }) {
    this.lastName = lastName;
    this.firstName = firstName;
    this.email = email;
    this.password = password;
    notifyListeners();
  }
  
  // Set gender from gender screen
  void setGender(String gender) {
    this.gender = gender;
    notifyListeners();
  }
  
  // Set age from age screen
  void setAge(int age) {
    this.age = age;
    notifyListeners();
  }
  
  // Set height from height screen
  void setHeight(int height) {
    this.height = height;
    notifyListeners();
  }
  
  // Set weight from weight screen
  void setWeight(int weight) {
    this.weight = weight;
    notifyListeners();
  }
  
  // Check if all required data is available
  bool get isRegistrationComplete => 
    lastName != null && 
    firstName != null && 
    email != null && 
    password != null && 
    gender != null && 
    age != null;
  
  // Get complete user data for API
  Map<String, dynamic> getCompleteUserData() {
    return {
      'lastName': lastName,
      'firstName': firstName,
      'email': email,
      'password': password,
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'role': role,
    };
  }
  
  // Reset all data
  void reset() {
    lastName = null;
    firstName = null;
    email = null;
    password = null;
    gender = null;
    age = null;
    height = null;
    weight = null;
    notifyListeners();
  }
}