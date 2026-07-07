import 'package:flutter/material.dart';
import 'package:pet_crypto/core/storage/preferences_storage.dart';

class AppThemeProvider extends ChangeNotifier {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: .fromSeed(seedColor: Colors.deepPurpleAccent),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: .fromSeed(seedColor: Colors.deepPurple, brightness: .dark),
  );

  final PreferencesStorage storage;

  AppThemeProvider({required this.storage});

  late ThemeMode _mode;

  ThemeMode get mode => _mode;

  void init() {
    final index = storage.getInt('themeMode') ?? 0;
    _mode = ThemeMode.values[index];
    notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
    _mode = mode;
    notifyListeners();
    await storage.setInt('themeMode', mode.index);
  }
}
