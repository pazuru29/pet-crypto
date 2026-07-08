import 'package:pet_crypto/application/localization/s.dart';

class ProfileChangeLocale {
  final S localeProvider;

  const ProfileChangeLocale({required this.localeProvider});

  Future<void> setLocale(String languageCode) async {
    return await localeProvider.setLocale(languageCode);
  }
}
