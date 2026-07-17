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
  String get profileLocalization => 'Локализация';

  @override
  String get profileLogout => 'Выйти';

  @override
  String get loginButton => 'Войти';

  @override
  String get loginTitle => 'Вход';

  @override
  String get loginUsername => 'Имя пользователя';

  @override
  String get loginPassword => 'Пароль';

  @override
  String get loginCorrectUsername =>
      'Пожалуйста, введите правильное имя пользователя';

  @override
  String get loginCorrectPassword => 'Пожалуйста, введите правильный пароль';

  @override
  String loginLengthPassword(int count) {
    return 'Пароль должен содержать минимум $count символов';
  }

  @override
  String get errorViewPlaceholder => 'Что-то пошло не так...';

  @override
  String get errorViewTryAgain => 'Попробовать снова';

  @override
  String get cryptoDetailsTitle => 'Детали';

  @override
  String cryptoDetailsCoinName(String name, String symbol) {
    return '$name ($symbol)';
  }

  @override
  String get cryptoDetailsWebsite => 'Веб-сайт';

  @override
  String get cryptoDetailsTechnicalDoc => 'Техническая документация';

  @override
  String get cryptoDetailsSourceCode => 'Исходный код';

  @override
  String get appErrorInvalidCredentials =>
      'Неверное имя пользователя или пароль.';

  @override
  String get appErrorSessionExpired => 'Сессия истекла. Войдите снова.';

  @override
  String get appErrorAccessDenied => 'Доступ запрещён.';

  @override
  String get appErrorInvalidRequest => 'Некорректный запрос.';

  @override
  String get appErrorNotFound => 'Запрошенные данные не найдены.';

  @override
  String get appErrorServerUnavailable =>
      'Сервер временно недоступен. Попробуйте позже.';

  @override
  String get appErrorNetworkUnavailable =>
      'Проверьте подключение к интернету и попробуйте снова.';

  @override
  String get appErrorInvalidResponse => 'Сервер вернул некорректный ответ.';

  @override
  String get appErrorStorageFailure =>
      'Не удалось сохранить или загрузить локальные данные.';

  @override
  String get appErrorConfiguration => 'Ошибка конфигурации приложения.';

  @override
  String get appErrorUnexpected => 'Что-то пошло не так. Попробуйте снова.';

  @override
  String get appErrorInvalidLink => 'Некорректная ссылка.';

  @override
  String get appErrorUnsupportedLink => 'Этот тип ссылок не поддерживается.';

  @override
  String get appErrorOpenLinkFailed => 'Не удалось открыть ссылку.';
}
