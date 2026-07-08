// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pet Crypto';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get profileTitle => 'Profile';

  @override
  String dashboardCryptoTitle(String name, String symbol) {
    return '$name ($symbol)';
  }

  @override
  String dashboardPriceCrypto(String currencyCode, double value) {
    return '$currencyCode: $value';
  }

  @override
  String get profileTheme => 'Theme';

  @override
  String get profileLocalization => 'Localization';

  @override
  String get profileLogout => 'Logout';

  @override
  String get authorizationLogin => 'Login';
}
