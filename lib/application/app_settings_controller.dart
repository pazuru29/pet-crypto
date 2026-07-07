import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/application/theme/app_theme_provider.dart';

class AppSettingsController {
  final S localeProvider;
  final AppThemeProvider themeProvider;

  AppSettingsController({
    required this.localeProvider,
    required this.themeProvider,
  });

  Future<void> setLocale(String languageCode) async {
    return await localeProvider.setLocale(languageCode);
  }

  Future<void> setThemeMode(int themeModeIndex) async {
    return await themeProvider.setMode(themeModeIndex);
  }
}
