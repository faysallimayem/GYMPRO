import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../models/class_model.dart';
import '../services/class_service.dart';
import '../services/auth_service.dart';
import '../widgets/membership_screen_wrapper.dart';

class GymClassesPage extends StatefulWidget {
  const GymClassesPage({super.key});

  @override
  State<GymClassesPage> createState() => _GymClassesPageState();
}

class _GymClassesPageState extends State<GymClassesPage>
    with SingleTickerProviderStateMixin {
  final ClassService _classService = ClassService();
  final AuthService _authService = AuthService();
  late TabController _tabController;

  // State variables
  bool _isLoading = true;
  String? _errorMessage;
  String? _userId;
  DateTime _selectedDate = DateTime.now();
  String _selectedClassType = 'All Classes';
  List<GymClass> _classes = [];
  List<GymClass> _userBookings = [];

  // Class type constants and helpers
  final Map<String, String> _classTypeDisplayMap = {
    'All Classes': 'All Classes',
    'CARDIO': 'Cardio',
    'STRENGTH': 'Strength',
    'YOGA': 'Yoga',
  };

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

  // Get color for class type
  Color _getClassTypeColor(String classType) {
    switch (classType) {
      case 'Cardio':
        return Colors.orange;
      case 'Strength':
        return Colors.green;
      case 'Yoga':
        return Colors.blue;
      default:
        return appTheme.deepOrange500;
    }
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadUserIdAndData();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }
  
  // Handle tab changes to reload data when switching to "My Bookings" tab
  void _handleTabChange() {
    if (_tabController.index == 1) { // My Bookings tab
      print('Switched to My Bookings tab, refreshing data');
      _loadUserBookings();
    }
  }

  // Load user ID and initial data
  Future<void> _loadUserIdAndData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      print('Loading user data...');
      final userData = await _authService.getUserDetails();
      
      if (userData == null) {
        print('User data is null!');
        setState(() {
          _userId = null;
          _isLoading = false;
        });
        return;
      }
      
      final userId = userData['id']?.toString();
      print('Got user ID: $userId');
      
      setState(() {
        _userId = userId;
      });
      
      await _loadClasses();
      
      if (_userId != null) {
        await _loadUserBookings();
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error in _loadUserIdAndData: $e');
      setState(() {
        _errorMessage = 'Failed to load user data: $e';
        _isLoading = false;
      });
    }
  }

  // Load classes with filters
  Future<void> _loadClasses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final classes = await _classService.getClassesByDateAndType(
        _selectedDate,
        _selectedClassType,
      );
      
      setState(() {
        _classes = classes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load classes: $e';
        _isLoading = false;
      });
    }
  }
  // Load user bookings
  Future<void> _loadUserBookings() async {
    if (_userId == null) {
      print('User ID is null, cannot load bookings');
      return;
    }
    
    print('Attempting to load bookings for user: $_userId');
    try {
      final bookings = await _classService.getUserBookings(_userId!);
      print('Successfully loaded ${bookings.length} bookings');
      setState(() {
        _userBookings = bookings;
      });
    } catch (e) {
      print('Error loading user bookings: $e');
      // Don't show error to user, just log it
    }
  }

  // Book a class
  Future<void> _bookClass(GymClass gymClass) async {
    if (_userId == null) {
      _showErrorSnackBar('You need to be logged in to book a class');
      return;
    }

    if (gymClass.isFull) {
      _showErrorSnackBar('This class is full');
      return;
    }    try {
      setState(() => _isLoading = true);
      await _classService.bookClass(gymClass.id, _userId!);
      
      // Refresh data
      await _loadClasses();
      await _loadUserBookings();
      
      _showSuccessSnackBar('Class booked successfully');
    } catch (e) {
      setState(() => _isLoading = false);
      
      // Improved error handling with more specific messages
      if (e.toString().contains('active gym membership')) {
        _showErrorSnackBar('You need an active gym membership to book classes. Please check your membership status.');
      } else if (e.toString().contains('ApiException: 403')) {
        _showErrorSnackBar('You do not have permission to perform this action. Please refresh your membership status or contact support.');
      } else {
        _showErrorSnackBar('Failed to book class: $e');
      }
    }
  }
  // Cancel a booking
  Future<void> _cancelBooking(GymClass gymClass) async {
    if (_userId == null) {
      _showErrorSnackBar('You need to be logged in to cancel a booking');
      return;
    }

    try {
      setState(() => _isLoading = true);
      await _classService.cancelBooking(gymClass.id, _userId!);
      
      // Refresh data
      await _loadClasses();
      await _loadUserBookings();
      
      _showSuccessSnackBar('Booking cancelled successfully');
    } catch (e) {
      setState(() => _isLoading = false);
      
      // Improved error handling with more specific messages
      if (e.toString().contains('active gym membership')) {
        _showErrorSnackBar('You need an active gym membership to manage bookings');
      } else if (e.toString().contains('ApiException: 403')) {
        _showErrorSnackBar('You do not have permission to perform this action. Please refresh your membership status or contact support.');
      } else {
        _showErrorSnackBar('Failed to cancel booking: $e');
      }
    }
  }

  // Show error message
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Show success message
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Building gym classes page. isLoading: $_isLoading, classes count: ${_classes.length}');
    
    return MembershipScreenWrapper(
      featureName: 'Gym Classes',
      showBlurredPreview: true,
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        body: SafeArea(
          child: Container(
            width: double.maxFinite,
            decoration: AppDecoration.outlineOnPrimaryContainer,
            child: Column(
              children: [
                _buildHeader(context),
                if (_isLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_errorMessage != null)
                  Expanded(child: _buildErrorState())
                else
                  Expanded(child: _buildContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build header with back button and title
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.h),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                "Gym Classes",
                style: CustomTextStyles.headlineSmallPoppins,
              ),
            ),
          ),
          SizedBox(width: 48), // To balance the Row layout visually
        ],
      ),
    );
  }

  // Build tab bar
  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      decoration: BoxDecoration(
        color: appTheme.gray100,
        borderRadius: BorderRadius.circular(16.h),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,      indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(16.h),
          color: appTheme.deepOrange500,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: appTheme.gray600,
        tabs: [
          Tab(text: "All Classes"),
          Tab(text: "My Bookings"),
        ],
      ),
    );
  }

  // Build classes tab
  Widget _buildClassesTab() {
    return Column(
      children: [
        _buildClassFilters(),
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errorMessage != null
                  ? Center(child: Text(_errorMessage!))
                  : _classes.isEmpty
                      ? Center(child: Text("No classes found"))
                      : _buildClassesList(_classes),
        ),
      ],
    );
  }
  // Build my bookings tab
  Widget _buildMyBookingsTab() {
    print('Building my bookings tab. isLoading: $_isLoading, bookings count: ${_userBookings.length}');
    
    if (_userId == null) {
      return Center(child: Text("Please log in to view your bookings"));
    }
    
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage != null) {
      return Center(child: Text("Error: $_errorMessage"));
    }
    
    if (_userBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You have no bookings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _loadUserBookings();
              },
              child: Text("Refresh"),
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.deepOrange500,
              ),
            ),
          ],
        ),
      );
    }
    
    return _buildClassesList(_userBookings);
  }

  // Build class filters
  Widget _buildClassFilters() {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: Column(
        children: [
          // Date picker
          Row(
            children: [
              Icon(Icons.calendar_today, color: appTheme.gray600),
              SizedBox(width: 8.h),
              Text(
                "Date:",
                style: TextStyle(
                  fontSize: 16.h,
                  fontWeight: FontWeight.w500,
                  color: appTheme.gray600,
                ),
              ),
              SizedBox(width: 8.h),
              TextButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now().subtract(Duration(days: 7)),
                    lastDate: DateTime.now().add(Duration(days: 30)),
                  );
                  if (pickedDate != null && pickedDate != _selectedDate) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                    _loadClasses();
                  }
                },
                child: Text(
                  DateFormat('MMM dd, yyyy').format(_selectedDate),
                  style: TextStyle(
                    color: appTheme.deepOrange500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Class type filter
          Row(
            children: [
              Icon(Icons.fitness_center, color: appTheme.gray600),
              SizedBox(width: 8.h),
              Text(
                "Type:",
                style: TextStyle(
                  fontSize: 16.h,
                  fontWeight: FontWeight.w500,
                  color: appTheme.gray600,
                ),
              ),
              SizedBox(width: 8.h),
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedClassType,
                  isExpanded: true,
                  underline: Container(
                    height: 1,
                    color: appTheme.gray300,
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null && newValue != _selectedClassType) {
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
                          fontSize: 16.h,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build classes list
  Widget _buildClassesList(List<GymClass> classes) {
    return RefreshIndicator(
      onRefresh: () async {
        await _loadClasses();
        await _loadUserBookings();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16.h),
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final gymClass = classes[index];
          return _buildClassCard(gymClass);
        },
      ),
    );
  }

  // Build class card
  Widget _buildClassCard(GymClass gymClass) {
    // Check if this class is in the user's bookings
    final bool isBooked = gymClass.isUserBooked;

    return Card(
      elevation: 3.0,
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.h),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.h),
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
          padding: EdgeInsets.all(16.h),
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
                                horizontal: 8.h,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getClassTypeColor(gymClass.classType),
                                borderRadius: BorderRadius.circular(8.h),
                              ),
                              child: Text(
                                getClassTypeDisplay(
                                  backendToFrontendType(gymClass.classType),
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.h,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.h),
                            Flexible(
                              child: Text(
                                gymClass.className,
                                style: TextStyle(
                                  fontSize: 18.h,
                                  fontWeight: FontWeight.bold,
                                  color: appTheme.black900,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16.h,
                              color: appTheme.gray600,
                            ),
                            SizedBox(width: 4.h),
                            Flexible(
                              child: Text(
                                '${gymClass.startTime} - ${gymClass.endTime}',
                                style: TextStyle(
                                  fontSize: 14.h,
                                  color: appTheme.gray600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 12.h),
                            Icon(
                              Icons.timelapse,
                              size: 16.h,
                              color: appTheme.gray600,
                            ),
                            SizedBox(width: 4.h),
                            Flexible(
                              child: Text(
                                '${gymClass.duration} min',
                                style: TextStyle(
                                  fontSize: 14.h,
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.h,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: gymClass.isFull
                              ? Colors.red.shade100
                              : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8.h),
                        ),
                        child: Text(
                          gymClass.isFull
                              ? 'Class Full'
                              : '${gymClass.spotsLeft} spots left',
                          style: TextStyle(
                            fontSize: 12.h,
                            fontWeight: FontWeight.bold,
                            color: gymClass.isFull ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        DateFormat('MMM dd, yyyy').format(gymClass.date),
                        style: TextStyle(
                          fontSize: 12.h,
                          color: appTheme.gray600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.h,
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
                  SizedBox(width: 8.h),
                  Flexible(
                    child: Text(
                      gymClass.instructor,
                      style: TextStyle(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBooked
                          ? Colors.red
                          : gymClass.isFull
                              ? Colors.grey
                              : appTheme.deepOrange500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                    ),
                    onPressed: gymClass.isFull && !isBooked
                        ? null
                        : () {
                            if (isBooked) {
                              _cancelBooking(gymClass);
                            } else {
                              _bookClass(gymClass);
                            }
                          },
                    child: Text(
                      isBooked ? 'Cancel' : 'Book Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(child: Text("Error: $_errorMessage"));
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildTabBar(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildClassesTab(),
              _buildMyBookingsTab(),
            ],
          ),
        ),
      ],
    );
  }
}
