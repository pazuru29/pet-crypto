import 'package:logging/logging.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/app_executors.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/dashboard_cryptocurrency_datasource.dart';
import 'package:pet_crypto/features/dashboard/data/models/dashboard_cryptocurrency_request_model.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency_request.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/dashboard_cryptocurrency_repository.dart';

class DashboardCryptocurrencyRepositoryImpl
    implements DashboardCryptocurrencyRepository {
  final Logger _log = Logger('DashboardCryptocurrencyRepositoryImpl');

  final DashboardCryptocurrencyDatasource remote;

  DashboardCryptocurrencyRepositoryImpl({required this.remote});

  @override
  Future<Result<List<DashboardCryptocurrency>>> getCryptocurrency({
    DashboardCryptocurrencyRequest? request,
  }) async {
    return executeRepository(_log, () async {
      DashboardCryptocurrencyRequestModel? model = request == null
          ? null
          : DashboardCryptocurrencyRequestModel.fromEntity(request);

      final response = await remote.fetchCryptoCurrency(request: model);

      return response.toEntities();
    });
  }
}
