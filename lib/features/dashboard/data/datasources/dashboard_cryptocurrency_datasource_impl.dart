import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/network/http_client/base_http_client.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/dashboard_cryptocurrency_datasource.dart';
import 'package:pet_crypto/features/dashboard/data/models/dashboard_cryptocurrency_request_model.dart';
import 'package:pet_crypto/features/dashboard/data/models/dashboard_cryptocurrency_response_model.dart';

class DashboardCryptocurrencyDatasourceImpl
    implements DashboardCryptocurrencyDataSource {
  final BaseHttpClient client;

  const DashboardCryptocurrencyDatasourceImpl({required this.client});

  @override
  Future<DashboardCryptocurrencyResponseModel> fetchCryptoCurrency({
    DashboardCryptocurrencyRequestModel? request,
  }) async {
    final (status, body) = await client.get(
      '/v1/cryptocurrency/listings/latest',
      queryParameters: {
        'start': '${request?.start}',
        'limit': '${request?.limit}',
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
}
