import 'package:flutter/material.dart';

// ======================
// Color Palette (Egyptian Theme)
// ======================

// Primary Colors
const Color nileBlue = Color(0xFF1A6EBC);       // Primary UI elements
const Color gold = Color(0xFFFFD700);           // Accent buttons/icons
const Color pharaohGreen = Color(0xFF2C5545);   // Secondary elements

// Neutral Colors
const Color desertSand = Color(0xFFEDC9AF);     // Backgrounds
const Color white = Color(0xFFFFFFFF);          // Cards/text contrast
const Color black = Color(0xFF000000);          // Primary text

// Status Colors
const Color successGreen = Color(0xFF388E3C);   // Success messages
const Color errorRed = Color(0xFFD32F2F);       // Errors (softer than pure red)
const Color warningAmber = Color(0xFFFFA000);   // Warnings

// Text Colors
const Color primaryText = Color(0xFF212121);    // Headers
const Color secondaryText = Color(0xFF666666);  // Body text
const Color disabledText = Color(0xFF9E9E9E);   // Disabled elements

// ======================
// Typography
// ======================
const String arabicFont = 'Tajawal';            // Arabic font
const String englishFont = 'Roboto';            // English font

final TextTheme appTextTheme = TextTheme(
  headlineLarge: TextStyle(
    fontFamily: arabicFont,
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    color: primaryText,
  ),
  headlineMedium: TextStyle(
    fontFamily: arabicFont,
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: pharaohGreen,
  ),
  bodyLarge: TextStyle(
    fontFamily: arabicFont,
    fontSize: 16.0,
    color: primaryText,
  ),
  bodyMedium: TextStyle(
    fontFamily: arabicFont,
    fontSize: 14.0,
    color: secondaryText,
  ),
  labelLarge: TextStyle(
    fontFamily: arabicFont,
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: white,
  ),
);

// ======================
// Button Styles
// ======================
final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: gold,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
  ),
  textStyle: appTextTheme.labelLarge,
);

final ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: nileBlue,
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(6.0),
  ),
  textStyle: appTextTheme.labelLarge?.copyWith(fontSize: 16),
);

// ======================
// App Theme
// ======================
final ThemeData appTheme = ThemeData(
  // Colors
  primaryColor: nileBlue,
  colorScheme: ColorScheme.light(
    primary: nileBlue,
    secondary: gold,
    background: desertSand,
    surface: white,
    error: errorRed,
  ),

  // Text
  fontFamily: arabicFont,
  textTheme: appTextTheme,

  // Components
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: primaryButtonStyle,
  ),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: nileBlue),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: gold, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: errorRed),
    ),
    hintStyle: TextStyle(color: disabledText),
  ),

  // Layout
  scaffoldBackgroundColor: desertSand,
  cardTheme: CardTheme(
    color: white,
    elevation: 2.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
);