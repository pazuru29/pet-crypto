import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeProvider extends ChangeNotifier {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: .fromSeed(seedColor: Colors.deepPurpleAccent),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: .fromSeed(seedColor: Colors.deepPurple, brightness: .dark),
  );

  late ThemeMode _mode;

  ThemeMode get mode => _mode;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('themeMode') ?? 0;
    _mode = ThemeMode.values[index];
    notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
    _mode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', mode.index);
  }
}
