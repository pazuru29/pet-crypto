import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/network/http_client/base_http_client.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/cryptocurrency_datasource.dart';
import 'package:pet_crypto/features/dashboard/data/models/cryptocurrency_response_model.dart';

class CryptocurrencyDatasourceImpl implements CryptocurrencyDataSource {
  final BaseHttpClient client;

  CryptocurrencyDatasourceImpl({required this.client});

  @override
  Future<CryptocurrencyResponseModel> fetchCryptoCurrency() async {
    final (status, body) = await client.get(
      '/v1/cryptocurrency/listings/latest',
    );

    if (status != 200 || body == null) {
      throw ServerException('Server error: $status');
    }

    try {
      return CryptocurrencyResponseModel.fromJson(body);
    } catch (e) {
      throw ParsingException(e.toString());
    }
  }
}
