import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/dashboard_cryptocurrency_datasource.dart';
import 'package:pet_crypto/features/dashboard/data/models/dashboard_cryptocurrency_request_model.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency_request.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/dashboard_cryptocurrency_repository.dart';

class DashboardCryptocurrencyRepositoryImpl
    implements DashboardCryptocurrencyRepository {
  final DashboardCryptocurrencyDatasource remote;

  const DashboardCryptocurrencyRepositoryImpl({required this.remote});

  @override
  Future<Result<List<DashboardCryptocurrency>>> getCryptocurrency({
    DashboardCryptocurrencyRequest? request,
  }) async {
    try {
      DashboardCryptocurrencyRequestModel? model = request == null
          ? null
          : DashboardCryptocurrencyRequestModel.fromEntity(request);

      final response = await remote.fetchCryptoCurrency(request: model);

      return Ok(response.toEntities());
    } on ServerException {
      return Err(RemoteFailure('Crypto data service unavailable'));
    } on NetworkException {
      return Err(NetworkFailure('Check your connection'));
    } on ParsingException {
      return Err(ParsingFailure('Failed to process cryptocurrency data'));
    } catch (e) {
      return Err(UnexpectedFailure(e.toString()));
    }
  }
}
