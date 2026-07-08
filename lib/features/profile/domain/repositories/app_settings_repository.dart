abstract interface class AppSettingsRepository {
  Future<void> setThemeMode(int themeModeIndex);

  Future<void> setLocale(String languageCode);
}
