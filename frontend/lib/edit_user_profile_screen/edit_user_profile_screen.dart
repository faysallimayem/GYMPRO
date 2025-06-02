import 'package:flutter/material.dart';
// Import dart:io only for non-web platforms
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../services/user_provider.dart';
import '../services/file_service_helper.dart';
import '../config.dart';
import '../services/auth_service.dart';

// Handle mobile imports explicitly
import 'dart:io' as io show File;

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;  String? _selectedGender;
  XFile? _imageFile;
  String? _imageUrl;
  bool _isLoading = false;
  String? _errorMessage;

  final List<String> _genderOptions = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    
    // Get more detailed user data from authService
    Map<String, dynamic>? userData = authService.userData;
    
    // Initialize controllers with existing user data
    _firstNameController = TextEditingController(text: userProvider.firstName ?? userData?['firstName'] ?? '');
    _lastNameController = TextEditingController(text: userProvider.lastName ?? userData?['lastName'] ?? '');
    _emailController = TextEditingController(text: userProvider.email);
    _ageController = TextEditingController(text: (userProvider.age ?? userData?['age'] ?? '').toString());
    _heightController = TextEditingController(text: (userProvider.height ?? userData?['height'] ?? '').toString());
    _weightController = TextEditingController(text: (userProvider.weight ?? userData?['weight'] ?? '').toString());
    _selectedGender = userProvider.gender ?? userData?['gender'] ?? 'Male';
    _imageUrl = userProvider.photoUrl;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error picking image: $e';
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      String? photoUrl = _imageUrl;

      // Upload image if a new one was selected
      if (_imageFile != null) {
        try {
          // Use the same XFile object for both platforms
          photoUrl = await FileServiceHelper.uploadImage(_imageFile);
        } catch (e) {
          setState(() {
            _errorMessage = 'Error uploading image: $e';
          });
        }
      }

      // Create a map with all user data
      Map<String, dynamic> userData = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
        'height': double.tryParse(_heightController.text) ?? 0,
        'weight': double.tryParse(_weightController.text) ?? 0,
        'gender': _selectedGender,
      };
      
      // Only include photoUrl if we have one to update
      if (photoUrl != null) {
        userData['photoUrl'] = photoUrl;
      }

      // Update user data in the backend via AuthService
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.updateProfile(userData);
      
      // Update user data in the provider
      await userProvider.updateUserData(
        username: "${_firstNameController.text} ${_lastNameController.text}",
        email: _emailController.text,
        photoUrl: photoUrl,
        age: int.tryParse(_ageController.text),
        height: double.tryParse(_heightController.text),
        weight: double.tryParse(_weightController.text),
        gender: _selectedGender,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
      );

      // Sync UserProvider with AuthService to ensure data consistency
      await userProvider.syncWithAuthService();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context); // Go back after successful update
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error updating profile: $e';
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
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                
                // Profile Image
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _getProfileImage(),
                        child: _getProfileImage() == null 
                            ? Icon(Icons.person, size: 70, color: Colors.grey)
                            : null,
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: appTheme.deepOrange500,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Error Message
                if (_errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                
                // First Name Field
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: Icon(Icons.person, color: appTheme.deepOrange500),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: appTheme.deepOrange500, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 16),
                
                // Last Name Field
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    prefixIcon: Icon(Icons.person_outline, color: appTheme.deepOrange500),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: appTheme.deepOrange500, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 16),
                
                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: appTheme.deepOrange500),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: appTheme.deepOrange500, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 16),
                
                // Age Field
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    prefixIcon: Icon(Icons.cake, color: appTheme.deepOrange500),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: appTheme.deepOrange500, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age <= 0 || age > 120) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 16),
                
                // Height Field
                TextFormField(
                  controller: _heightController,
                  decoration: InputDecoration(
                    labelText: 'Height (cm)',
                    prefixIcon: Icon(Icons.height, color: appTheme.deepOrange500),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: appTheme.deepOrange500, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    final height = double.tryParse(value);
                    if (height == null || height <= 0 || height > 300) {
                      return 'Please enter a valid height';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 16),
                
                // Weight Field
                TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                    prefixIcon: Icon(Icons.fitness_center, color: appTheme.deepOrange500),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: appTheme.deepOrange500, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    final weight = double.tryParse(value);
                    if (weight == null || weight <= 0 || weight > 500) {
                      return 'Please enter a valid weight';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 16),
                
                // Gender Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.person_2, color: appTheme.deepOrange500),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: appTheme.deepOrange500, width: 2),
                    ),
                  ),
                  items: _genderOptions.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 32),
                
                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.deepOrange500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ImageProvider? _getProfileImage() {
    if (_imageFile != null) {
      if (kIsWeb) {
        // For web platform, always use NetworkImage
        return NetworkImage(_imageFile!.path);
      } else {
        // For mobile platforms
        try {
          // Use the explicit import from io library
          return FileImage(io.File(_imageFile!.path));
        } catch (e) {
          print('Error creating FileImage: $e');
          // Fallback to network image if file access fails
          return NetworkImage(_imageFile!.path);
        }
      }
    } else if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      // Handle existing image URLs
      final fullUrl = _imageUrl!.startsWith('http') 
          ? _imageUrl! 
          : '${AppConfig.apiUrl}${_imageUrl!.startsWith('/') ? '' : '/'}$_imageUrl';
      return NetworkImage(fullUrl);
    }
    return null;
  }
} 