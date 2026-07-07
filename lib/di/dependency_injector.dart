import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/application/router/app_router.dart';
import 'package:pet_crypto/application/router/app_router_dependencies.dart';
import 'package:pet_crypto/application/theme/app_theme_provider.dart';
import 'package:pet_crypto/core/network/http_client/auth_dio_helper.dart';
import 'package:pet_crypto/core/network/http_client/base_http_client.dart';
import 'package:pet_crypto/core/network/http_client/dio_client_impl.dart';
import 'package:pet_crypto/core/network/http_client/user_dio_helper.dart';
import 'package:pet_crypto/core/network/interceptors/api_interceptor.dart';
import 'package:pet_crypto/core/network/interceptors/logging_interceptor.dart';
import 'package:pet_crypto/core/storage/preferences_storage.dart';
import 'package:pet_crypto/core/storage/preferences_storage_impl.dart';
import 'package:pet_crypto/core/storage/secure_storage.dart';
import 'package:pet_crypto/core/storage/secure_storage_impl.dart';
import 'package:pet_crypto/features/authorization/application/auth_session_coordinator.dart';
import 'package:pet_crypto/core/application/session_scope_controller.dart';
import 'package:pet_crypto/di/user_session_controller.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_datasource.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_datasource_impl.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_local_datasource.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_local_datasource_impl.dart';
import 'package:pet_crypto/features/authorization/data/repositories/auth_repository_impl.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_check_status.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_login_user.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_logout_user.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_refresh_token.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_cubit.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/dashboard_cryptocurrency_datasource.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/dashboard_cryptocurrency_datasource_impl.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/dashboard_local_datasource_impl.dart';
import 'package:pet_crypto/features/dashboard/data/repositories/dashboard_cryptocurrency_repository_impl.dart';
import 'package:pet_crypto/features/dashboard/data/repositories/dashboard_local_repository_impl.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/dashboard_cryptocurrency_repository.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/dashboard_local_repository.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/dashboard_get_cryptocurrency.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/dashboard_get_user_image.dart';
import 'package:pet_crypto/features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt _i = GetIt.instance;
const String _userScopeName = 'user';

class DI {
  DI._();

  static T get<T extends Object>({String? instanceName}) =>
      _i<T>(instanceName: instanceName);

  static Future<void> init() async {
    String dioClientName = 'AuthDioClientImpl';

    // Helper
    AuthDioHelper httpHelper = AuthDioHelper();
    await httpHelper.init();

    // Dio
    Dio dio = Dio(httpHelper.options)
      ..interceptors.addAll([LoggingInterceptor()]);

    _i.registerLazySingleton<BaseHttpClient>(
      () => DioClientImpl(dio: dio),
      instanceName: dioClientName,
    );

    // Remote DataSources
    _i.registerLazySingleton<AuthDatasource>(
      () => AuthDatasourceImpl(client: _i.get(instanceName: dioClientName)),
    );

    // Local DataSources
    final secureStorage = const FlutterSecureStorage();
    final preferencesStorage = await SharedPreferences.getInstance();

    _i.registerLazySingleton<SecureStorage>(
      () => SecureStorageImpl(storage: secureStorage),
    );
    _i.registerLazySingleton<PreferencesStorage>(
      () => PreferencesStorageImpl(storage: preferencesStorage),
    );
    _i.registerLazySingleton<AuthLocalDatasource>(
      () => AuthLocalDatasourceImpl(
        secureStorage: _i(),
        preferencesStorage: _i(),
      ),
    );

    // Localization
    _i.registerLazySingleton<S>(() => S(storage: _i()));

    // Theme
    _i.registerLazySingleton<AppThemeProvider>(
      () => AppThemeProvider(storage: _i()),
    );

    // Repositories
    _i.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remote: _i(), local: _i()),
    );

    // UseCases
    _i.registerLazySingleton<AuthLoginUser>(() => AuthLoginUser(repo: _i()));
    _i.registerLazySingleton<AuthRefreshToken>(
      () => AuthRefreshToken(repo: _i()),
    );
    _i.registerLazySingleton<AuthCheckStatus>(
      () => AuthCheckStatus(repo: _i()),
    );
    _i.registerLazySingleton<AuthLogoutUser>(() => AuthLogoutUser(repo: _i()));

    // Auth Coordinator
    _i.registerLazySingleton<SessionScopeController>(
      () => UserSessionController(
        init: DI.initUserScope,
        dispose: DI.disposeUserScope,
      ),
    );
    _i.registerLazySingleton<AuthSessionCoordinator>(
      () => AuthSessionCoordinator(
        checkAuthStatus: _i(),
        loginUser: _i(),
        logoutUser: _i(),
        refreshToken: _i(),
        sessionScopeController: _i(),
      ),
    );

    // Auth Cubit
    _i.registerLazySingleton<AuthCubit>(() => AuthCubit(coordinator: _i()));

    // App Router
    _i.registerLazySingleton<AppRouter>(
      () => AppRouter(
        dependencies: AppRouterDependencies(
          authCubit: _i(),
          createDashboardBloc: () => _i(),
        ),
      ),
    );
  }

  static Future<void> initUserScope() async {
    if (_i.hasScope(_userScopeName)) {
      return;
    }

    String dioClientName = 'UserDioClientImpl';

    _i.pushNewScope(scopeName: _userScopeName);

    // Helper
    UserDioHelper httpHelper = UserDioHelper();
    await httpHelper.init();

    // Dio
    Dio dio = Dio(httpHelper.options)
      ..interceptors.addAll([
        ApiInterceptor(apiKey: httpHelper.apiKey),
        LoggingInterceptor(),
      ]);

    _i.registerLazySingleton<BaseHttpClient>(
      () => DioClientImpl(dio: dio),
      instanceName: dioClientName,
    );

    // Remote DataSources
    _i.registerLazySingleton<DashboardCryptocurrencyDataSource>(
      () => DashboardCryptocurrencyDatasourceImpl(
        client: _i.get(instanceName: dioClientName),
      ),
    );

    // Local DataSources
    _i.registerLazySingleton<DashboardLocalDatasource>(
      () => DashboardLocalDatasourceImpl(preferencesStorage: _i()),
    );

    // Repositories
    _i.registerLazySingleton<DashboardCryptocurrencyRepository>(
      () => DashboardCryptocurrencyRepositoryImpl(remote: _i()),
    );
    _i.registerLazySingleton<DashboardLocalRepository>(
      () => DashboardLocalRepositoryImpl(local: _i()),
    );

    // Init UseCases
    _i.registerLazySingleton<DashboardGetCryptocurrency>(
      () => DashboardGetCryptocurrency(repo: _i()),
    );
    _i.registerLazySingleton<DashboardGetUserImage>(
      () => DashboardGetUserImage(repo: _i()),
    );

    // Init Bloc
    _i.registerFactory<DashboardBloc>(
      () => DashboardBloc(getCryptocurrency: _i(), getUserImage: _i()),
    );
  }

  static Future<void> disposeUserScope() async {
    if (!_i.hasScope(_userScopeName)) {
      return;
    }

    if (_i.currentScopeName == _userScopeName) {
      await _i.popScope();
      return;
    }

    await _i.dropScope(_userScopeName);
  }
}
