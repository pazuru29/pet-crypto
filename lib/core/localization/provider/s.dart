import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pet_crypto/core/localization/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class S extends ChangeNotifier {
  final String _localeKey = 'locale';

  static const Map<String, Locale> supportedLocales = {
    'en': Locale('en'),
    'ru': Locale('ru'),
  };

  static const localizationDelegates = <LocalizationsDelegate>[
    GlobalWidgetsLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    AppLocalizations.delegate,
  ];

  static AppLocalizations of(BuildContext context) =>
      AppLocalizations.of(context);

  late Locale _locale;

  Locale get locale => _locale;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final currentLang = prefs.getString(_localeKey) ?? Platform.localeName;
    if (supportedLocales.containsKey(currentLang)) {
      _locale = Locale(currentLang);
    } else {
      _locale = Locale('en');
    }
  }

  Future<void> setLocale(String lang) async {
    String lowerLeng = lang.toLowerCase();
    Locale nextLocale = Locale(lowerLeng);
    if (supportedLocales.containsKey(lowerLeng) && nextLocale != _locale) {
      _locale = nextLocale;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, lowerLeng);
    }
  }
}
