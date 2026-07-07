// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Pet Crypto';

  @override
  String get dashboardTitle => 'Дашборд';

  @override
  String get profileTitle => 'Профиль';

  @override
  String cryptoTitle(String name, String symbol) {
    return '$name ($symbol)';
  }

  @override
  String priceCrypto(String currencyCode, double value) {
    return '$currencyCode: $value';
  }
}
