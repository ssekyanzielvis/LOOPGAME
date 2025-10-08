import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppThemeColor {
  blue,
  green,
  purple,
  orange,
  red,
  teal,
  pink,
  indigo,
}

class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  ThemeMode _themeMode = ThemeMode.system;
  AppThemeColor _themeColor = AppThemeColor.blue;
  double _fontSize = 1.0; // Font size multiplier (0.8 to 1.4)
  Color _customTextColor = Colors.black;
  bool _useCustomTextColor = false;

  ThemeMode get themeMode => _themeMode;
  AppThemeColor get themeColor => _themeColor;
  double get fontSize => _fontSize;
  Color get customTextColor => _customTextColor;
  bool get useCustomTextColor => _useCustomTextColor;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setThemeColor(AppThemeColor color) {
    _themeColor = color;
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size.clamp(0.8, 1.4);
    notifyListeners();
  }

  void setCustomTextColor(Color color) {
    _customTextColor = color;
    notifyListeners();
  }

  void setUseCustomTextColor(bool use) {
    _useCustomTextColor = use;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }

  Color getPrimaryColor() {
    switch (_themeColor) {
      case AppThemeColor.blue:
        return const Color(0xFF2196F3);
      case AppThemeColor.green:
        return const Color(0xFF4CAF50);
      case AppThemeColor.purple:
        return const Color(0xFF9C27B0);
      case AppThemeColor.orange:
        return const Color(0xFFFF9800);
      case AppThemeColor.red:
        return const Color(0xFFF44336);
      case AppThemeColor.teal:
        return const Color(0xFF009688);
      case AppThemeColor.pink:
        return const Color(0xFFE91E63);
      case AppThemeColor.indigo:
        return const Color(0xFF3F51B5);
    }
  }

  static ThemeData get lightTheme {
    final themeService = ThemeService();
    final primaryColor = themeService.getPrimaryColor();
    final fontSizeMultiplier = themeService.fontSize;
    
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: _getMaterialColor(primaryColor),
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      cardColor: Colors.white,
      dividerColor: const Color(0xFFE0E0E0),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: Colors.white,
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        fillColor: Colors.white,
        filled: true,
      ),
      
      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        thumbColor: primaryColor,
        overlayColor: primaryColor.withValues(alpha: 0.2),
        inactiveTrackColor: Colors.grey[300],
      ),
      
      // Text Theme
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28 * fontSizeMultiplier,
          fontWeight: FontWeight.bold,
          color: themeService.useCustomTextColor ? themeService.customTextColor : const Color(0xFF1A1A1A),
        ),
        headlineMedium: TextStyle(
          fontSize: 22 * fontSizeMultiplier,
          fontWeight: FontWeight.w600,
          color: themeService.useCustomTextColor ? themeService.customTextColor : const Color(0xFF1A1A1A),
        ),
        bodyLarge: TextStyle(
          fontSize: 16 * fontSizeMultiplier,
          color: themeService.useCustomTextColor ? themeService.customTextColor : const Color(0xFF424242),
        ),
        bodyMedium: TextStyle(
          fontSize: 14 * fontSizeMultiplier,
          color: themeService.useCustomTextColor ? themeService.customTextColor : const Color(0xFF424242),
        ),
        bodySmall: TextStyle(
          fontSize: 12 * fontSizeMultiplier,
          color: themeService.useCustomTextColor ? themeService.customTextColor : const Color(0xFF757575),
        ),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: Color(0xFF424242),
      ),
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData get darkTheme {
    final themeService = ThemeService();
    final primaryColor = themeService.getPrimaryColor();
    final fontSizeMultiplier = themeService.fontSize;
    final darkPrimaryColor = Color.lerp(primaryColor, Colors.black, 0.2)!;
    
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: _getMaterialColor(darkPrimaryColor),
      primaryColor: darkPrimaryColor,
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      dividerColor: const Color(0xFF333333),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: darkPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: const Color(0xFF1E1E1E),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkPrimaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        fillColor: const Color(0xFF2A2A2A),
        filled: true,
      ),
      
      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: darkPrimaryColor,
        thumbColor: darkPrimaryColor,
        overlayColor: darkPrimaryColor.withValues(alpha: 0.2),
        inactiveTrackColor: const Color(0xFF424242),
      ),
      
      // Text Theme
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28 * fontSizeMultiplier,
          fontWeight: FontWeight.bold,
          color: themeService.useCustomTextColor ? themeService.customTextColor : const Color(0xFFFFFFFF),
        ),
        headlineMedium: TextStyle(
          fontSize: 22 * fontSizeMultiplier,
          fontWeight: FontWeight.w600,
          color: themeService.useCustomTextColor ? themeService.customTextColor : const Color(0xFFFFFFFF),
        ),
        bodyLarge: TextStyle(
          fontSize: 16 * fontSizeMultiplier,
          color: themeService.useCustomTextColor ? themeService.customTextColor : const Color(0xFFE0E0E0),
        ),
        bodyMedium: TextStyle(
          fontSize: 14 * fontSizeMultiplier,
          color: themeService.useCustomTextColor ? themeService.customTextColor : const Color(0xFFE0E0E0),
        ),
        bodySmall: TextStyle(
          fontSize: 12 * fontSizeMultiplier,
          color: themeService.useCustomTextColor ? themeService.customTextColor : const Color(0xFFBDBDBD),
        ),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: Color(0xFFE0E0E0),
      ),
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: darkPrimaryColor,
        brightness: Brightness.dark,
      ),
    );
  }

  // Helper method to create MaterialColor from Color
  static MaterialColor _getMaterialColor(Color color) {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}