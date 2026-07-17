import 'package:logging/logging.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/app_executors.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/crypto_details_datasource.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/crypto_info.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/crypto_details_cryptocurrency_repository.dart';

class CryptoDetailsCryptocurrencyRepositoryImpl
    implements CryptoDetailsCryptocurrencyRepository {
  final Logger _log = Logger('CryptoDetailsCryptocurrencyRepositoryImpl');

  final CryptoDetailsDatasource remote;

  CryptoDetailsCryptocurrencyRepositoryImpl({required this.remote});

  @override
  Future<Result<CryptoInfo>> fetchCryptoInfo(int id) async {
    return executeRepository(_log, () async {
      final response = await remote.fetchCryptoInfo(id);

      return response.toEntity();
    });
  }
}
