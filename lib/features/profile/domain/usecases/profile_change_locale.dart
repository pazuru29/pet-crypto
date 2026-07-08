import 'package:pet_crypto/features/profile/domain/repositories/app_settings_repository.dart';

class ProfileChangeLocale {
  final AppSettingsRepository repo;

  const ProfileChangeLocale({required this.repo});

  Future<void> setLocale(String languageCode) async {
    return await repo.setLocale(languageCode);
  }
}
