import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/cryptocurrency_datasource.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/cryptocurrency.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/cryptocurrency_repository.dart';

class CryptocurrencyRepositoryImpl implements CryptocurrencyRepository {
  final CryptocurrencyDataSource remote;

  CryptocurrencyRepositoryImpl({required this.remote});

  @override
  Future<Result<List<Cryptocurrency>>> getCryptocurrency() async {
    try {
      final response = await remote.fetchCryptoCurrency();
      return Ok(response.toEntities());
    } on ServerException {
      return Err(RemoteFailure('Crypto data service unavailable'));
    } on NetworkException {
      return Err(NetworkFailure('Check your connection'));
    } on ParsingException {
      return Err(ParsingFailure('Failed to process cryptocurrency data'));
    } catch (e) {
      return Err(UnexpectedFailure(e.toString()));
    }
  }
}
