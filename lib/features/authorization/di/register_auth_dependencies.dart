import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_crypto/core/network/helper/auth_dio_helper.dart';
import 'package:pet_crypto/core/network/http_client/base_http_client.dart';
import 'package:pet_crypto/core/network/http_client/dio_client_impl.dart';
import 'package:pet_crypto/core/network/interceptors/auth_api_interceptor.dart';
import 'package:pet_crypto/core/network/interceptors/logging_interceptor.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_datasource.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_datasource_impl.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_tokens_local_datasource.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_tokens_local_datasource_impl.dart';
import 'package:pet_crypto/features/authorization/data/repositories/auth_repository_impl.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_check_status.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_login_user.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_logout_user.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_refresh_token.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_bloc.dart';

class RegisterAuthDependencies {
  static Future<void> call(GetIt i) async {
    String dioClientName = 'AuthDioClientImpl';

    // Local Datasource
    i.registerLazySingleton<AuthTokensLocalDatasource>(
      () => AuthTokensLocalDatasourceImpl(secureStorage: i()),
    );

    // Helper
    AuthDioHelper httpHelper = AuthDioHelper();
    await httpHelper.init();

    // Dio
    Dio dio = Dio(httpHelper.options)
      ..interceptors.addAll([
        AuthApiInterceptor(
          fetchAccessToken: () =>
              i<AuthTokensLocalDatasource>().fetchAccessToken(),
        ),
        LoggingInterceptor(),
      ]);

    i.registerLazySingleton<BaseHttpClient>(
      () => DioClientImpl(dio: dio),
      instanceName: dioClientName,
    );

    // Remote DataSources
    i.registerLazySingleton<AuthDatasource>(
      () => AuthDatasourceImpl(client: i.get(instanceName: dioClientName)),
    );

    // Repositories
    i.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remote: i(), localTokens: i(), localUser: i()),
    );

    // UseCases
    i.registerLazySingleton<AuthLoginUser>(() => AuthLoginUser(repo: i()));
    i.registerLazySingleton<AuthRefreshToken>(
      () => AuthRefreshToken(repo: i()),
    );
    i.registerLazySingleton<AuthCheckStatus>(() => AuthCheckStatus(repo: i()));
    i.registerLazySingleton<AuthLogoutUser>(() => AuthLogoutUser(repo: i()));

    // Cubit
    i.registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        authStatus: i(),
        loginUser: i(),
        logoutUser: i(),
        refreshToken: i(),
      ),
    );
  }
}
