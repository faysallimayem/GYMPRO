import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';
import 'app_utils.dart';
import 'routes/app_routes.dart' as route;
import 'services/auth_service.dart';
import 'services/registration_provider.dart';
import 'services/workout_service.dart';
import 'services/user_provider.dart';
import 'reset_password_screen/reset_password_screen.dart';
import 'routes/route_observer.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
bool _initialURILinkHandled = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MyApp(),
  );
}

// Class is public, so change _MyAppState to public MyAppState
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription? _linkSubscription;
  final AppRouteObserver _routeObserver = AppRouteObserver();

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _initURIHandler();
    _incomingLinkHandler();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  /// Handle the initial URI - for app opened from external link
  Future<void> _initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        final initialURI = await _appLinks.getInitialLink();
        if (initialURI != null) {
          debugPrint('Initial URI received: $initialURI');
          _handleURI(initialURI);
        }
      } catch (e) {
        debugPrint('Error handling initial URI: $e');
      }
    }
  }

  /// Handle incoming links while the app is already running
  void _incomingLinkHandler() {
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri uri) {
      debugPrint('URI received while app running: $uri');
      _handleURI(uri);
    }, onError: (err) {
      debugPrint('Error in link stream: $err');
    });
  }

  /// Process the URI and navigate accordingly
  void _handleURI(Uri uri) {
    final pathSegments = uri.pathSegments;

    // Handle password reset links
    if (pathSegments.isNotEmpty && pathSegments.first == 'reset-password') {
      // Delayed to ensure navigation works properly after app init
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(
          context,
          route.AppRoutes.resetPasswordScreen,
          arguments: {'token': uri.queryParameters['token']},
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()..initialize()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutService()..initFavorites()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            title: 'GYM PRO',
            debugShowCheckedModeBanner: false,
            // Use stored route or fallback to initial route
            initialRoute: _routeObserver.currentRouteName ?? route.AppRoutes.getStartedScreen,
            routes: route.AppRoutes.routes,
            // Register the route observer
            navigatorObservers: [_routeObserver],
            onGenerateRoute: (settings) {
              // Handle reset password screen with token parameter
              if (settings.name == route.AppRoutes.resetPasswordScreen) {
                final args = settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                  builder: (context) => ResetPasswordScreen(
                    token: args?['token'],
                  ),
                );
              }
              return null;
            },
            navigatorKey: GlobalKey<NavigatorState>(),
            scaffoldMessengerKey: globalMessengerKey,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(1.0),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
