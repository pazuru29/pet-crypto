import 'package:pet_crypto/features/dashboard/data/models/dashboard_cryptocurrency_response_model.dart';

abstract interface class DashboardCryptocurrencyDataSource {
  Future<DashboardCryptocurrencyResponseModel> fetchCryptoCurrency();
}
