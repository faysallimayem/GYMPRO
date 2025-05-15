class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final int? age;
  final double? height;
  final double? weight;
  final String gender;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.age,
    this.height,
    this.weight,
    required this.gender,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      age: json['age'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      gender: json['gender'] ?? '',
      role: json['role'] ?? 'client',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'role': role,
    };

    if (age != null) data['age'] = age;
    if (height != null) data['height'] = height;
    if (weight != null) data['weight'] = weight;

    return data;
  }

  String get fullName => '$firstName $lastName';
}
