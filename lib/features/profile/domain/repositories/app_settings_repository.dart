import 'package:pet_crypto/core/result/result.dart';

abstract interface class AppSettingsRepository {
  Future<Result<bool>> setThemeMode(int themeModeIndex);

  Future<Result<bool>> setLocale(String languageCode);
}
