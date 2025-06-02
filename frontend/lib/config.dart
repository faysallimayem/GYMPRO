import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConfig {
  // Configuration flag - set to true when using a physical Android device
  static const bool usePhysicalDevice = true;
  
  // The IP address of your development machine on your local network
  static const String localIpAddress = '192.168.1.28';
  
  // Get the appropriate base URL based on platform
  static String get apiUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    
    if (Platform.isAndroid && usePhysicalDevice) {
      return 'http://$localIpAddress:3000';
    }
    
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000'; // Android emulator
    }
    
    if (Platform.isIOS) {
      return 'http://127.0.0.1:3000'; // iOS simulator
    }
    
    // Default fallback for desktop/other platforms
    return 'http://localhost:3000';
  }
}

