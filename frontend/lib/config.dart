import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConfig {
  // Get the appropriate base URL based on platform
  static String get apiUrl {
    if (kIsWeb) {
      // For web, use relative URL
      return '';
    } else if (Platform.isAndroid) {
      // For Android emulator, 10.0.2.2 points to the host machine's localhost
      return 'http://10.0.2.2:3000';
    } else if (Platform.isIOS) {
      // For iOS simulator, localhost works but should use this
      return 'http://127.0.0.1:3000';
    } else {
      // For desktop or other platforms
      return 'http://localhost:3000';
    }
  }
}