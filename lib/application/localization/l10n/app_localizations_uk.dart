// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Pet Crypto';

  @override
  String get dashboardTitle => 'Дашборд';

  @override
  String get profileTitle => 'Профіль';

  @override
  String dashboardCryptoTitle(String name, String symbol) {
    return '$name ($symbol)';
  }

  @override
  String dashboardPriceCrypto(String currencyCode, double value) {
    return '$currencyCode: $value';
  }

  @override
  String get profileTheme => 'Тема';

  @override
  String get profileLocalization => 'Локалізація';

  @override
  String get profileLogout => 'Вийти';

  @override
  String get loginButton => 'Увійти';

  @override
  String get loginTitle => 'Вхід';

  @override
  String get loginUsername => 'Ім’я користувача';

  @override
  String get loginPassword => 'Пароль';

  @override
  String get loginCorrectUsername =>
      'Будь ласка, введіть правильне ім’я користувача';

  @override
  String get loginCorrectPassword => 'Будь ласка, введіть правильний пароль';

  @override
  String loginLengthPassword(int count) {
    return 'Пароль має містити щонайменше $count символів';
  }

  @override
  String get errorViewPlaceholder => 'Щось пішло не так...';

  @override
  String get errorViewTryAgain => 'Спробувати знову';

  @override
  String get cryptoDetailsTitle => 'Деталі';

  @override
  String cryptoDetailsCoinName(String name, String symbol) {
    return '$name ($symbol)';
  }

  @override
  String get cryptoDetailsWebsite => 'Вебсайт';

  @override
  String get cryptoDetailsTechnicalDoc => 'Технічна документація';

  @override
  String get cryptoDetailsSourceCode => 'Вихідний код';

  @override
  String get appErrorInvalidCredentials =>
      'Неправильне ім’я користувача або пароль.';

  @override
  String get appErrorSessionExpired => 'Сеанс завершився. Увійдіть знову.';

  @override
  String get appErrorAccessDenied => 'Доступ заборонено.';

  @override
  String get appErrorInvalidRequest => 'Некоректний запит.';

  @override
  String get appErrorNotFound => 'Запитані дані не знайдено.';

  @override
  String get appErrorServerUnavailable =>
      'Сервер тимчасово недоступний. Спробуйте пізніше.';

  @override
  String get appErrorNetworkUnavailable =>
      'Перевірте підключення до інтернету та спробуйте знову.';

  @override
  String get appErrorInvalidResponse => 'Сервер повернув некоректну відповідь.';

  @override
  String get appErrorStorageFailure =>
      'Не вдалося зберегти або завантажити локальні дані.';

  @override
  String get appErrorConfiguration => 'Помилка конфігурації застосунку.';

  @override
  String get appErrorUnexpected => 'Щось пішло не так. Спробуйте знову.';

  @override
  String get appErrorInvalidLink => 'Некоректне посилання.';

  @override
  String get appErrorUnsupportedLink => 'Цей тип посилань не підтримується.';

  @override
  String get appErrorOpenLinkFailed => 'Не вдалося відкрити посилання.';
}
