import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pet_crypto/application/localization/l10n/app_localizations.dart';
import 'package:pet_crypto/core/storage/preferences_storage.dart';

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

  final PreferencesStorage storage;

  S({required this.storage});

  late Locale _locale;

  Locale get locale => _locale;

  void init() {
    final currentLang =
        storage.getString(_localeKey) ??
        Platform.localeName.split(RegExp('[-_]')).first;
    if (supportedLocales.containsKey(currentLang)) {
      _locale = Locale(currentLang);
    } else {
      _locale = Locale('en');
    }
    notifyListeners();
  }

  Future<void> setLocale(String lang) async {
    String lowerLeng = lang.toLowerCase();
    Locale nextLocale = Locale(lowerLeng);

    if (!supportedLocales.containsKey(lowerLeng) || nextLocale == _locale) {
      return;
    }

    _locale = nextLocale;
    notifyListeners();
    await storage.setString(_localeKey, lowerLeng);
  }
}
