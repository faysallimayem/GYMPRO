class Nutrition {
  final int? id;
  final String name;
  final String? category;
  final double calories;
  final double protein;
  final double fat;
  final double carbohydrates;
  final String? imageUrl;
  final String? unit;
  final bool isFavorite;

  Nutrition({
    this.id,
    required this.name,
    this.category,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbohydrates,
    this.imageUrl,
    this.unit = 'g',
    this.isFavorite = false,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      calories: json['calories']?.toDouble() ?? 0,
      protein: json['protein']?.toDouble() ?? 0,
      fat: json['fat']?.toDouble() ?? 0,
      carbohydrates: json['carbohydrates']?.toDouble() ?? 0,
      imageUrl: json['imageUrl'],
      unit: json['unit'] ?? 'g',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbohydrates': carbohydrates,
      'imageUrl': imageUrl,
      'unit': unit,
    };
  }

  Nutrition copyWith({
    int? id,
    String? name,
    String? category,
    double? calories,
    double? protein,
    double? fat,
    double? carbohydrates,
    String? imageUrl,
    String? unit,
    bool? isFavorite,
  }) {
    return Nutrition(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      imageUrl: imageUrl ?? this.imageUrl,
      unit: unit ?? this.unit,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}