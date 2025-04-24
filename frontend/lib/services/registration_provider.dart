import 'package:flutter/foundation.dart';

class RegistrationProvider extends ChangeNotifier {
  // Basic user info (from first signup screen)
  String? nom;
  String? prenom;
  String? email;
  String? mot_de_passe;
  
  // Additional info (from subsequent screens)
  String? sexe;      // From gender screen
  int? age;          // From age screen
  int? hauteur;      // From height screen
  int? poids;        // From weight screen
  String role = 'client';  // Changed to lowercase to match backend enum
  
  // Set basic info from signup screen
  void setBasicInfo({
    required String nom,
    required String prenom,
    required String email,
    required String motDePasse,
  }) {
    this.nom = nom;
    this.prenom = prenom;
    this.email = email;
    this.mot_de_passe = motDePasse;
    notifyListeners();
  }
  
  // Set gender from gender screen
  void setGender(String sexe) {
    this.sexe = sexe;
    notifyListeners();
  }
  
  // Set age from age screen
  void setAge(int age) {
    this.age = age;
    notifyListeners();
  }
  
  // Set height from height screen
  void setHeight(int hauteur) {
    this.hauteur = hauteur;
    notifyListeners();
  }
  
  // Set weight from weight screen
  void setWeight(int poids) {
    this.poids = poids;
    notifyListeners();
  }
  
  // Check if all required data is available
  bool get isRegistrationComplete => 
    nom != null && 
    prenom != null && 
    email != null && 
    mot_de_passe != null && 
    sexe != null && 
    age != null;
  
  // Get complete user data for API
  Map<String, dynamic> getCompleteUserData() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'mot_de_passe': mot_de_passe,
      'sexe': sexe,
      'age': age,
      'hauteur': hauteur,
      'poids': poids,
      'role': role,
    };
  }
  
  // Reset all data
  void reset() {
    nom = null;
    prenom = null;
    email = null;
    mot_de_passe = null;
    sexe = null;
    age = null;
    hauteur = null;
    poids = null;
    notifyListeners();
  }
}