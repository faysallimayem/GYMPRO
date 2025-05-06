import 'package:flutter/material.dart';
import 'app_utils.dart';

/// ResponsiveUtils - A comprehensive utility class for responsive design across all devices
class ResponsiveUtils {
  /// Screen size breakpoints
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1200;
  
  /// Check device type based on width
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileMaxWidth) {
      return DeviceType.mobile;
    } else if (width < tabletMaxWidth) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }
  
  /// Get a responsive value based on device type
  static T responsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
  
  /// Calculate font size based on device type and base size
  static double responsiveFontSize(BuildContext context, double baseFontSize) {
    final deviceType = getDeviceType(context);
    final textScaler = MediaQuery.of(context).textScaler;
    
    switch (deviceType) {
      case DeviceType.mobile:
        return textScaler.scale(baseFontSize);
      case DeviceType.tablet:
        return textScaler.scale(baseFontSize + 2);
      case DeviceType.desktop:
        return textScaler.scale(baseFontSize + 4);
    }
  }
  
  /// Calculate padding based on screen size percentage
  static EdgeInsets responsivePadding(BuildContext context, {
    double horizontal = 0.05, // 5% of screen width by default
    double vertical = 0.02, // 2% of screen height by default
  }) {
    final size = MediaQuery.of(context).size;
    return EdgeInsets.symmetric(
      horizontal: size.width * horizontal,
      vertical: size.height * vertical,
    );
  }
  
  /// Determine if the layout should be using a single column (vertical) or multi-column layout
  static bool useSingleColumnLayout(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }
  
  /// Get responsive width ratio based on screen size
  static double getWidthRatio(BuildContext context, double ratio) {
    return MediaQuery.of(context).size.width * ratio;
  }
  
  /// Get responsive height ratio based on screen size
  static double getHeightRatio(BuildContext context, double ratio) {
    return MediaQuery.of(context).size.height * ratio;
  }
  
  /// Get a responsively sized widget for differentt device types
  static Widget responsiveWidget({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}

/// Extension methods for simplified access to responsive utilities
extension ResponsiveContext on BuildContext {
  /// Get device type directly from context
  DeviceType get deviceType => ResponsiveUtils.getDeviceType(this);
  
  /// Check if device is mobile
  bool get isMobile => deviceType == DeviceType.mobile;
  
  /// Check if device is tablet
  bool get isTablet => deviceType == DeviceType.tablet;
  
  /// Check if device is desktop
  bool get isDesktop => deviceType == DeviceType.desktop;
  
  /// Get responsive padding directly from context
  EdgeInsets responsivePadding({
    double horizontal = 0.05,
    double vertical = 0.02,
  }) => ResponsiveUtils.responsivePadding(
    this,
    horizontal: horizontal,
    vertical: vertical,
  );
  
  /// Get responsive font size directly from context
  double responsiveFontSize(double baseFontSize) => 
    ResponsiveUtils.responsiveFontSize(this, baseFontSize);
    
  /// Get width ratio directly from context
  double widthRatio(double ratio) => 
    ResponsiveUtils.getWidthRatio(this, ratio);
    
  /// Get height ratio directly from context
  double heightRatio(double ratio) => 
    ResponsiveUtils.getHeightRatio(this, ratio);
    
  /// Use single column layout?
  bool get useSingleColumn => 
    ResponsiveUtils.useSingleColumnLayout(this);
}

/// Responsive widget that adapts to different device types
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveUtils.responsiveWidget(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}