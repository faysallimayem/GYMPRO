import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../models/nutrition.dart';
import '../services/meal_service.dart';
import '../services/auth_service.dart';
import '../app_theme.dart';
import '../nutrition_calculator_screen/nutrition_calculator_screen.dart';

class MealCreationScreen extends StatefulWidget {
  const MealCreationScreen({super.key});

  @override
  State<MealCreationScreen> createState() => _MealCreationScreenState();
}

class _MealCreationScreenState extends State<MealCreationScreen>
    with SingleTickerProviderStateMixin {
  final MealService _mealService = MealService();
  final AuthService _authService = AuthService();

  List<Meal> _meals = [];
  Map<String, List<dynamic>> _mealTemplates = {};
  bool _isLoading = true;

  int? _userId;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    setState(() => _isLoading = true);

    try {
      // Get user data from auth service
      final userData = await _authService.getUserDetails();
      _userId = userData?['id'];

      await Future.wait([
        _loadMeals(),
        _loadMealTemplates(),
      ]);

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: ${e.toString()}')),
      );
    }
  }

  Future<void> _loadMeals() async {
    try {
      final meals = await _mealService.getAllMeals(userId: _userId);
      setState(() => _meals = meals);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading meals: ${e.toString()}')),
      );
    }
  }

  Future<void> _loadMealTemplates() async {
    try {
      final templates = await _mealService.getMealTemplates();
      setState(() => _mealTemplates = templates);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error loading meal templates: ${e.toString()}')),
      );
    }
  }

  Future<void> _deleteMeal(int id) async {
    try {
      await _mealService.deleteMeal(id);
      _loadMeals();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meal deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting meal: ${e.toString()}')),
      );
    }
  }

  void _showMealDetails(Meal meal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    meal.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              if (meal.description != null && meal.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    meal.description!,
                    style: const TextStyle(
                        fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNutritionStat(
                        'Calories',
                        '${meal.totalCalories.toStringAsFixed(0)} kcal',
                        Colors.orange),
                    _buildNutritionStat(
                        'Protein',
                        '${meal.totalProtein.toStringAsFixed(1)}g',
                        Colors.blue),
                    _buildNutritionStat('Fat',
                        '${meal.totalFat.toStringAsFixed(1)}g', Colors.red),
                    _buildNutritionStat(
                        'Carbs',
                        '${meal.totalCarbohydrates.toStringAsFixed(1)}g',
                        Colors.green),
                  ],
                ),
              ),
              const Divider(),
              const Text(
                'Meal Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: meal.items.length,
                  itemBuilder: (context, index) {
                    final item = meal.items[index];
                    return ListTile(
                      leading: item.nutrition?.imageUrl != null
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(item.nutrition!.imageUrl!),
                            )
                          : CircleAvatar(
                              backgroundColor: AppTheme.primaryColor,
                              child: Text(item.nutrition!.name.substring(0, 1)),
                            ),
                      title: Text(item.nutrition?.name ?? 'Unknown'),
                      subtitle: Text(
                          'Quantity: ${item.quantity} ${item.unit}\n'
                          'Calories: ${item.calories.toStringAsFixed(1)} | '
                          'Protein: ${item.protein.toStringAsFixed(1)}g',
                          style: const TextStyle(fontSize: 12)),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNutritionStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  void _createMealFromTemplate(String templateName, List<dynamic> foods) async {
    final TextEditingController nameController =
        TextEditingController(text: templateName);
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Meal from Template'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Meal Name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a meal name')),
                );
                return;
              }

              Navigator.of(context).pop();
              await _saveMealFromTemplate(
                nameController.text,
                descriptionController.text,
                foods,
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveMealFromTemplate(
      String name, String description, List<dynamic> foods) async {
    try {
      setState(() => _isLoading = true);

      final items = foods.map((food) {
        final nutrition = Nutrition.fromJson(food);
        return {'nutritionId': nutrition.id, 'quantity': 1, 'unit': 'serving'};
      }).toList();

      final meal = {
        'name': name,
        'description': description,
        'userId': _userId,
        'items': items,
      };

      await _mealService.createMeal(meal);
      await _loadMeals();

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meal created successfully')),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating meal: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Creation System'),
        backgroundColor: AppTheme.primaryColor,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Meals'),
            Tab(text: 'Meal Templates'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildMyMealsTab(),
                _buildTemplatesTab(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NutritionCalculatorScreen()),
          ).then((_) =>
              _loadMeals()); // Reload meals when returning from calculator
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMyMealsTab() {
    if (_meals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_meals, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No meals found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NutritionCalculatorScreen()),
                ).then((_) => _loadMeals());
              },
              icon: const Icon(Icons.add),
              label: const Text('Create a Meal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _meals.length,
      itemBuilder: (context, index) {
        final meal = _meals[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            title: Text(
              meal.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (meal.description != null && meal.description!.isNotEmpty)
                  Text(
                    meal.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                Text(
                  '${meal.items.length} items | '
                  '${meal.totalCalories.toStringAsFixed(0)} cal | '
                  '${meal.totalProtein.toStringAsFixed(1)}g protein',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteMeal(meal.id!),
                ),
              ],
            ),
            onTap: () => _showMealDetails(meal),
          ),
        );
      },
    );
  }

  Widget _buildTemplatesTab() {
    if (_mealTemplates.isEmpty) {
      return const Center(
        child: Text('No meal templates available'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _mealTemplates.keys.length,
      itemBuilder: (context, index) {
        final templateName = _mealTemplates.keys.elementAt(index);
        final foods = _mealTemplates[templateName]!;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: ExpansionTile(
            title: Text(
              templateName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${foods.length} items'),
            children: [
              ...foods.map((food) {
                final nutrition = Nutrition.fromJson(food);
                return ListTile(
                  title: Text(nutrition.name),
                  subtitle: Text(
                    'Calories: ${nutrition.calories} | '
                    'Protein: ${nutrition.protein}g | '
                    'Category: ${nutrition.category}',
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => _createMealFromTemplate(templateName, foods),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                  ),
                  child: const Text('Create Meal from Template'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
