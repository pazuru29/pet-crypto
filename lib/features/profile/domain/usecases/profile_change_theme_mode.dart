import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/profile/domain/repositories/app_settings_repository.dart';

class ProfileChangeThemeMode {
  final AppSettingsRepository repo;

  const ProfileChangeThemeMode({required this.repo});

  Future<Result<bool>> call(int themeModeIndex) async {
    return repo.setThemeMode(themeModeIndex);
  }
}
