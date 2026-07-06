import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pet_crypto/core/localization/l10n/app_localizations.dart';

class S extends ChangeNotifier {
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

  void init() {
    String platformLang = Platform.localeName;
    if (supportedLocales.containsKey(platformLang)) {
      _locale = Locale(platformLang);
    } else {
      _locale = Locale('en');
    }
  }

  void changeLocale(String lang) {
    String lowerLeng = lang.toLowerCase();
    Locale nextLocale = Locale(lowerLeng);
    if (supportedLocales.containsKey(lowerLeng) && nextLocale != _locale) {
      _locale = nextLocale;
      notifyListeners();
    }
  }
}
