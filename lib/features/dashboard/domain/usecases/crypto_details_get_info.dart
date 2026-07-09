import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/crypto_info.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/crypto_details_cryptocurrency_repository.dart';

class CryptoDetailsGetInfo {
  final CryptoDetailsCryptocurrencyRepository repo;

  const CryptoDetailsGetInfo({required this.repo});

  Future<Result<CryptoInfo>> call({String? idString}) async {
    if (idString == null) {
      return Err(RequestFailure('Missing required parameter "id"'));
    }

    int? id = int.tryParse(idString);

    if (id == null) {
      return Err(RequestFailure('Parameter "id" must be integer'));
    }

    return await repo.fetchCryptoInfo(id);
  }
}
