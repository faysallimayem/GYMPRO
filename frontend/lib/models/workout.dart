class Workout {
  final int id;
  final String name;
  final String? description;
  final int? duration;
  final List<Exercise> exercises;
  final User? createdBy;

  Workout({
    required this.id,
    required this.name,
    this.description,
    this.duration,
    required this.exercises,
    this.createdBy,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    List<Exercise> exercises = [];

    if (json['exercises'] != null) {
      exercises = (json['exercises'] as List)
          .map((exercise) => Exercise.fromJson(exercise))
          .toList();
    }

    return Workout(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      duration: json['duration'],
      exercises: exercises,
      createdBy:
          json['createdBy'] != null ? User.fromJson(json['createdBy']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (duration != null) 'duration': duration,
      'exercises': exercises.map((exercise) => {'id': exercise.id}).toList(),
    };
  }
}

class Exercise {
  final int id;
  final String name;
  final String? description;
  final String muscleGroup;
  final String? difficulty;
  final String? videoUrl;
  final String? imageUrl; // Added imageUrl property

  Exercise({
    required this.id,
    required this.name,
    this.description,
    required this.muscleGroup,
    this.difficulty,
    this.videoUrl,
    this.imageUrl, // Added to constructor
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      muscleGroup: json['muscleGroup'] ?? '',
      difficulty: json['difficulty'],
      videoUrl: json['videoUrl'],
      imageUrl: json['imageUrl'], // Parse from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      'muscleGroup': muscleGroup,
      if (difficulty != null) 'difficulty': difficulty,
      if (videoUrl != null) 'videoUrl': videoUrl,
      if (imageUrl != null) 'imageUrl': imageUrl, // Include in JSON output
    };
  }
}

class User {
  final int id;
  final String email;
  final String? firstName;
  final String? lastName;

  User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}
