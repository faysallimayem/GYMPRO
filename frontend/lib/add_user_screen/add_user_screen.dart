import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../responsive_utils.dart';
import '../widgets.dart';
import '../services/user_service.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String selectedGender = 'Male';
  String selectedRole = 'client';

  bool _isLoading = false;
  String? _errorMessage;
  List<String> genderOptions = ['Male', 'Female'];
  List<String> roleOptions = ['client', 'coach', 'admin'];

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
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
      final userData = {
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'age': int.parse(ageController.text.trim()),
        'gender': selectedGender,
        'role': selectedRole,
      };

      await _userService.createUser(userData);

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('User created successfully')));
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error creating user: ${e.toString()}';
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
          padding: EdgeInsets.all(context.widthRatio(0.04)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(context),
                SizedBox(height: context.heightRatio(0.03)),
                if (_errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(context.widthRatio(0.03)),
                    margin: EdgeInsets.only(bottom: context.heightRatio(0.02)),
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
                  context: context,
                  label: 'First Name',
                  controller: firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.heightRatio(0.02)),
                _buildFormField(
                  context: context,
                  label: 'Last Name',
                  controller: lastNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.heightRatio(0.02)),
                _buildFormField(
                  context: context,
                  label: 'Email',
                  controller: emailController,
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
                SizedBox(height: context.heightRatio(0.02)),
                _buildFormField(
                  context: context,
                  label: 'Password',
                  controller: passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.heightRatio(0.02)),
                _buildFormField(
                  context: context,
                  label: 'Age',
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter age';
                    }
                    final age = int.tryParse(value);
                    if (age == null) {
                      return 'Please enter a valid number';
                    }
                    if (age < 12 || age > 100) {
                      return 'Age must be between 12 and 100';
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.heightRatio(0.02)),
                Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.responsiveFontSize(context, 16),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: context.heightRatio(0.01)),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.widthRatio(0.03)),
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
                SizedBox(height: context.heightRatio(0.02)),
                Text(
                  'Role',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.responsiveFontSize(context, 16),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: context.heightRatio(0.01)),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.widthRatio(0.03)),
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
                SizedBox(height: context.heightRatio(0.04)),
                Center(
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : CustomElevatedButton(
                          height: context.heightRatio(0.06),
                          width: context.widthRatio(0.5),
                          text: "Create User",
                          buttonStyle: CustomButtonStyles.fillPrimaryTL16,
                          buttonTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize:
                                ResponsiveUtils.responsiveFontSize(context, 16),
                            fontWeight: FontWeight.bold,
                          ),
                          onPressed: _submitForm,
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
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back, color: Colors.black),
      ),
      title: Text(
        "Add New User",
        style: TextStyle(
          fontSize: ResponsiveUtils.responsiveFontSize(context, 20),
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: context.heightRatio(0.02),
          horizontal: context.widthRatio(0.05),
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "Add New User",
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveFontSize(context, 22),
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveFontSize(context, 16),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: context.heightRatio(0.01)),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.widthRatio(0.04),
              vertical: context.heightRatio(0.015),
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
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red),
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
