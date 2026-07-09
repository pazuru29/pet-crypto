import 'package:pet_crypto/features/dashboard/data/models/dashboard_cryptocurrency_request_model.dart';
import 'package:pet_crypto/features/dashboard/data/models/dashboard_cryptocurrency_response_model.dart';

abstract interface class DashboardCryptocurrencyDatasource {
  Future<DashboardCryptocurrencyResponseModel> fetchCryptoCurrency({
    DashboardCryptocurrencyRequestModel? request,
  });
}
