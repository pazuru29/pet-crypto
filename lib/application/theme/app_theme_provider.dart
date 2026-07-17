import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:pet_crypto/core/storage/preferences_storage.dart';

class AppThemeProvider extends ChangeNotifier {
  final Logger _log = Logger('AppThemeProvider');

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
    final length = ThemeMode.values.length;
    final defaultIndex = ThemeMode.system.index;
    int? storageIndex;

    try {
      storageIndex = storage.getInt('themeMode');
    } catch (e, s) {
      _log.warning('Error during read storage theme mode', e, s);
    }

    final int index;

    if (storageIndex != null && storageIndex >= 0 && storageIndex < length) {
      index = storageIndex;
    } else {
      index = defaultIndex;
    }

    _mode = ThemeMode.values[index];
    notifyListeners();
  }

  Future<bool> setMode(int modeIndex) async {
    if (!(modeIndex >= 0 && modeIndex <= (ThemeMode.values.length - 1)) ||
        _mode.index == modeIndex) {
      return false;
    }

    await storage.setInt('themeMode', modeIndex);

    _mode = ThemeMode.values[modeIndex];
    notifyListeners();

    return true;
  }
}
