import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
  );
}
