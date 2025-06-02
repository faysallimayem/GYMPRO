import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../services/gym_service.dart';
import '../services/user_provider.dart';
import 'package:provider/provider.dart';

class EditUserScreen extends StatefulWidget {
  final User user;

  const EditUserScreen({super.key, required this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();  final UserService _userService = UserService();
  final GymService _gymService = GymService();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController ageController;

  late String selectedGender;
  late String selectedRole;

  bool _isLoading = false;
  String? _errorMessage;

  List<String> genderOptions = ['Male', 'Female'];
  List<String> roleOptions = ['client', 'coach', 'admin'];
  @override
  void initState() {
    super.initState();
    // Initialize controllers with user data
    firstNameController = TextEditingController(text: widget.user.firstName);
    lastNameController = TextEditingController(text: widget.user.lastName);
    emailController = TextEditingController(text: widget.user.email);
    ageController =
        TextEditingController(text: widget.user.age?.toString() ?? '');

    // Initialize dropdown values with validation
    // Make sure gender is one of the valid options, otherwise default to the first option
    selectedGender = genderOptions.contains(widget.user.gender) ? widget.user.gender : genderOptions.first;
    
    // Make sure role is one of the valid options, otherwise default to 'client'
    selectedRole = roleOptions.contains(widget.user.role) ? widget.user.role : 'client';
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    ageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Create user data object with all fields
      final userData = {
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'gender': selectedGender,
      };

      // Add age if provided
      if (ageController.text.isNotEmpty) {
        userData['age'] = int.parse(ageController.text.trim()).toString();
      }

      // Update user details
      await _userService.updateUserDetails(widget.user.id, userData);
      print('User details updated for userId: \\${widget.user.id}');
      // Update role if changed
      if (selectedRole != widget.user.role) {
        print('Role change detected: \\${widget.user.role} -> \\${selectedRole}');
        await _userService.updateUserRole(widget.user.id, selectedRole);
        print('User role updated for userId: \\${widget.user.id} to \\${selectedRole}');
        // Assign to gym as coach if role is now coach
        if (selectedRole == 'coach') {
          final adminData = await _userService.getCurrentUser();
          if (adminData != null && adminData['managedGym'] != null && adminData['managedGym']['id'] != null) {
            final gymId = adminData['managedGym']['id'];            try {
              print('Assigning userId \\${widget.user.id} as coach to gymId: \\${gymId}');
              await _gymService.assignCoachToGym(gymId, widget.user.id);
              print('Assigned coach \\${widget.user.id} to gym \\${gymId}');
            } catch (e) {
              print('Failed to assign coach: \\${e}');
              // Don't show an error to the user here since the role change is successful
              // even if the coach assignment has issues
            }
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('User updated successfully')));
        // Pass back a result to indicate the user was updated
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error updating user: \\${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(context),
                SizedBox(height: 24),
                if (_errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ),
                _buildFormField(
                  label: 'First Name',
                  controller: firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                _buildFormField(
                  label: 'Last Name',
                  controller: lastNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                _buildFormField(
                  label: 'Email',
                  controller: emailController,
                  enabled: false, // Can't change email
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                _buildFormField(
                  label: 'Age',
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final age = int.tryParse(value);
                      if (age == null) {
                        return 'Please enter a valid number';
                      }
                      if (age < 12 || age > 100) {
                        return 'Age must be between 12 and 100';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: appTheme.gray300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedGender,
                      items: genderOptions.map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGender = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Role',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: appTheme.gray300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedRole,
                      items: roleOptions.map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role.capitalize()),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRole = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Center(
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            minimumSize: Size(200, 50),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _submitForm,
                          child: Text(
                            "Update User",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Edit User",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "Edit User",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          enabled: enabled,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: appTheme.gray300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: appTheme.gray300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: appTheme.gray300.withOpacity(0.5)),
            ),
          ),
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
