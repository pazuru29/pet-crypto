import 'package:pet_crypto/application/theme/app_theme_provider.dart';

class ProfileChangeThemeMode {
  final AppThemeProvider themeProvider;

  const ProfileChangeThemeMode({
    required this.themeProvider,
  });

  Future<void> setThemeMode(int themeModeIndex) async {
    return await themeProvider.setMode(themeModeIndex);
  }
}
