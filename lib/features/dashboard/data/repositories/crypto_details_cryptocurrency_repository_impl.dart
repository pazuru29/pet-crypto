import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/crypto_details_datasource.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/crypto_info.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/crypto_details_cryptocurrency_repository.dart';

class CryptoDetailsCryptocurrencyRepositoryImpl
    implements CryptoDetailsCryptocurrencyRepository {
  final CryptoDetailsDatasource remote;

  CryptoDetailsCryptocurrencyRepositoryImpl({required this.remote});

  @override
  Future<Result<CryptoInfo>> fetchCryptoInfo(int id) async {
    try {
      final response = await remote.fetchCryptoInfo(id);

      return Ok(response.toEntity());
    } on ServerException {
      return Err(RemoteFailure('Crypto data service unavailable'));
    } on NetworkException {
      return Err(NetworkFailure('Check your connection'));
    } on ParsingException {
      return Err(
        ParsingFailure('Failed to process cryptocurrency detail info'),
      );
    } catch (e) {
      return Err(UnexpectedFailure(e.toString()));
    }
  }
}
