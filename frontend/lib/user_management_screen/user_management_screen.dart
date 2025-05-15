import 'dart:async';
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../routes/app_routes.dart';
import '../edit_user_screen/edit_user_screen.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final UserService _userService = UserService();
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
  }

  Future<void> _loadUsers({bool refresh = false}) async {
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
      final response = await _userService.getPaginatedUsers(
        page: _page,
        limit: _limit,
        searchQuery: _searchQuery,
      );
      setState(() {
        _users = response.items;
        _filteredUsers = response.items;
        _hasMore = _page < response.totalPages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading users: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreUsers() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final response = await _userService.getPaginatedUsers(
        page: _page + 1,
        limit: _limit,
        searchQuery: _searchQuery,
      );

      setState(() {
        _page++;
        _users.addAll(response.items);
        _filteredUsers = _users;
        _hasMore = _page < response.totalPages;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading more users: ${e.toString()}';
        _isLoadingMore = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: _isLoading && _users.isEmpty
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => _loadUsers(refresh: true),
                child: Column(
                  children: [
                    _buildHeader(context),
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

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Container(
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
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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

                    // Refresh the list if user was updated
                    if (result == true) {
                      _loadUsers(refresh: true); // Reload users after edit
                    }
                  },
                ),
                SizedBox(width: 8),
                OutlinedButton.icon(
                  icon: Icon(Icons.delete, color: Colors.red),
                  label: Text('Delete', style: TextStyle(color: Colors.red)),
                  onPressed: () => _deleteUser(user),
                ),
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
}
