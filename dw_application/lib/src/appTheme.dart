import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
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
      fontSize: 14,
      fontFamily: 'Inter',
    ),
  ),
);
