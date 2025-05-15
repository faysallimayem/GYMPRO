import 'package:flutter/material.dart';

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
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      currentRouteName = newRoute.settings.name;
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      currentRouteName = previousRoute.settings.name;
    }
  }
}
