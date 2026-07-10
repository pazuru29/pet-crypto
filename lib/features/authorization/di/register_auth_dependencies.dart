import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/network/helper/auth_dio_helper.dart';
import 'package:pet_crypto/core/network/http_client/base_http_client.dart';
import 'package:pet_crypto/core/network/http_client/dio_client_impl.dart';
import 'package:pet_crypto/core/network/interceptors/auth_api_interceptor.dart';
import 'package:pet_crypto/core/network/interceptors/auth_refresh_token_interceptor.dart';
import 'package:pet_crypto/core/network/interceptors/logging_interceptor.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_datasource.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_datasource_impl.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_tokens_local_datasource.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_tokens_local_datasource_impl.dart';
import 'package:pet_crypto/features/authorization/data/repositories/auth_repository_impl.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_check_status.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_login_user.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_logout_user.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_bloc.dart';

class RegisterAuthDependencies {
  static Future<void> call(GetIt i) async {
    String dioClientName = 'AuthDioClientImpl';
    String refreshDioClientName = 'AuthRefreshDioClientImpl';

    // Local Datasource
    i.registerLazySingleton<AuthTokensLocalDatasource>(
      () => AuthTokensLocalDatasourceImpl(secureStorage: i()),
    );

    // Helper
    AuthDioHelper httpHelper = AuthDioHelper();
    await httpHelper.init();

    // Dio
    final Dio refreshDio = Dio(httpHelper.options);

    i.registerLazySingleton<BaseHttpClient>(
      () => DioClientImpl(dio: refreshDio),
      instanceName: refreshDioClientName,
    );

    late final Dio authDio;

    authDio = Dio(httpHelper.options);

    authDio.interceptors.addAll([
      AuthApiInterceptor(
        fetchAccessToken: () =>
            i<AuthTokensLocalDatasource>().fetchAccessToken(),
      ),
      AuthRefreshTokenInterceptor(
        dio: authDio,
        fetchAccessToken: () =>
            i<AuthTokensLocalDatasource>().fetchAccessToken(),
        refreshTokens: () async {
          final result = await i<AuthRepository>().refreshToken();

          return switch (result) {
            Ok() => .refreshed,
            Err(failure: final error) =>
              error is AuthorizationFailure ? .rejected : .temporaryFailure,
          };
        },
        onSessionExpired: () async {
          await i<AuthRepository>().clearSession();
          i<AuthBloc>().add(AuthSessionExpiredEvent());
        },
      ),
      LoggingInterceptor(),
    ]);

    i.registerLazySingleton<BaseHttpClient>(
      () => DioClientImpl(dio: authDio),
      instanceName: dioClientName,
    );

    // Remote DataSources
    i.registerLazySingleton<AuthDatasource>(
      () => AuthDatasourceImpl(
        client: i.get(instanceName: dioClientName),
        refreshClient: i.get(instanceName: refreshDioClientName),
      ),
    );

    // Repositories
    i.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remote: i(), localTokens: i(), localUser: i()),
    );

    // UseCases
    i.registerLazySingleton<AuthLoginUser>(() => AuthLoginUser(repo: i()));
    i.registerLazySingleton<AuthCheckStatus>(() => AuthCheckStatus(repo: i()));
    i.registerLazySingleton<AuthLogoutUser>(() => AuthLogoutUser(repo: i()));

    // Cubit
    i.registerLazySingleton<AuthBloc>(
      () => AuthBloc(authStatus: i(), loginUser: i(), logoutUser: i()),
    );
  }
}
