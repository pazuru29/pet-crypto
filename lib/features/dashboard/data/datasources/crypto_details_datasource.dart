import 'package:pet_crypto/features/dashboard/data/models/crypto_info_response_model.dart';

abstract interface class CryptoDetailsDatasource {
  Future<CryptoInfoResponseModel> fetchCryptoInfo(int id);
}
