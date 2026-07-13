import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/application/theme/app_theme_provider.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/profile/domain/repositories/app_settings_repository.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final S localeProvider;
  final AppThemeProvider themeProvider;

  AppSettingsRepositoryImpl({
    required this.localeProvider,
    required this.themeProvider,
  });

  @override
  Future<Result<bool>> setLocale(String languageCode) async {
    return await localeProvider.setLocale(languageCode);
  }

  @override
  Future<Result<bool>> setThemeMode(int themeModeIndex) async {
    return await themeProvider.setMode(themeModeIndex);
  }
}
