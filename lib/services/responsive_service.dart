import 'package:flutter/material.dart';

/// Screen size categories
enum ScreenSize {
  small,   // < 600px width (phones)
  medium,  // 600-1024px (tablets, small laptops)
  large,   // > 1024px (desktops, large laptops)
}

/// Orientation categories
enum ScreenOrientation {
  portrait,
  landscape,
}

/// Service for responsive design utilities
class ResponsiveService {
  /// Get screen size category
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < 600) {
      return ScreenSize.small;
    } else if (width < 1024) {
      return ScreenSize.medium;
    } else {
      return ScreenSize.large;
    }
  }

  /// Get screen orientation
  static ScreenOrientation getOrientation(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.portrait 
        ? ScreenOrientation.portrait 
        : ScreenOrientation.landscape;
  }

  /// Check if device is a phone
  static bool isPhone(BuildContext context) {
    return getScreenSize(context) == ScreenSize.small;
  }

  /// Check if device is a tablet
  static bool isTablet(BuildContext context) {
    return getScreenSize(context) == ScreenSize.medium;
  }

  /// Check if device is a desktop
  static bool isDesktop(BuildContext context) {
    return getScreenSize(context) == ScreenSize.large;
  }

  /// Get responsive value based on screen size
  static T getResponsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final screenSize = getScreenSize(context);
    
    switch (screenSize) {
      case ScreenSize.small:
        return mobile;
      case ScreenSize.medium:
        return tablet ?? mobile;
      case ScreenSize.large:
        return desktop ?? tablet ?? mobile;
    }
  }

  /// Get responsive font size
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenSize = getScreenSize(context);
    
    switch (screenSize) {
      case ScreenSize.small:
        return baseFontSize;
      case ScreenSize.medium:
        return baseFontSize * 1.2;
      case ScreenSize.large:
        return baseFontSize * 1.4;
    }
  }

  /// Get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenSize = getScreenSize(context);
    
    switch (screenSize) {
      case ScreenSize.small:
        return const EdgeInsets.all(8.0);
      case ScreenSize.medium:
        return const EdgeInsets.all(16.0);
      case ScreenSize.large:
        return const EdgeInsets.all(24.0);
    }
  }

  /// Get responsive spacing
  static double getResponsiveSpacing(BuildContext context) {
    final screenSize = getScreenSize(context);
    
    switch (screenSize) {
      case ScreenSize.small:
        return 8.0;
      case ScreenSize.medium:
        return 16.0;
      case ScreenSize.large:
        return 24.0;
    }
  }

  /// Get number of grid columns based on screen size
  static int getGridColumns(BuildContext context) {
    final screenSize = getScreenSize(context);
    
    switch (screenSize) {
      case ScreenSize.small:
        return 2;
      case ScreenSize.medium:
        return 3;
      case ScreenSize.large:
        return 4;
    }
  }

  /// Get responsive icon size
  static double getIconSize(BuildContext context, double baseSize) {
    final screenSize = getScreenSize(context);
    
    switch (screenSize) {
      case ScreenSize.small:
        return baseSize;
      case ScreenSize.medium:
        return baseSize * 1.3;
      case ScreenSize.large:
        return baseSize * 1.5;
    }
  }

  /// Calculate responsive shape size based on available space
  static double calculateShapeSize(BuildContext context, double availableWidth, double availableHeight) {
    final screenSize = getScreenSize(context);
    
    // Use the smaller dimension to ensure shape fits
    final minDimension = availableWidth < availableHeight ? availableWidth : availableHeight;
    
    switch (screenSize) {
      case ScreenSize.small:
        return minDimension * 0.8;
      case ScreenSize.medium:
        return minDimension * 0.7;
      case ScreenSize.large:
        return minDimension * 0.6;
    }
  }

  /// Get optimal repetition count based on screen size
  static int getOptimalRepetitions(BuildContext context) {
    final screenSize = getScreenSize(context);
    
    switch (screenSize) {
      case ScreenSize.small:
        return 30;
      case ScreenSize.medium:
        return 50;
      case ScreenSize.large:
        return 70;
    }
  }

  /// Get optimal shape size multiplier based on screen size
  static double getOptimalSizeMultiplier(BuildContext context) {
    final screenSize = getScreenSize(context);
    
    switch (screenSize) {
      case ScreenSize.small:
        return 4.0;
      case ScreenSize.medium:
        return 5.0;
      case ScreenSize.large:
        return 6.0;
    }
  }

  /// Check if layout should be horizontal
  static bool shouldUseHorizontalLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width > size.height && size.width > 600;
  }

  /// Get responsive card elevation
  static double getCardElevation(BuildContext context) {
    final screenSize = getScreenSize(context);
    
    switch (screenSize) {
      case ScreenSize.small:
        return 2.0;
      case ScreenSize.medium:
        return 4.0;
      case ScreenSize.large:
        return 6.0;
    }
  }

  /// Get responsive border radius
  static double getBorderRadius(BuildContext context) {
    final screenSize = getScreenSize(context);
    
    switch (screenSize) {
      case ScreenSize.small:
        return 8.0;
      case ScreenSize.medium:
        return 12.0;
      case ScreenSize.large:
        return 16.0;
    }
  }
}
