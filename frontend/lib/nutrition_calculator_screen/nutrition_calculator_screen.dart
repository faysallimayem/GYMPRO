import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../app_theme.dart';
import '../models/nutrition.dart';
import '../services/meal_service.dart';
import '../services/nutrition_service.dart';
import '../services/auth_service.dart';

class NutritionCalculatorScreen extends StatefulWidget {
  const NutritionCalculatorScreen({super.key});

  @override
  State<NutritionCalculatorScreen> createState() => _NutritionCalculatorScreenState();
}

class _NutritionCalculatorScreenState extends State<NutritionCalculatorScreen> {
  // Using the updated services that properly fetch tokens from SharedPreferences
  final MealService _mealService = MealService();
  final NutritionService _nutritionService = NutritionService();
  final AuthService _authService = AuthService();
  
  List<Nutrition> _availableNutrition = [];
  List<Map<String, dynamic>> _selectedItems = [];
  
  bool _isLoading = true;
  bool _isCalculating = false;
  String _searchQuery = '';
  String? _error;
  
  // Calculation results
  Map<String, dynamic>? _calculationResult;
  
  // Target values
  final TextEditingController _targetCaloriesController = TextEditingController();
  final TextEditingController _targetProteinController = TextEditingController();
  final TextEditingController _targetFatController = TextEditingController();
  final TextEditingController _targetCarbsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }
  
  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      print('NutritionCalculatorScreen: Loading nutrition data');
      
      // Fetch nutrition data using the updated nutrition service
      final nutritionItems = await _nutritionService.fetchNutrition();
      
      print('NutritionCalculatorScreen: Loaded ${nutritionItems.length} nutrition items');
      
      // After successful fetch, update the state
      if (mounted) {
        setState(() {
          _availableNutrition = nutritionItems;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('NutritionCalculatorScreen: Error loading data: $e');
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }
  
  List<Nutrition> get _filteredNutrition {
    if (_searchQuery.isEmpty) return _availableNutrition;
    return _availableNutrition.where((item) => 
      item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      (item.category?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
    ).toList();
  }
  
  void _addItemToCalculator(Nutrition nutrition) {
    setState(() {
      _selectedItems.add({
        'nutritionId': nutrition.id,
        'quantity': 1.0,
        'nutrition': nutrition
      });
    });
  }
  
  void _updateItemQuantity(int index, double newQuantity) {
    if (newQuantity <= 0) return;
    
    setState(() {
      _selectedItems[index]['quantity'] = newQuantity;
    });
  }
  
  void _removeItem(int index) {
    setState(() {
      _selectedItems.removeAt(index);
    });
  }
  
  Future<void> _calculateNutrition() async {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one item to calculate')),
      );
      return;
    }
    
    setState(() => _isCalculating = true);
    
    try {
      // Parse target values
      double? targetCalories = _targetCaloriesController.text.isNotEmpty 
          ? double.parse(_targetCaloriesController.text) 
          : null;
      
      double? targetProtein = _targetProteinController.text.isNotEmpty 
          ? double.parse(_targetProteinController.text) 
          : null;
      
      double? targetFat = _targetFatController.text.isNotEmpty 
          ? double.parse(_targetFatController.text) 
          : null;
      
      double? targetCarbs = _targetCarbsController.text.isNotEmpty 
          ? double.parse(_targetCarbsController.text) 
          : null;
      
      // Calculate nutrition values
      final Map<String, dynamic> result = {};
      
      // Calculate totals from the selected items
      double totalCalories = 0;
      double totalProtein = 0;
      double totalFat = 0;
      double totalCarbs = 0;
      
      for (var item in _selectedItems) {
        final Nutrition nutrition = item['nutrition'] as Nutrition;
        final double quantity = item['quantity'] ?? 1.0;
        
        totalCalories += nutrition.calories * quantity;
        totalProtein += nutrition.protein * quantity;
        totalFat += nutrition.fat * quantity;
        totalCarbs += nutrition.carbohydrates * quantity; // Fixed property name
      }
      
      // Prepare the result object
      result['totalCalories'] = totalCalories;
      result['totalProtein'] = totalProtein;
      result['totalFat'] = totalFat;
      result['totalCarbohydrates'] = totalCarbs;
      
      // Add target comparison if targets were provided
      if (targetCalories != null || targetProtein != null || 
          targetFat != null || targetCarbs != null) {
        
        Map<String, dynamic> targetComparison = {};
        
        if (targetCalories != null && targetCalories > 0) {
          targetComparison['caloriePercentage'] = (totalCalories / targetCalories) * 100;
        }
        
        if (targetProtein != null && targetProtein > 0) {
          targetComparison['proteinPercentage'] = (totalProtein / targetProtein) * 100;
        }
        
        if (targetFat != null && targetFat > 0) {
          targetComparison['fatPercentage'] = (totalFat / targetFat) * 100;
        }
        
        if (targetCarbs != null && targetCarbs > 0) {
          targetComparison['carbohydratesPercentage'] = (totalCarbs / targetCarbs) * 100;
        }
        
        result['targetComparison'] = targetComparison;
      }
      
      setState(() {
        _calculationResult = result;
        _isCalculating = false;
      });
    } catch (e) {
      setState(() => _isCalculating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error calculating nutrition: ${e.toString()}')),
      );
    }
  }
  
  void _clearCalculator() {
    setState(() {
      _selectedItems = [];
      _calculationResult = null;
      _targetCaloriesController.clear();
      _targetProteinController.clear();
      _targetFatController.clear();
      _targetCarbsController.clear();
    });
  }
  
  void _showSaveMealDialog() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add items to create a meal')),
      );
      return;
    }
    
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save as Meal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Meal Name',
                    hintText: 'Enter a name for your meal',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Enter a description',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
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
                _saveMeal(nameController.text, descriptionController.text);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
  
  Future<void> _saveMeal(String name, String description) async {
    try {
      if (!mounted) return;
      
      setState(() => _isLoading = true);
      
      // Convert selected items to a format suitable for the API
      final List<Map<String, dynamic>> mealItems = _selectedItems.map((item) {
        return {
          'nutritionId': (item['nutrition'] as Nutrition).id,
          'quantity': item['quantity'] as double,
        };
      }).toList();
      
      // Create meal using the format expected by MealService
      final Map<String, dynamic> mealData = {
        'name': name,
        'description': description.isNotEmpty ? description : null,
        'items': mealItems,
      };
      
      await _mealService.createMeal(mealData);
      
      if (mounted) {
        setState(() => _isLoading = false);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Meal "$name" saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving meal: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Calculator'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildCalculatorContent(),
    );
  }
  
  Widget _buildCalculatorContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Calculate Nutrition Values',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildTargetInputs(),
          const Divider(height: 32),
          _buildSelectedItemsList(),
          _buildActionButtons(),
          const Divider(height: 32),
          _buildSearchBar(),
          Expanded(child: _buildAvailableItemsList()),
          if (_calculationResult != null) _buildCalculationResults(),
        ],
      ),
    );
  }
  
  Widget _buildTargetInputs() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nutrition Targets (Optional)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _targetCaloriesController,
                    decoration: const InputDecoration(
                      labelText: 'Calories',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _targetProteinController,
                    decoration: const InputDecoration(
                      labelText: 'Protein (g)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _targetFatController,
                    decoration: const InputDecoration(
                      labelText: 'Fat (g)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _targetCarbsController,
                    decoration: const InputDecoration(
                      labelText: 'Carbs (g)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSelectedItemsList() {
    if (_selectedItems.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text('Add nutrition items to calculate',
              style: TextStyle(fontStyle: FontStyle.italic)),
        ),
      );
    }
    
    return SizedBox(
      height: 150,
      child: Card(
        elevation: 2,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _selectedItems.length,
          itemBuilder: (context, index) {
            final item = _selectedItems[index];
            final nutrition = item['nutrition'] as Nutrition;
            
            return ListTile(
              title: Text(nutrition.name),
              subtitle: Text('${(nutrition.calories * (item['quantity'] as double)).toStringAsFixed(0)} cal, '
                  '${(nutrition.protein * (item['quantity'] as double)).toStringAsFixed(1)}g protein'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      final newQuantity = (item['quantity'] as double) - 0.5;
                      if (newQuantity > 0) {
                        _updateItemQuantity(index, newQuantity);
                      }
                    },
                  ),
                  Text('${item['quantity']}'),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      _updateItemQuantity(index, (item['quantity'] as double) + 0.5);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeItem(index),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.calculate),
            label: const Text('Calculate'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            onPressed: _isCalculating ? null : _calculateNutrition,
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Save as Meal'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondaryColor,
            ),
            onPressed: _selectedItems.isEmpty ? null : _showSaveMealDialog,
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.clear),
            label: const Text('Clear'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
            ),
            onPressed: _clearCalculator,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return TextField(
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Search nutrition items...',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }
  
  Widget _buildAvailableItemsList() {
    return Card(
      elevation: 2,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _filteredNutrition.length,
        itemBuilder: (context, index) {
          final nutrition = _filteredNutrition[index];
          return ListTile(
            title: Text(nutrition.name),
            subtitle: Text('${nutrition.calories} cal, ${nutrition.protein}g protein, '
                '${nutrition.category ?? "No category"}'),
            trailing: IconButton(
              icon: Icon(Icons.add_circle, color: AppTheme.primaryColor),
              onPressed: () => _addItemToCalculator(nutrition),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildCalculationResults() {
    final result = _calculationResult!;
    double totalCalories = result['totalCalories'];
    double totalProtein = result['totalProtein'];
    double totalFat = result['totalFat'];
    double totalCarbohydrates = result['totalCarbohydrates'];
    
    // Handle target comparisons if available
    Map<String, dynamic>? targetComparison = result['targetComparison'];
    
    return Card(
      color: Colors.grey[100],
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calculation Results',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildNutrientDisplay(
                    'Calories', 
                    totalCalories.toStringAsFixed(1),
                    targetComparison != null && targetComparison['caloriePercentage'] != null
                      ? targetComparison['caloriePercentage'] / 100
                      : null,
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildNutrientDisplay(
                    'Protein', 
                    '${totalProtein.toStringAsFixed(1)}g',
                    targetComparison != null && targetComparison['proteinPercentage'] != null
                      ? targetComparison['proteinPercentage'] / 100
                      : null,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildNutrientDisplay(
                    'Fat', 
                    '${totalFat.toStringAsFixed(1)}g',
                    targetComparison != null && targetComparison['fatPercentage'] != null
                      ? targetComparison['fatPercentage'] / 100
                      : null,
                    Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildNutrientDisplay(
                    'Carbs', 
                    '${totalCarbohydrates.toStringAsFixed(1)}g',
                    targetComparison != null && targetComparison['carbohydratesPercentage'] != null
                      ? targetComparison['carbohydratesPercentage'] / 100
                      : null,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNutrientDisplay(String label, String value, double? progress, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (progress != null)
          CircularPercentIndicator(
            radius: 40.0,
            lineWidth: 8.0,
            percent: progress > 1.0 ? 1.0 : progress,
            center: Text(value),
            progressColor: color,
            backgroundColor: Colors.grey[300]!,
            footer: Text(
              progress >= 1.0 ? '100% of target' : '${(progress * 100).toStringAsFixed(0)}% of target',
              style: const TextStyle(fontSize: 12),
            ),
          )
        else
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}