import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_crypto/core/localization/provider/s.dart';
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
import 'package:pet_crypto/core/theme/app_theme_provider.dart';
import 'package:pet_crypto/features/authorization/application/auth_session_coordinator.dart';
import 'package:pet_crypto/core/application/session_scope_controller.dart';
import 'package:pet_crypto/di/user_session_controller.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_datasource.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_datasource_impl.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_local_datasource.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_local_datasource_impl.dart';
import 'package:pet_crypto/features/authorization/data/repositories/auth_repository_impl.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/check_auth_status.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/login_user.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/logout_user.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/refresh_token.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_cubit.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/cryptocurrency_datasource.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/cryptocurrency_datasource_impl.dart';
import 'package:pet_crypto/features/dashboard/data/repositories/cryptocurrency_repository_impl.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/cryptocurrency_repository.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/get_cryptocurrency.dart';
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

    // Init Helper
    AuthDioHelper httpHelper = AuthDioHelper();
    await httpHelper.init();

    // Remote Datasource
    Dio dio = Dio(httpHelper.options)
      ..interceptors.addAll([LoggingInterceptor()]);

    _i.registerLazySingleton<BaseHttpClient>(
      () => DioClientImpl(dio: dio),
      instanceName: dioClientName,
    );
    _i.registerLazySingleton<AuthDatasource>(
      () => AuthDatasourceImpl(client: _i.get(instanceName: dioClientName)),
    );

    // Local Datasource
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

    // Init Localization
    _i.registerLazySingleton<S>(() => S(storage: _i()));

    // Init Theme
    _i.registerLazySingleton<AppThemeProvider>(
      () => AppThemeProvider(storage: _i()),
    );

    // Auth Repository
    _i.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remote: _i(), local: _i()),
    );

    // UseCases
    _i.registerLazySingleton<LoginUser>(() => LoginUser(repo: _i()));
    _i.registerLazySingleton<RefreshToken>(() => RefreshToken(repo: _i()));
    _i.registerLazySingleton<CheckAuthStatus>(
      () => CheckAuthStatus(repo: _i()),
    );
    _i.registerLazySingleton<LogoutUser>(() => LogoutUser(repo: _i()));

    // Auth Coordinator
    _i.registerLazySingleton<SessionScopeController>(
      () => UserSessionController(),
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
  }

  static Future<void> initUserScope() async {
    if (_i.hasScope(_userScopeName)) {
      return;
    }

    String dioClientName = 'UserDioClientImpl';

    _i.pushNewScope(scopeName: _userScopeName);

    // Init Helper
    UserDioHelper httpHelper = UserDioHelper();
    await httpHelper.init();

    // Create Dio
    Dio dio = Dio(httpHelper.options)
      ..interceptors.addAll([
        ApiInterceptor(apiKey: httpHelper.apiKey),
        LoggingInterceptor(),
      ]);

    _i.registerLazySingleton<BaseHttpClient>(
      () => DioClientImpl(dio: dio),
      instanceName: dioClientName,
    );
    _i.registerLazySingleton<CryptocurrencyDataSource>(
      () => CryptocurrencyDatasourceImpl(
        client: _i.get(instanceName: dioClientName),
      ),
    );
    _i.registerLazySingleton<CryptocurrencyRepository>(
      () => CryptocurrencyRepositoryImpl(remote: _i()),
    );
    _i.registerLazySingleton<GetCryptocurrency>(
      () => GetCryptocurrency(repo: _i()),
    );
    _i.registerFactory<DashboardBloc>(() => DashboardBloc(_i()));
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
