import 'package:flutter/material.dart';

ThemeData appThemeLight = ThemeData(
  colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFE5407A),
      onPrimary: Colors.white,
      secondary: Color(0xFFADD7FF),
      onSecondary: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.white),
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: Color(0xFFE5407A),
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.32,
      height: 2,
      fontFamily: 'Verdana',
    ),
    bodyLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 22,
      fontFamily: 'Inter',
    ),
  ),
);

ThemeData appThemeDark = ThemeData(
  colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFE5407A),
      onPrimary: Color.fromARGB(255, 8, 170, 219),
      secondary: Color(0xFFADD7FF),
      onSecondary: Colors.black,
      surface: Color.fromARGB(255, 49, 48, 52),
      onSurface: Color.fromARGB(255, 190, 187, 187),
      error: Colors.red,
      onError: Color.fromARGB(255, 255, 255, 255)),
  scaffoldBackgroundColor: const Color.fromARGB(255, 49, 48, 52),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: Color(0xFFE5407A),
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.32,
      height: 2,
      fontFamily: 'Verdana',
    ),
    bodyLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 22,
      fontFamily: 'Inter',
    ),
  ),
);
