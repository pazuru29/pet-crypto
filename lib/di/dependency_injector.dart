import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/application/router/app_router.dart';
import 'package:pet_crypto/application/router/app_router_dependencies.dart';
import 'package:pet_crypto/application/theme/app_theme_provider.dart';
import 'package:pet_crypto/core/storage/preferences_storage.dart';
import 'package:pet_crypto/core/storage/preferences_storage_impl.dart';
import 'package:pet_crypto/core/storage/secure_storage.dart';
import 'package:pet_crypto/core/storage/secure_storage_impl.dart';
import 'package:pet_crypto/features/authorization/di/register_auth_dependencies.dart';
import 'package:pet_crypto/features/dashboard/di/register_dashboard_dependencies.dart';
import 'package:pet_crypto/features/profile/di/register_profile_dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt _i = GetIt.instance;

class DI {
  DI._();

  static T get<T extends Object>({String? instanceName}) =>
      _i<T>(instanceName: instanceName);

  static Future<void> init() async {
    // Local Storages
    final secureStorage = const FlutterSecureStorage();
    final preferencesStorage = await SharedPreferences.getInstance();

    _i.registerLazySingleton<SecureStorage>(
      () => SecureStorageImpl(storage: secureStorage),
    );
    _i.registerLazySingleton<PreferencesStorage>(
      () => PreferencesStorageImpl(storage: preferencesStorage),
    );

    // Localization
    _i.registerLazySingleton<S>(() => S(storage: _i()));

    // Theme
    _i.registerLazySingleton<AppThemeProvider>(
      () => AppThemeProvider(storage: _i()),
    );

    await RegisterAuthDependencies.call(_i);
    await RegisterDashboardDependencies.call(_i);
    await RegisterProfileDependencies.call(_i);

    // App Router
    _i.registerLazySingleton<AppRouter>(
      () => AppRouter(
        dependencies: AppRouterDependencies(
          authCubit: _i(),
          createDashboardBloc: () => _i(),
          createProfileBloc: () => _i(),
        ),
      ),
    );
  }
}
