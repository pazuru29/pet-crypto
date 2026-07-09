import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/crypto_info.dart';

abstract interface class CryptoDetailsCryptocurrencyRepository {
  Future<Result<CryptoInfo>> fetchCryptoInfo(int id);
}
