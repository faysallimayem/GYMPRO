import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/nutrition.dart';
import '../services/nutrition_service.dart';
import '../widgets.dart';
import '../nutrition_calculator_screen/nutrition_calculator_screen.dart';
import '../meal_creation_screen/meal_creation_screen.dart';
import '../services/navigation_provider.dart';
import 'package:provider/provider.dart';
import '../routes/app_routes.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final TextEditingController _searchController = TextEditingController();
  final NutritionService _nutritionService = NutritionService();
  List<Nutrition> _nutritionItems = [];
  List<String> _categories = [];
  bool _isLoading = true;
  String? _selectedCategory;
  String _searchQuery = '';
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      print('NutritionScreen: Loading nutrition data');

      // Load categories with detailed error handling
      try {
        final categories = await _nutritionService.getAllCategories();
        print('NutritionScreen: Loaded ${categories.length} categories: $categories');
        
        if (mounted) {
          setState(() {
            _categories = categories;
          });
        }
      } catch (e) {
        print('NutritionScreen: Error loading categories: $e');
        // Continue execution to try loading nutrition items
      }

      // Load nutrition items with filter if set
      List<Nutrition> nutritionItems = [];
      try {
        if (_selectedCategory != null) {
          print('NutritionScreen: Loading nutrition items for category: $_selectedCategory');
          nutritionItems = await _nutritionService.getNutritionByCategory(_selectedCategory!);
          print('NutritionScreen: Category items response: ${nutritionItems.length} items');
        } else if (_searchQuery.isNotEmpty) {
          print('NutritionScreen: Searching nutrition items for: $_searchQuery');
          nutritionItems = await _nutritionService.searchNutrition(_searchQuery);
        } else {
          print('NutritionScreen: Loading all nutrition items');
          nutritionItems = await _nutritionService.getAllNutrition();
        }
        
        print('NutritionScreen: Loaded ${nutritionItems.length} nutrition items');
      } catch (e) {
        print('NutritionScreen: Error loading nutrition items: $e');
        throw e; // Rethrow to be caught by the outer catch block
      }

      if (mounted) {
        setState(() {
          _nutritionItems = nutritionItems;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('NutritionScreen: Error in _loadData: $e');

      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  void _onCategorySelected(String? category) {
    print('NutritionScreen: Category selected: $category');
    setState(() {
      _selectedCategory = category;
    });
    _loadData();
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16),
            _buildSearchBar(context),
            SizedBox(height: 16),
            _buildFeatureButtons(context),
            SizedBox(height: 16),
            _buildCategoryFilter(context),
            SizedBox(height: 16),            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? _buildErrorView()
                      : _nutritionItems.isEmpty
                          ? _buildEmptyState()
                          : _buildNutritionList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48),
          SizedBox(height: 16),
          Text(
            'Error loading data: $_error',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButtons(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calculate, size: 16),
              label: const Text('Nutrition Calculator'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                // Use navigation provider to handle navigation and state
                navigationProvider.navigateDirectly(
                  context, 
                  const NutritionCalculatorScreen(),
                  AppRoutes.nutritionCalculatorScreen
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.restaurant_menu, size: 16),
              label: const Text('Meal Creator'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                // Use navigation provider to handle navigation and state
                navigationProvider.navigateDirectly(
                  context, 
                  const MealCreationScreen(),
                  AppRoutes.mealCreationScreen
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: CustomSearchView(
        controller: _searchController,
        hintText: "Search by name",
        contentPadding: EdgeInsetsDirectional.fromSTEB(14, 4, 10, 4),
        onChanged: _onSearch, // Use onChanged to handle search queries
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryChip(context, null, 'All'),
          ..._categories.map(
              (category) => _buildCategoryChip(context, category, category)),
        ],
      ),
    );
  }  Widget _buildCategoryChip(
      BuildContext context, String? category, String label) {
    final isSelected = (category == _selectedCategory) ||
        (category == null && _selectedCategory == null);

    print('NutritionScreen: Building category chip: $label, isSelected: $isSelected');
    
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 8),
      child: FilterChip(
        label: label,  // Use the String label directly, not a Text widget
        selected: isSelected,
        onSelected: (_) {
          print('NutritionScreen: Category selected: $label (value: $category)');
          _onCategorySelected(category);
        },
        backgroundColor: appTheme.blueGray100,
        selectedColor: theme.colorScheme
            .primary, // Use theme.colorScheme.primary instead of appTheme.primary
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildNutritionList(BuildContext context) {
    return ListView.builder(
      itemCount: _nutritionItems.length,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final item = _nutritionItems[index];
        return _buildNutritionCard(context, item);
      },
    );
  }

  Widget _buildNutritionCard(BuildContext context, Nutrition item) {
    return Card(
      margin: EdgeInsetsDirectional.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: EdgeInsetsDirectional.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.imageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 60,
                        color: appTheme.blueGray100,
                        child: Icon(Icons.restaurant, color: Colors.grey),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: appTheme.blueGray100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.restaurant, color: Colors.grey),
                  ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Category: ${item.category}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNutrientInfo(
                    'Protein', '${item.protein.toStringAsFixed(1)}g'),
                _buildNutrientInfo(
                    'Calories', item.calories.toStringAsFixed(0)),
                _buildNutrientInfo('Fat', '${item.fat.toStringAsFixed(1)}g'),
                _buildNutrientInfo(
                    'Carbs', '${item.carbohydrates.toStringAsFixed(1)}g'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
  Widget _buildEmptyState() {
    String message = 'No nutrition items found';
    
    if (_error != null) {
      // Show error message if there was an error
      message = 'Error loading nutrition data:\n${_error!}';
    } else if (_selectedCategory != null) {
      message = 'No nutrition items found in category: $_selectedCategory';
    } else if (_searchQuery.isNotEmpty) {
      message = 'No results found for: "$_searchQuery"';
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.no_food, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Clear filters and reload
              setState(() {
                _selectedCategory = null;
                _searchQuery = '';
                _searchController.clear();
                _error = null; // Clear any previous errors
              });
              _loadData();
            },
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Function(bool) onSelected;
  final Color backgroundColor;
  final Color selectedColor;
  final TextStyle labelStyle;

  const FilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    required this.backgroundColor,
    required this.selectedColor,
    required this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(!selected),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? selectedColor : backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: labelStyle,
        ),
      ),
    );
  }
}
