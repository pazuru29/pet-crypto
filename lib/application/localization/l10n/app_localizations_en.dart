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
  String get loginButton => 'Login';

  @override
  String get loginTitle => 'LogIn';

  @override
  String get loginUsername => 'Username';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginCorrectUsername => 'Please enter the correct username';

  @override
  String get loginCorrectPassword => 'Please enter the correct password';

  @override
  String loginLengthPassword(int count) {
    return 'The password must be $count characters or more';
  }
}
