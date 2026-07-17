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

  @override
  String get errorViewPlaceholder => 'Something went wrong...';

  @override
  String get errorViewTryAgain => 'Try Again';

  @override
  String get cryptoDetailsTitle => 'Details';

  @override
  String cryptoDetailsCoinName(String name, String symbol) {
    return '$name ($symbol)';
  }

  @override
  String get cryptoDetailsWebsite => 'Website';

  @override
  String get cryptoDetailsTechnicalDoc => 'Technical doc';

  @override
  String get cryptoDetailsSourceCode => 'Source code';

  @override
  String get appErrorInvalidCredentials => 'Incorrect username or password.';

  @override
  String get appErrorSessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get appErrorAccessDenied => 'Access denied.';

  @override
  String get appErrorInvalidRequest => 'The request is invalid.';

  @override
  String get appErrorNotFound => 'The requested data was not found.';

  @override
  String get appErrorServerUnavailable =>
      'The server is temporarily unavailable. Please try again later.';

  @override
  String get appErrorNetworkUnavailable =>
      'Check your internet connection and try again.';

  @override
  String get appErrorInvalidResponse =>
      'The server returned an invalid response.';

  @override
  String get appErrorStorageFailure => 'Could not save or load local data.';

  @override
  String get appErrorConfiguration =>
      'The application configuration is invalid.';

  @override
  String get appErrorUnexpected => 'Something went wrong. Please try again.';

  @override
  String get appErrorInvalidLink => 'The link is invalid.';

  @override
  String get appErrorUnsupportedLink => 'This link type is not supported.';

  @override
  String get appErrorOpenLinkFailed => 'Could not open the link.';
}
