// ignore_for_file: unnecessary_this, avoid_function_literals_in_foreach_calls

import 'nutrition.dart';

class MealItem {
  final int? id;
  final int nutritionId;
  final Nutrition? nutrition;
  final double quantity;
  final String unit;

  MealItem({
    this.id,
    required this.nutritionId,
    this.nutrition,
    this.quantity = 1.0,
    this.unit = 'serving',
  });

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      id: json['id'],
      nutritionId: json['nutritionId'],
      nutrition: json['nutrition'] != null 
          ? Nutrition.fromJson(json['nutrition']) 
          : null,
      quantity: json['quantity']?.toDouble() ?? 1.0,
      unit: json['unit'] ?? 'serving',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nutritionId': nutritionId,
      'quantity': quantity,
      'unit': unit,
    };
  }

  double get calories => (nutrition?.calories ?? 0) * quantity;
  double get protein => (nutrition?.protein ?? 0) * quantity;
  double get fat => (nutrition?.fat ?? 0) * quantity;
  double get carbohydrates => (nutrition?.carbohydrates ?? 0) * quantity;
}

class Meal {
  final int? id;
  final String name;
  final String? description;
  final int? userId;
  final List<MealItem> items;
  final double totalCalories;
  final double totalProtein;
  final double totalFat;
  final double totalCarbohydrates;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isFavorite;

  Meal({
    this.id,
    required this.name,
    this.description,
    this.userId,
    required this.items,
    double? totalCalories,
    double? totalProtein,
    double? totalFat,
    double? totalCarbohydrates,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.isFavorite = false,
  }) : 
    this.totalCalories = totalCalories ?? items.fold(0, (sum, item) => sum + item.calories),
    this.totalProtein = totalProtein ?? items.fold(0, (sum, item) => sum + item.protein),
    this.totalFat = totalFat ?? items.fold(0, (sum, item) => sum + item.fat),
    this.totalCarbohydrates = totalCarbohydrates ?? items.fold(0, (sum, item) => sum + item.carbohydrates);

  factory Meal.fromJson(Map<String, dynamic> json) {
    final List<MealItem> mealItems = [];
    if (json['items'] != null) {
      (json['items'] as List).forEach((itemJson) {
        mealItems.add(MealItem.fromJson(itemJson));
      });
    }

    return Meal(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      userId: json['userId'],
      items: mealItems,
      totalCalories: json['totalCalories']?.toDouble(),
      totalProtein: json['totalProtein']?.toDouble(),
      totalFat: json['totalFat']?.toDouble(),
      totalCarbohydrates: json['totalCarbohydrates']?.toDouble(),
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'imageUrl': imageUrl,
    };
  }

  Meal copyWith({
    int? id,
    String? name,
    String? description,
    int? userId,
    List<MealItem>? items,
    double? totalCalories,
    double? totalProtein,
    double? totalFat,
    double? totalCarbohydrates,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProtein: totalProtein ?? this.totalProtein,
      totalFat: totalFat ?? this.totalFat,
      totalCarbohydrates: totalCarbohydrates ?? this.totalCarbohydrates,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}