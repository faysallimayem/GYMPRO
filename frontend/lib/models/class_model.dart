class GymClass {
  final String id;
  final String className;
  final String startTime;
  final String endTime;
  final String instructor;
  final String instructorImageUrl;
  final int duration; // in minutes
  final int capacity;
  final int bookedSpots;
  final String classType; // "Cardio", "Strength", "Yoga"
  final DateTime date;
  bool isUserBooked;

  GymClass({
    required this.id,
    required this.className,
    required this.startTime,
    required this.endTime,
    required this.instructor,
    this.instructorImageUrl = '',
    required this.duration,
    required this.capacity,
    required this.bookedSpots,
    required this.classType,
    required this.date,
    this.isUserBooked = false,
  });

  // Number of spots left
  int get spotsLeft => capacity - bookedSpots;

  // Check if class is full
  bool get isFull => spotsLeft <= 0;

  // Parse from JSON
  factory GymClass.fromJson(Map<String, dynamic> json) {
    return GymClass(
      id: json['id'] ?? '',
      className: json['className'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      instructor: json['instructor'] ?? '',
      instructorImageUrl: json['instructorImageUrl'] ?? '',
      duration: json['duration'] ?? 0,
      capacity: json['capacity'] ?? 0,
      bookedSpots: json['bookedSpots'] ?? 0,
      classType: json['classType'] ?? 'Cardio',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      isUserBooked: json['isUserBooked'] ?? false,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'className': className,
      'startTime': startTime,
      'endTime': endTime,
      'instructor': instructor,
      'instructorImageUrl': instructorImageUrl,
      'duration': duration,
      'capacity': capacity,
      'bookedSpots': bookedSpots,
      'classType': classType,
      'date': date.toIso8601String().split('T')[0], // Format as YYYY-MM-DD only
    };

    // Only include id if it's not empty (for existing classes)
    if (id.isNotEmpty) {
      data['id'] = id;
    }

    return data;
  }

  // Create a copy with modifications
  GymClass copyWith({
    String? id,
    String? className,
    String? startTime,
    String? endTime,
    String? instructor,
    String? instructorImageUrl,
    int? duration,
    int? capacity,
    int? bookedSpots,
    String? classType,
    DateTime? date,
    bool? isUserBooked,
  }) {
    return GymClass(
      id: id ?? this.id,
      className: className ?? this.className,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      instructor: instructor ?? this.instructor,
      instructorImageUrl: instructorImageUrl ?? this.instructorImageUrl,
      duration: duration ?? this.duration,
      capacity: capacity ?? this.capacity,
      bookedSpots: bookedSpots ?? this.bookedSpots,
      classType: classType ?? this.classType,
      date: date ?? this.date,
      isUserBooked: isUserBooked ?? this.isUserBooked,
    );
  }
}
