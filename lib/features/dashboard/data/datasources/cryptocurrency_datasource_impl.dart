import 'package:logging/logging.dart';
import 'package:pet_crypto/core/network/http_client/base_http_client.dart';
import 'package:pet_crypto/core/network/http_client/json_request_executor.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/cryptocurrency_datasource.dart';
import 'package:pet_crypto/features/dashboard/data/models/crypto_info_response_model.dart';
import 'package:pet_crypto/features/dashboard/data/models/dashboard_cryptocurrency_request_model.dart';
import 'package:pet_crypto/features/dashboard/data/models/dashboard_cryptocurrency_response_model.dart';

class CryptocurrencyDatasourceImpl implements CryptocurrencyDatasource {
  final Logger _log = Logger('CryptocurrencyDatasourceImpl');

  final BaseHttpClient client;

  CryptocurrencyDatasourceImpl({required this.client});

  @override
  Future<DashboardCryptocurrencyResponseModel> fetchCryptoCurrency({
    DashboardCryptocurrencyRequestModel? request,
  }) async {
    return jsonExecute(
      log: _log,
      context: .dashboard,
      request: () => client.get(
        '/v1/cryptocurrency/listings/latest',
        queryParameters: {
          if (request?.start != null) 'start': '${request!.start}',
          if (request?.limit != null) 'limit': '${request!.limit}',
        },
      ),
      decode: DashboardCryptocurrencyResponseModel.fromJson,
    );
  }

  @override
  Future<CryptoInfoResponseModel> fetchCryptoInfo(int id) async {
    return jsonExecute(
      log: _log,
      context: .dashboard,
      request: () =>
          client.get('/v2/cryptocurrency/info', queryParameters: {'id': '$id'}),
      decode: CryptoInfoResponseModel.fromJson,
    );
  }
}
