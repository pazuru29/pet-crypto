import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/crypto_info.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/crypto_details_cryptocurrency_repository.dart';

class CryptoDetailsGetInfo {
  final CryptoDetailsCryptocurrencyRepository repo;

  const CryptoDetailsGetInfo({required this.repo});

  Future<Result<CryptoInfo>> call({String? idString}) async {
    if (idString == null) {
      return Err(
        RequestFailure(
          .invalidRequest,
          technicalMessage: 'Missing required parameter "id"',
        ),
      );
    }

    int? id = int.tryParse(idString);

    if (id == null || id <= 0) {
      return Err(
        RequestFailure(
          .invalidRequest,
          technicalMessage: 'Parameter "id" must be an integer greater than 0',
        ),
      );
    }

    return repo.fetchCryptoInfo(id);
  }
}
