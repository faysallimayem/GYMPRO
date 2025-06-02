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
  final bool isGymMember;
  final DateTime? membershipExpiresAt;

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
    this.isGymMember = false,
    this.membershipExpiresAt,
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
      isGymMember: json['isGymMember'] ?? false,
      membershipExpiresAt: json['membershipExpiresAt'] != null 
          ? DateTime.parse(json['membershipExpiresAt']) 
          : null,
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
      'isGymMember': isGymMember,
    };

    if (age != null) data['age'] = age;
    if (height != null) data['height'] = height;
    if (weight != null) data['weight'] = weight;
    if (membershipExpiresAt != null) {
      data['membershipExpiresAt'] = membershipExpiresAt!.toIso8601String();
    }

    return data;
  }

  String get fullName => '$firstName $lastName';
  
  // Helper method to check if membership is active
  bool get isMembershipActive => 
      isGymMember && (membershipExpiresAt == null || membershipExpiresAt!.isAfter(DateTime.now()));
      
  // Helper method to get days remaining in membership
  int? get membershipDaysRemaining {
    if (!isGymMember || membershipExpiresAt == null) return null;
    
    final now = DateTime.now();
    if (membershipExpiresAt!.isBefore(now)) return 0;
    
    return membershipExpiresAt!.difference(now).inDays + 1;
  }
}
