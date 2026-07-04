import 'package:pet_crypto/features/dashboard/data/models/cryptocurrency_response_model.dart';

abstract interface class CryptocurrencyDataSource {
  Future<CryptocurrencyResponseModel> fetchCryptoCurrency();
}
