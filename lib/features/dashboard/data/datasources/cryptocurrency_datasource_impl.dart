import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/network/http_client/base_http_client.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/cryptocurrency_datasource.dart';
import 'package:pet_crypto/features/dashboard/data/models/crypto_info_response_model.dart';
import 'package:pet_crypto/features/dashboard/data/models/dashboard_cryptocurrency_request_model.dart';
import 'package:pet_crypto/features/dashboard/data/models/dashboard_cryptocurrency_response_model.dart';

class CryptocurrencyDatasourceImpl implements CryptocurrencyDatasource {
  final BaseHttpClient client;

  const CryptocurrencyDatasourceImpl({required this.client});

  @override
  Future<DashboardCryptocurrencyResponseModel> fetchCryptoCurrency({
    DashboardCryptocurrencyRequestModel? request,
  }) async {
    final (status, body) = await client.get(
      '/v1/cryptocurrency/listings/latest',
      queryParameters: {
        if (request?.start != null) 'start': '${request!.start}',
        if (request?.limit != null) 'limit': '${request!.limit}',
      },
    );

    if (status != 200 || body == null) {
      throw ServerException('Server error: $status');
    }

    try {
      return DashboardCryptocurrencyResponseModel.fromJson(body);
    } catch (e) {
      throw ParsingException(e.toString());
    }
  }

  @override
  Future<CryptoInfoResponseModel> fetchCryptoInfo(int? id) async {
    final (status, body) = await client.get(
      '/v2/cryptocurrency/info',
      queryParameters: {'id': '$id'},
    );

    if (status != 200 || body == null) {
      throw ServerException('Server error: $status');
    }

    try {
      return CryptoInfoResponseModel.fromJson(body);
    } catch (e) {
      print(e.toString());
      throw ParsingException(e.toString());
    }
  }
}
