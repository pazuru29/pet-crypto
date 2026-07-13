import 'package:flutter/material.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
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
    final storageIndex = storage.getInt('themeMode');
    final length = ThemeMode.values.length;

    final index = storageIndex == null
        ? 0
        : storageIndex >= 0 && storageIndex < length
        ? storageIndex
        : 0;

    _mode = ThemeMode.values[index];
    notifyListeners();
  }

  Future<Result<bool>> setMode(int modeIndex) async {
    if (!(modeIndex >= 0 && modeIndex <= (ThemeMode.values.length - 1)) ||
        _mode.index == modeIndex) {
      return Ok(false);
    }

    _mode = ThemeMode.values[modeIndex];
    notifyListeners();
    try {
      await storage.setInt('themeMode', mode.index);
      return Ok(true);
    } catch (_) {
      return Err(StorageFailure('Error saving the theme mode'));
    }
  }
}
