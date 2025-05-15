// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app_theme.dart';
import '../models/class_model.dart';
import '../services/class_service.dart';
import '../responsive_utils.dart';

class CourseManagementScreen extends StatefulWidget {
  const CourseManagementScreen({super.key});

  @override
  _CourseManagementScreenState createState() => _CourseManagementScreenState();
}

class _CourseManagementScreenState extends State<CourseManagementScreen> {
  final ClassService _classService = ClassService();
  List<GymClass> _classes = [];
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();
  String _selectedClassType = 'All Classes';

  // UI display mappings for class types
  final Map<String, String> _classTypeDisplayMap = {
    'All Classes': 'All Classes',
    'CARDIO': 'Cardio',
    'STRENGTH': 'Strength',
    'YOGA': 'Yoga',
  };
  // Backend formats
  final List<String> _classTypes = [
    'All Classes',
    'CARDIO',
    'STRENGTH',
    'YOGA'
  ];

  // Get display name for a class type
  String getClassTypeDisplay(String classType) {
    return _classTypeDisplayMap[classType] ?? classType;
  }

  // Convert between backend and frontend class type formats
  String backendToFrontendType(String backendType) {
    switch (backendType) {
      case 'Cardio':
        return 'CARDIO';
      case 'Strength':
        return 'STRENGTH';
      case 'Yoga':
        return 'YOGA';
      default:
        return backendType;
    }
  }

  // Convert from frontend to backend format
  String frontendToBackendType(String frontendType) {
    switch (frontendType) {
      case 'CARDIO':
        return 'Cardio';
      case 'STRENGTH':
        return 'Strength';
      case 'YOGA':
        return 'Yoga';
      default:
        return frontendType;
    }
  }

  // Ensure we get a class type that matches the dropdown values
  String normalizeClassTypeForDropdown(String classType) {
    // Convert from backend format (if needed)
    switch (classType) {
      case 'Cardio':
        return 'CARDIO';
      case 'Strength':
        return 'STRENGTH';
      case 'Yoga':
        return 'YOGA';
      default:
        return classType;
    }
  }

  @override
  void initState() {
    super.initState();
    print('Display map: $_classTypeDisplayMap');
    print('Class types: $_classTypes');
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final classes = await _classService.getClassesByDateAndType(
          _selectedDate, _selectedClassType);

      setState(() {
        _classes = classes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to load classes: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _deleteClass(String classId) async {
    try {
      await _classService.deleteClass(classId);
      _showSuccessSnackBar('Class deleted successfully');
      _loadClasses();
    } catch (e) {
      _showErrorSnackBar('Failed to delete class: $e');
    }
  }

  void _showAddClassDialog() {
    _showClassDialog(null);
  }

  void _showEditClassDialog(GymClass classToEdit) {
    _showClassDialog(classToEdit);
  }

  void _showClassDialog(GymClass? classToEdit) {
    final formKey = GlobalKey<FormState>();
    final isEditing = classToEdit != null;

    // Form controllers
    final classNameController =
        TextEditingController(text: classToEdit?.className ?? '');
    final instructorController =
        TextEditingController(text: classToEdit?.instructor ?? '');
    final startTimeController =
        TextEditingController(text: classToEdit?.startTime ?? '08:00');
    final endTimeController =
        TextEditingController(text: classToEdit?.endTime ?? '09:00');
    final durationController =
        TextEditingController(text: classToEdit?.duration.toString() ?? '45');
    final capacityController =
        TextEditingController(text: classToEdit?.capacity.toString() ?? '15');
    final bookedSpotsController =
        TextEditingController(text: classToEdit?.bookedSpots.toString() ?? '0');

    // Convert backend type to frontend format for the dropdown
    // We need to ensure we have a valid frontend type for the dropdown
    String dropdownClassType = 'CARDIO'; // Default value
    if (classToEdit != null) {
      // Convert backend type (like 'Cardio') to frontend format (like 'CARDIO')
      dropdownClassType = backendToFrontendType(classToEdit.classType);
    }

    DateTime selectedDate = classToEdit?.date ?? _selectedDate;

    print('Class types in dropdown: $_classTypes');
    print('Initial selectedClassType: $dropdownClassType');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Class' : 'Add New Class'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: classNameController,
                        decoration: InputDecoration(labelText: 'Class Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a class name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),

                      TextFormField(
                        controller: instructorController,
                        decoration:
                            InputDecoration(labelText: 'Instructor Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an instructor name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: startTimeController,
                              decoration: InputDecoration(
                                  labelText: 'Start Time (HH:MM)'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                // Simple time format validation
                                final timeRegex = RegExp(
                                    r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
                                if (!timeRegex.hasMatch(value)) {
                                  return 'Use format HH:MM';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: endTimeController,
                              decoration: InputDecoration(
                                  labelText: 'End Time (HH:MM)'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                // Simple time format validation
                                final timeRegex = RegExp(
                                    r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
                                if (!timeRegex.hasMatch(value)) {
                                  return 'Use format HH:MM';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      TextFormField(
                        controller: durationController,
                        decoration:
                            InputDecoration(labelText: 'Duration (minutes)'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Must be a number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: capacityController,
                              decoration:
                                  InputDecoration(labelText: 'Capacity'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Must be a number';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: bookedSpotsController,
                              decoration:
                                  InputDecoration(labelText: 'Booked Spots'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Must be a number';
                                }
                                final booked = int.parse(value);
                                final capacity =
                                    int.tryParse(capacityController.text) ?? 0;
                                if (booked > capacity) {
                                  return 'Cannot exceed capacity';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Class Type'),
                        value: dropdownClassType,
                        items: _classTypes
                            .where((type) =>
                                type !=
                                'All Classes') // Filter out 'All Classes' from the form dropdown
                            .map((String type) {
                          print(
                              'DropdownMenuItem: value=$type, display=${getClassTypeDisplay(type)}');
                          return DropdownMenuItem<String>(
                            value:
                                type, // Use the frontend enum value (CARDIO, STRENGTH, YOGA)
                            child: Text(getClassTypeDisplay(type)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              dropdownClassType = newValue;
                              print(
                                  'New selected class type: $dropdownClassType');
                            });
                          }
                        },
                      ),
                      SizedBox(height: 15),

                      // Date picker
                      ListTile(
                        title: Text('Class Date'),
                        subtitle:
                            Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                        trailing: Icon(Icons.calendar_today),
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate:
                                DateTime.now().subtract(Duration(days: 365)),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (pickedDate != null &&
                              pickedDate != selectedDate) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.deepOrange500,
                  ),
                  child: Text(isEditing ? 'Update' : 'Add'),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        if (isEditing) {
                          final gymClass = GymClass(
                            id: classToEdit.id,
                            className: classNameController.text,
                            instructor: instructorController.text,
                            startTime: startTimeController.text,
                            endTime: endTimeController.text,
                            duration: int.parse(durationController.text),
                            capacity: int.parse(capacityController.text),
                            bookedSpots: int.parse(bookedSpotsController.text),
                            classType: frontendToBackendType(dropdownClassType),
                            date: selectedDate,
                          );

                          await _classService.updateClass(gymClass);
                          _showSuccessSnackBar('Class updated successfully');
                        } else {
                          // Create new class without ID (let backend generate it)
                          final gymClass = GymClass(
                            id: '', // Empty ID for new class
                            className: classNameController.text,
                            instructor: instructorController.text,
                            startTime: startTimeController.text,
                            endTime: endTimeController.text,
                            duration: int.parse(durationController.text),
                            capacity: int.parse(capacityController.text),
                            bookedSpots: int.parse(bookedSpotsController.text),
                            classType: frontendToBackendType(dropdownClassType),
                            date: selectedDate,
                          );

                          await _classService.createClass(gymClass);
                          _showSuccessSnackBar('Class added successfully');
                        }

                        Navigator.of(context).pop();
                        _loadClasses();
                      } catch (e) {
                        _showErrorSnackBar(
                            'Failed to ${isEditing ? 'update' : 'add'} class: $e');
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: AppBar(
        backgroundColor: appTheme.deepOrange500,
        elevation: 0,
        title: Text(
          "Course Management",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddClassDialog,
        backgroundColor: appTheme.deepOrange500,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildFilterBar(),
        Expanded(
          child: _isLoading
              ? Center(
                  child:
                      CircularProgressIndicator(color: appTheme.deepOrange500))
              : _classes.isEmpty
                  ? _buildEmptyState()
                  : _buildClassList(),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: appTheme.deepOrange500.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'No classes found for the selected date',
            style: TextStyle(
              fontSize: 16,
              color: appTheme.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddClassDialog,
            icon: Icon(Icons.add),
            label: Text('Add a Class'),
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.deepOrange500,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Classes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: appTheme.black900,
            ),
          ),
          SizedBox(height: 16),
          ResponsiveUtils.isSmallScreen(context)
              ? Column(
                  // Stack items vertically on small screens
                  children: [
                    _buildDatePicker(),
                    SizedBox(height: 12),
                    _buildTypeFilter(),
                  ],
                )
              : Row(
                  // Place items side by side on larger screens
                  children: [
                    Expanded(child: _buildDatePicker()),
                    SizedBox(width: 12.0),
                    Expanded(child: _buildTypeFilter()),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now().subtract(Duration(days: 365)),
          lastDate: DateTime.now().add(Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: appTheme.deepOrange500,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null && picked != _selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
          _loadClasses();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: appTheme.gray300),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today,
                size: 18.0, color: appTheme.deepOrange500),
            SizedBox(width: 8.0),
            Flexible(
              // Ensure text can shrink
              child: Text(
                DateFormat('MMM dd, yyyy').format(_selectedDate),
                style: TextStyle(
                  fontSize: 16,
                  color: appTheme.gray600,
                ),
                overflow: TextOverflow.ellipsis, // Handle overflow text
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeFilter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: appTheme.gray300),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedClassType,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: appTheme.deepOrange500),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedClassType = newValue;
              });
              _loadClasses();
            }
          },
          items: _classTypes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                getClassTypeDisplay(value),
                style: TextStyle(
                  color: appTheme.gray600,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis, // Handle overflow text
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildClassList() {
    return ListView.separated(
      padding: EdgeInsets.all(16.0),
      itemCount: _classes.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.0),
      itemBuilder: (context, index) {
        final gymClass = _classes[index];
        return _buildClassCard(gymClass);
      },
    );
  }

  Widget _buildClassCard(GymClass gymClass) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              gymClass.classType == 'Cardio'
                  ? Color(0xFFFFF3E0)
                  : gymClass.classType == 'Strength'
                      ? Color(0xFFE8F5E9)
                      : gymClass.classType == 'Yoga'
                          ? Color(0xFFE3F2FD)
                          : Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getClassTypeColor(gymClass.classType),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                getClassTypeDisplay(
                                    backendToFrontendType(gymClass.classType)),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                gymClass.className,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: appTheme.black900,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.0),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 16, color: appTheme.gray600),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '${gymClass.startTime} - ${gymClass.endTime}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: appTheme.gray600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(Icons.timelapse,
                                size: 16, color: appTheme.gray600),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '${gymClass.duration} min',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: appTheme.gray600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: gymClass.isFull
                              ? Colors.red.shade100
                              : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          gymClass.isFull
                              ? 'Class Full'
                              : '${gymClass.spotsLeft} spots left',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: gymClass.isFull ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundColor: appTheme.deepOrange500.withOpacity(0.2),
                    child: Text(
                      gymClass.instructor.isNotEmpty
                          ? gymClass.instructor[0]
                          : '?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: appTheme.deepOrange500,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Flexible(
                    child: Text(
                      gymClass.instructor,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: appTheme.deepOrange500.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.edit,
                              color: appTheme.deepOrange500, size: 20),
                          onPressed: () => _showEditClassDialog(gymClass),
                          padding: EdgeInsets.all(8),
                          constraints: BoxConstraints(),
                          splashRadius: 24,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red, size: 20),
                          onPressed: () {
                            _showDeleteConfirmationDialog(gymClass);
                          },
                          padding: EdgeInsets.all(8),
                          constraints: BoxConstraints(),
                          splashRadius: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(GymClass gymClass) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Class'),
        content: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black87, fontSize: 16),
            children: [
              TextSpan(text: 'Are you sure you want to delete '),
              TextSpan(
                text: gymClass.className,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: '?'),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);
              _deleteClass(gymClass.id);
            },
          ),
        ],
      ),
    );
  }

  Color _getClassTypeColor(String type) {
    switch (backendToFrontendType(type)) {
      case 'CARDIO':
        return Colors.orange;
      case 'STRENGTH':
        return Colors.green;
      case 'YOGA':
        return Colors.blue;
      default:
        return appTheme.deepOrange500;
    }
  }
}
