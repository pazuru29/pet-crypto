import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'package:pet_crypto/application/localization/l10n/app_localizations.dart';
import 'package:pet_crypto/core/storage/preferences_storage.dart';

class S extends ChangeNotifier {
  final Logger _log = Logger('S');

  final String _localeKey = 'locale';

  static const Map<String, Locale> supportedLocales = {
    'en': Locale('en'),
    'uk': Locale('uk'),
    'ru': Locale('ru'),
  };

  static const languageLabels = {'en': 'EN', 'uk': 'UA', 'ru': 'RU'};

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
    final defaultLocale = supportedLocales.values.first;
    String? platformLocale;
    String? storageLocale;

    try {
      storageLocale = storage.getString(_localeKey);
    } catch (e, s) {
      _log.warning('Error during read locale', e, s);
    }

    try {
      platformLocale = Platform.localeName.split(RegExp('[-_]')).first;
    } catch (e, s) {
      _log.warning('Error during fetch platform locale', e, s);
    }

    final currentLang = _normalizeLanguageCode(storageLocale ?? platformLocale);

    _locale = supportedLocales[currentLang] ?? defaultLocale;

    notifyListeners();
  }

  Future<bool> setLocale(String lang) async {
    final languageCode = _normalizeLanguageCode(lang);

    if (languageCode == null ||
        !supportedLocales.containsKey(languageCode) ||
        languageCode == _locale.languageCode) {
      return false;
    }

    await storage.setString(_localeKey, languageCode);

    _locale = supportedLocales[languageCode]!;
    notifyListeners();

    return true;
  }

  static String? _normalizeLanguageCode(String? languageCode) {
    final normalized = languageCode?.trim().toLowerCase();

    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return normalized;
  }
}
