import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../services/user_provider.dart';
import '../routes/app_routes.dart';
import '../edit_user_screen/edit_user_screen.dart';
import '../services/gym_service.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final UserService _userService = UserService();
  final GymService _gymService = GymService();
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _errorMessage;
  // Pagination variables
  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;
  String? _searchQuery;

  final ScrollController _scrollController = ScrollController();

  // Variables for debounced search
  static const _searchDelay = Duration(milliseconds: 500);
  @override
  void initState() {
    super.initState();
    _loadUsers();

    // Add scroll listener for pagination
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    searchController.dispose();
    searchFocusNode.dispose();

    // Cancel any pending debounce timer
    _searchDebounceTimer?.cancel();

    super.dispose();
  }

  // Scroll listener for pagination
  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        !_isLoading &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMoreUsers();
    }
  }  Future<void> _loadUsers({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _page = 1;
        _isLoading = true;
        _errorMessage = null;
        _users = [];
        _filteredUsers = [];
        _hasMore = true;
      });
    } else {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      // Get the admin's gym ID from UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final adminGymId = userProvider.gymId;
      
      final response = await _userService.getPaginatedUsers(
        page: _page,
        limit: _limit,
        searchQuery: _searchQuery,
        gymId: adminGymId,
        onlyGymMembers: true,
      );
      
      if (mounted) {
        setState(() {
          _users = response.items;
          _filteredUsers = response.items;
          _hasMore = _page < response.totalPages;
          _isLoading = false;
          _errorMessage = null; // Clear any previous errors
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading users: ${e.toString()}';
          _isLoading = false;
          // Provide empty lists to ensure UI can still render
          if (_users.isEmpty) {
            _users = [];
            _filteredUsers = [];
          }
        });
      }
    }
  }  Future<void> _loadMoreUsers() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
      _errorMessage = null;
    });

    try {
      // Get the admin's gym ID from UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final adminGymId = userProvider.gymId;
      
      final response = await _userService.getPaginatedUsers(
        page: _page + 1,
        limit: _limit,
        searchQuery: _searchQuery,
        gymId: adminGymId,
        onlyGymMembers: true,
      );if (mounted) {
        setState(() {
          _page++;
          _users.addAll(response.items);
          _filteredUsers = _users;
          _hasMore = _page < response.totalPages;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading more users: ${e.toString()}';
          _isLoadingMore = false;
        });
      }
    }
  } // Timer for debouncing search

  Timer? _searchDebounceTimer;

  void _filterUsers(String query) {
    // First do a local filter for immediate feedback
    setState(() {
      if (query.isEmpty) {
        // If query is empty, show all loaded users
        _filteredUsers = _users;
        _searchQuery = null;
      } else {
        // Filter users locally based on query
        _filteredUsers = _users.where((user) {
          final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
          final email = user.email.toLowerCase();
          final searchLower = query.toLowerCase();

          return fullName.contains(searchLower) || email.contains(searchLower);
        }).toList();
        _searchQuery = query;
      }
    });

    // Cancel any previous timer
    _searchDebounceTimer?.cancel();

    // Start a new timer for server-side search
    _searchDebounceTimer = Timer(_searchDelay, () {
      // Only do server-side search if query is non-empty and
      // - either we have no results or
      // - we have very few results and the query is meaningful
      if (query.isNotEmpty &&
          (_filteredUsers.isEmpty ||
              (_filteredUsers.length < 3 && query.length > 2))) {
        setState(() {
          _searchQuery = query;
          _page = 1; // Reset to first page
        });
        _loadUsers(refresh: true);
      }
    });
  }

  Future<void> _deleteUser(User user) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Delete'),
            content: Text(
                'Are you sure you want to delete ${user.firstName} ${user.lastName}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    // Show loading indicator
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous errors
    });

    try {
      // Show an immediately visible snackbar that the deletion is in progress
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white)),
              SizedBox(width: 16),
              Text('Deleting user...'),
            ],
          ),
          duration: Duration(seconds: 1),
        ),
      );

      // Attempt to delete the user
      await _userService.deleteUser(user.id);

      // Update state only if the widget is still mounted
      if (mounted) {
        setState(() {
          _users.removeWhere((u) => u.id == user.id);
          _filteredUsers.removeWhere((u) => u.id == user.id);
          _isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User deleted successfully'),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      // Only update state if the widget is still mounted
      if (mounted) {
        setState(() {
          _errorMessage = 'Error deleting user: ${e.toString()}';
          _isLoading = false;
        });

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to delete user. Please try again later.'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'RETRY',
            textColor: Colors.white,
            onPressed: () => _deleteUser(user),
          ),
        ));
      }
    }
  }

  @override  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final adminGymId = userProvider.gymId;
    
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: adminGymId == null 
            ? _buildNoGymAssignedMessage(context)
            : _isLoading && _users.isEmpty
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                onRefresh: () => _loadUsers(refresh: true),
                child: Column(
                  children: [
                    _buildHeader(context, userProvider),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              focusNode: searchFocusNode,
                              decoration: InputDecoration(
                                hintText: "Search by name or email",
                                prefixIcon: Icon(Icons.search),
                                suffixIcon: searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          // Clear search text and reset results
                                          searchController.clear();
                                          _filterUsers('');
                                          searchFocusNode
                                              .requestFocus(); // Maintain focus
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 12),
                              ),
                              onChanged: _filterUsers,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () {
                              // Refresh the user list
                              _loadUsers(refresh: true);
                              FocusScope.of(context).unfocus(); // Hide keyboard
                            },
                            tooltip: 'Refresh users',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    if (_errorMessage != null)
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ),
                      ),
                    Expanded(
                      child: _filteredUsers.isEmpty
                          ? Center(child: Text('No users found'))
                          : _buildUsersList(),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.addUserScreen);
          _loadUsers(
              refresh: true); // Reload users after returning from add screen
        },
        icon: Icon(Icons.add),
        label: Text('Add User'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "User Management",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 1,
    );
  }

  Widget _buildHeader(BuildContext context, UserProvider userProvider) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "User Management",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            if (userProvider.gymName != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Managing: ${userProvider.gymName}',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList() {
    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.all(16),
      itemCount: _filteredUsers.length + (_hasMore ? 1 : 0),
      separatorBuilder: (_, __) => Divider(),
      itemBuilder: (context, index) {
        if (index >= _filteredUsers.length) {
          return _buildLoadingMoreIndicator();
        }
        final user = _filteredUsers[index];
        return _buildUserListItem(user);
      },
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      child: _isLoadingMore
          ? CircularProgressIndicator()
          : TextButton(
              onPressed: _loadMoreUsers,
              child: Text('Load More'),
            ),
    );
  }

  Widget _buildUserListItem(User user) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: appTheme.gray300),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  radius: 24,
                  child: Text(
                    user.firstName.isNotEmpty
                        ? user.firstName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getRoleColor(user.role),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          user.role.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),            SizedBox(height: 8),
            // Membership status indicator
            Row(
              children: [
                Icon(
                  user.isGymMember ? Icons.verified_user : Icons.no_accounts,
                  color: user.isGymMember ? Colors.green : Colors.red,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  user.isGymMember 
                    ? "Active Member": "Not a Gym Member", 
                  style: TextStyle(
                    color: user.isGymMember ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  icon: Icon(Icons.fitness_center, color: Colors.orange),
                  label: Text(
                    user.isGymMember ? 'Manage Membership' : 'Activate Membership',
                    style: TextStyle(color: Colors.orange),
                  ),
                  onPressed: () => _manageMembership(user),
                ),
                SizedBox(width: 8),
                OutlinedButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text('Edit'),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditUserScreen(user: user),
                      ),
                    );
                    if (result == true) {
                      _loadUsers(refresh: true);
                    }
                  },
                ),
                SizedBox(width: 8),
                OutlinedButton.icon(
                  icon: Icon(Icons.delete, color: Colors.red),
                  label: Text('Delete', style: TextStyle(color: Colors.red)),
                  onPressed: () => _deleteUser(user),
                ),
                // --- Coach assignment/removal buttons ---
                if (user.role != 'admin') ...[
                  SizedBox(width: 8),
                  user.role != 'coach'
                      ? ElevatedButton.icon(
                          icon: Icon(Icons.person_add, color: Colors.white),
                          label: Text('Assign as Coach'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () async {
                            setState(() => _isLoading = true);
                            try {
                              // Get admin's managed gym
                              final adminData = await _userService.getCurrentUser();
                              print('Admin data for coach assignment: ' + adminData.toString());
                              int? gymId;
                              if (adminData != null) {
                                // Try managedGym.id (object)
                                if (adminData['managedGym'] != null && adminData['managedGym'] is Map && adminData['managedGym']['id'] != null) {
                                  final val = adminData['managedGym']['id'];
                                  if (val is int) {
                                    gymId = val;
                                  } else if (val is String) {
                                    gymId = int.tryParse(val);
                                  }
                                }
                                // Try managedGymId (flat field)
                                if (gymId == null && adminData['managedGymId'] != null) {
                                  final val = adminData['managedGymId'];
                                  if (val is int) {
                                    gymId = val;
                                  } else if (val is String) {
                                    gymId = int.tryParse(val);
                                  }
                                }
                              }
                              if (gymId == null) throw Exception('No managed gym found for admin.');
                              // Assign coach to gym
                              await _gymService.assignCoachToGym(gymId, user.id);
                              // Update user role to coach
                              await _userService.updateUserRole(user.id, 'coach');
                              // Set premium membership (activate if not already)
                              if (!user.isGymMember) {
                                await _userService.updateGymMembership(user.id, true, DateTime.now().add(Duration(days: 365)));
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('User assigned as coach and given premium membership.')),
                              );
                              _loadUsers(refresh: true);                            } catch (e) {
                              String errorMsg = e.toString();
                              if (errorMsg.contains('already_assigned')) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('This user is already assigned as a coach to this gym.'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              } else {
                                // More user-friendly message that suggests refreshing the page
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Coach may have been assigned successfully. Please refresh the page to see the changes.'),
                                    backgroundColor: Colors.blue,
                                    action: SnackBarAction(
                                      label: 'Refresh Now',
                                      onPressed: () => _loadUsers(refresh: true),
                                    ),
                                  ),
                                );
                              }
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          },
                        )
                      : ElevatedButton.icon(
                          icon: Icon(Icons.person_remove, color: Colors.white),
                          label: Text('Remove as Coach'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: () async {
                            setState(() => _isLoading = true);
                            try {
                              final adminData = await _userService.getCurrentUser();
                              final gymId = adminData != null && adminData['managedGym'] != null && adminData['managedGym']['id'] != null
                                  ? adminData['managedGym']['id']
                                  : null;
                              if (gymId == null) throw Exception('No managed gym found for admin.');
                              // Remove coach from gym
                              await _gymService.removeCoachFromGym(gymId, user.id);
                              // Optionally, downgrade role to client
                              await _userService.updateUserRole(user.id, 'client');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Coach removed from gym.')),
                              );
                              _loadUsers(refresh: true);                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Coach may have been removed successfully. Please refresh the page to see the changes.'),
                                  backgroundColor: Colors.blue,
                                  action: SnackBarAction(
                                    label: 'Refresh Now',
                                    onPressed: () => _loadUsers(refresh: true),
                                  ),
                                ),
                              );
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          },
                        ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'coach':
        return Colors.blue;
      case 'client':
      default:
        return Colors.green;
    }
  }
  
  // Format date to a readable string
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  // Manage gym membership
  void _manageMembership(User user) {
    final isActivating = !user.isGymMember;
    final TextEditingController daysController = TextEditingController(
      text: user.isGymMember && user.membershipExpiresAt != null 
          ? _remainingDays(user.membershipExpiresAt!).toString() 
          : '30'
    );
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isActivating ? 'Activate Membership' : 'Update Membership'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isActivating
                    ? 'Set membership duration for ${user.firstName} ${user.lastName}:'
                    : 'Update membership for ${user.firstName} ${user.lastName}:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              TextField(
                controller: daysController,
                decoration: InputDecoration(
                  labelText: 'Duration (days)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              if (user.isGymMember && user.membershipExpiresAt != null)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Current expiry date: ${_formatDate(user.membershipExpiresAt!)}',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            if (user.isGymMember)
              TextButton(
                onPressed: () async {
                  // Deactivate membership
                  await _updateMembership(user.id, false, null);
                  Navigator.of(context).pop();
                },
                child: Text('Deactivate', style: TextStyle(color: Colors.red)),
              ),
            ElevatedButton(
              onPressed: () async {
                // Validate input
                int? days = int.tryParse(daysController.text);
                if (days == null || days <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid number of days')),
                  );
                  return;
                }
                
                // Calculate expiry date
                final expiryDate = DateTime.now().add(Duration(days: days));
                
                // Update membership
                await _updateMembership(user.id, true, expiryDate);
                Navigator.of(context).pop();
              },
              child: Text(isActivating ? 'Activate' : 'Update'),
            ),
          ],
        );
      },
    );
  }
  
  // Helper to calculate remaining days
  int _remainingDays(DateTime expiryDate) {
    final now = DateTime.now();
    return expiryDate.difference(now).inDays;
  }
  
  // Update membership in the database
  Future<void> _updateMembership(int userId, bool isActive, DateTime? expiryDate) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      await _userService.updateGymMembership(userId, isActive, expiryDate);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isActive 
              ? 'Membership activated successfully!' 
              : 'Membership deactivated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Refresh user list
      _loadUsers(refresh: true);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating membership: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Message shown when admin doesn't have a gym assigned
  Widget _buildNoGymAssignedMessage(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center_outlined,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              "No Gym Assigned",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              "You need to be assigned to a gym as an admin to manage users. Please contact the system administrator.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
