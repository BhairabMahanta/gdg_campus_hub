import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF01696F),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF01696F),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      );
}