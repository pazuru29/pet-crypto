import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_crypto/core/network/http_client/base_http_client.dart';
import 'package:pet_crypto/core/network/http_client/dio_client_impl.dart';
import 'package:pet_crypto/core/network/http_client/http_helper.dart';
import 'package:pet_crypto/core/network/interceptors/api_interceptor.dart';
import 'package:pet_crypto/core/network/interceptors/logging_interceptor.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/cryptocurrency_datasource.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/cryptocurrency_datasource_impl.dart';
import 'package:pet_crypto/features/dashboard/data/repositories/cryptocurrency_repository_impl.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/cryptocurrency_repository.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/get_cryptocurrency.dart';

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
    HttpHelper httpHelper = HttpHelper();
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
  }

  void initDashboardData() {
    _i.pushNewScope();
  }
}
