import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_crypto/core/network/http_client/base_http_client.dart';
import 'package:pet_crypto/core/network/http_client/dashboard_dio_helper.dart';
import 'package:pet_crypto/core/network/http_client/dio_client_impl.dart';
import 'package:pet_crypto/core/network/interceptors/dashboard_api_interceptor.dart';
import 'package:pet_crypto/core/network/interceptors/logging_interceptor.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/dashboard_cryptocurrency_datasource.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/dashboard_cryptocurrency_datasource_impl.dart';
import 'package:pet_crypto/features/dashboard/data/repositories/dashboard_cryptocurrency_repository_impl.dart';
import 'package:pet_crypto/features/dashboard/data/repositories/dashboard_local_repository_impl.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/dashboard_cryptocurrency_repository.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/dashboard_local_repository.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/dashboard_get_cryptocurrency.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/dashboard_get_user_image.dart';
import 'package:pet_crypto/features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';

class RegisterDashboardDependencies {
  static Future<void> call(GetIt i) async {
    String dioClientName = 'DashboardDioClientImpl';

    // Helper
    DashboardDioHelper httpHelper = DashboardDioHelper();
    await httpHelper.init();

    // Dio
    Dio dio = Dio(httpHelper.options)
      ..interceptors.addAll([
        DashboardApiInterceptor(apiKey: httpHelper.apiKey),
        LoggingInterceptor(),
      ]);

    i.registerLazySingleton<BaseHttpClient>(
      () => DioClientImpl(dio: dio),
      instanceName: dioClientName,
    );

    // Remote DataSources
    i.registerLazySingleton<DashboardCryptocurrencyDataSource>(
      () => DashboardCryptocurrencyDatasourceImpl(
        client: i.get(instanceName: dioClientName),
      ),
    );

    // Repositories
    i.registerLazySingleton<DashboardCryptocurrencyRepository>(
      () => DashboardCryptocurrencyRepositoryImpl(remote: i()),
    );
    i.registerLazySingleton<DashboardLocalRepository>(
      () => DashboardLocalRepositoryImpl(local: i()),
    );

    // UseCases
    i.registerLazySingleton<DashboardGetCryptocurrency>(
      () => DashboardGetCryptocurrency(repo: i()),
    );
    i.registerLazySingleton<DashboardGetUserImage>(
      () => DashboardGetUserImage(repo: i()),
    );

    // Bloc
    i.registerFactory<DashboardBloc>(
      () => DashboardBloc(getCryptocurrency: i(), getUserImage: i()),
    );
  }
}
