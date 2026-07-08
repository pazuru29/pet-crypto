import 'package:pet_crypto/features/profile/domain/repositories/app_settings_repository.dart';

class ProfileChangeThemeMode {
  final AppSettingsRepository repo;

  const ProfileChangeThemeMode({required this.repo});

  Future<void> setThemeMode(int themeModeIndex) async {
    return await repo.setThemeMode(themeModeIndex);
  }
}
