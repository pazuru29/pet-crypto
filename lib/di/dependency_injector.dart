import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_crypto/core/network/http_client/auth_dio_helper.dart';
import 'package:pet_crypto/core/network/http_client/base_http_client.dart';
import 'package:pet_crypto/core/network/http_client/dio_client_impl.dart';
import 'package:pet_crypto/core/network/http_client/user_dio_helper.dart';
import 'package:pet_crypto/core/network/interceptors/api_interceptor.dart';
import 'package:pet_crypto/core/network/interceptors/logging_interceptor.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_datasource.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_datasource_impl.dart';
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

final GetIt _i = GetIt.instance;

class DI {
  DI._();

  static T get<T extends Object>({String? instanceName}) =>
      _i<T>(instanceName: instanceName);

  static Future<void> reset() async {
    return await _i.reset(dispose: true);
  }

  static Future<void> init() async {
    // Init Helper
    AuthDioHelper httpHelper = AuthDioHelper();
    await httpHelper.init();

    // Create Dio
    Dio dio = Dio(httpHelper.options)
      ..interceptors.addAll([LoggingInterceptor()]);

    _i.registerLazySingleton<BaseHttpClient>(() => DioClientImpl(dio: dio));
    _i.registerLazySingleton<AuthDatasource>(
      () => AuthDatasourceImpl(client: _i()),
    );
    _i.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remote: _i()),
    );
    _i.registerLazySingleton<LoginUser>(() => LoginUser(repo: _i()));
    _i.registerLazySingleton<RefreshToken>(() => RefreshToken(repo: _i()));
    _i.registerLazySingleton<CheckAuthStatus>(() => CheckAuthStatus());
    _i.registerLazySingleton<LogoutUser>(() => LogoutUser());

    _i.registerLazySingleton<AuthCubit>(
      () => AuthCubit(
        authStatus: _i(),
        loginUser: _i(),
        logoutUser: _i(),
        refreshToken: _i(),
      ),
    );
  }

  static Future<void> initUserScope() async {
    _i.pushNewScope();
    // Init Helper
    UserDioHelper httpHelper = UserDioHelper();
    await httpHelper.init();

    // Create Dio
    Dio dio = Dio(httpHelper.options)
      ..interceptors.addAll([
        ApiInterceptor(apiKey: httpHelper.apiKey),
        LoggingInterceptor(),
      ]);

    _i.registerLazySingleton<BaseHttpClient>(() => DioClientImpl(dio: dio));
    _i.registerLazySingleton<CryptocurrencyDataSource>(
      () => CryptocurrencyDatasourceImpl(client: _i()),
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
    _i.popScope();
  }
}
