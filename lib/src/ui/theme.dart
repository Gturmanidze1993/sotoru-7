import 'package:flutter/material.dart';
class AppTheme {
  static ThemeData light() => ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange, brightness: Brightness.light), useMaterial3: true);
  static ThemeData dark() => ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange, brightness: Brightness.dark), useMaterial3: true);
}
