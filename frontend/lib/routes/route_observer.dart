import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/navigation_provider.dart';

/// A global route observer that tracks navigation state
class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  static final AppRouteObserver _instance = AppRouteObserver._internal();

  factory AppRouteObserver() => _instance;

  AppRouteObserver._internal();

  /// Current route name
  String? currentRouteName;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      currentRouteName = route.settings.name;
      _updateNavigationProvider(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      currentRouteName = newRoute.settings.name;
      _updateNavigationProvider(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      currentRouteName = previousRoute.settings.name;
      _updateNavigationProvider(previousRoute);
    }
  }

  /// Updates the NavigationProvider with the current route
  void _updateNavigationProvider(PageRoute<dynamic> route) {
    if (route.settings.name == null) return;
    
    // Use a delayed callback to ensure the context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        // Only update if we have a valid route
        if (route.navigator?.context != null) {
          final navProvider = Provider.of<NavigationProvider>(
            route.navigator!.context,
            listen: false,
          );
          navProvider.setCurrentRoute(route.settings.name!);
        }
      } catch (e) {
        print('Error updating NavigationProvider: $e');
      }
    });
  }
}
