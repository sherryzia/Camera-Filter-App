import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // App colors - Light Theme
  static const Color primaryColor = Color(0xFFFFFC00); // Snapchat Yellow
  static const Color secondaryColor = Color(0xFF000000);
  static const Color accentColor = Color(0xFF00C4FF);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF212121);
  static const Color subtitleColor = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color errorColor = Color(0xFFD32F2F);
  
  // App colors - Dark Theme
  static const Color darkPrimaryColor = Color(0xFFFFFC00); // Keep Snapchat Yellow
  static const Color darkSecondaryColor = Color(0xFFFFFFFF);
  static const Color darkAccentColor = Color(0xFF00D1FF);
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkCardColor = Color(0xFF1E1E1E);
  static const Color darkTextColor = Color.fromARGB(255, 255, 255, 255);
  static const Color darkSubtitleColor = Color.fromARGB(255, 255, 255, 255);
  static const Color darkDividerColor = Color(0xFF2C2C2C);
  static const Color darkSurfaceColor = Color(0xFF252525);
  
  // Text styles - Light Theme
  static TextStyle headingStyle = GoogleFonts.poppins(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  
  static TextStyle titleStyle = GoogleFonts.poppins(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: textColor,
  );
  
  static TextStyle subtitleStyle = GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: subtitleColor,
  );
  
  static TextStyle bodyStyle = GoogleFonts.poppins(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: textColor,
  );
  
  static TextStyle buttonTextStyle = GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  // Text styles - Dark Theme
  static TextStyle darkHeadingStyle = GoogleFonts.poppins(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: darkTextColor,
  );
  
  static TextStyle darkTitleStyle = GoogleFonts.poppins(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: darkTextColor,
  );
  
  static TextStyle darkSubtitleStyle = GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: darkSubtitleColor,
  );
  
  static TextStyle darkBodyStyle = GoogleFonts.poppins(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: darkTextColor,
  );
  
  static TextStyle darkButtonTextStyle = GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  
  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    dividerColor: dividerColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: cardColor,
      background: backgroundColor,
      error: errorColor,
    ),
    textTheme: TextTheme(
      displayLarge: headingStyle,
      titleLarge: titleStyle,
      titleMedium: subtitleStyle,
      bodyLarge: bodyStyle,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: textColor),
      titleTextStyle: titleStyle,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: buttonTextStyle.copyWith(color: Colors.black),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor, width: 2),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: buttonTextStyle.copyWith(color: primaryColor),
      ),
    ),
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: dividerColor,
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      labelStyle: subtitleStyle,
      hintStyle: subtitleStyle.copyWith(color: subtitleColor.withOpacity(0.7)),
    ),
  );
  
  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    cardColor: darkCardColor,
    dividerColor: darkDividerColor,
    colorScheme: ColorScheme.dark(
      primary: darkPrimaryColor,
      secondary: darkSecondaryColor,
      surface: darkSurfaceColor,
      background: darkBackgroundColor,
      error: errorColor,
      onPrimary: Colors.black,
      onSecondary: darkBackgroundColor,
      onSurface: darkTextColor,
      onBackground: darkTextColor,
    ),
    textTheme: TextTheme(
      displayLarge: darkHeadingStyle,
      titleLarge: darkTitleStyle,
      titleMedium: darkSubtitleStyle,
      bodyLarge: darkBodyStyle,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkSurfaceColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: darkTextColor),
      titleTextStyle: darkTitleStyle,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimaryColor,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: darkButtonTextStyle,
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkPrimaryColor,
        side: const BorderSide(color: darkPrimaryColor, width: 2),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: darkButtonTextStyle.copyWith(color: darkPrimaryColor),
      ),
    ),
    cardTheme: CardTheme(
      color: darkCardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.4),
    ),
    dividerTheme: DividerThemeData(
      color: darkDividerColor,
      thickness: 1,
      space: 1,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: darkCardColor,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: darkSurfaceColor,
      contentTextStyle: darkBodyStyle,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return darkPrimaryColor;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return darkPrimaryColor.withOpacity(0.5);
        }
        return null;
      }),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurfaceColor,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkPrimaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      labelStyle: darkSubtitleStyle,
      hintStyle: darkSubtitleStyle.copyWith(color: darkSubtitleColor.withOpacity(0.7)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkSurfaceColor,
      selectedItemColor: darkPrimaryColor,
      unselectedItemColor: darkSubtitleColor,
    ),
  );

  // Method to get current theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }
}