import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/profile/domain/repositories/app_settings_repository.dart';

class ProfileChangeLocale {
  final AppSettingsRepository repo;

  const ProfileChangeLocale({required this.repo});

  Future<Result<bool>> call(String languageCode) async {
    return repo.setLocale(languageCode);
  }
}
