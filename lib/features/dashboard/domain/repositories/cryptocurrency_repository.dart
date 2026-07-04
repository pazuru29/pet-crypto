import 'package:pet_crypto/core/network/result/result.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/cryptocurrency.dart';

abstract interface class CryptocurrencyRepository {
  Future<Result<List<Cryptocurrency>>> getCryptocurrency();
}
