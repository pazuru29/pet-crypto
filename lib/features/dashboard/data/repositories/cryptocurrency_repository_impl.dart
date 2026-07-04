import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/cryptocurrency_datasource.dart';
import 'package:pet_crypto/features/dashboard/data/models/cryptocurrency_response_model.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/cryptocurrency.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/cryptocurrency_repository.dart';

class CryptocurrencyRepositoryImpl implements CryptocurrencyRepository {
  final CryptocurrencyDataSource remote;

  CryptocurrencyRepositoryImpl({required this.remote});

  @override
  Future<Result<List<Cryptocurrency>>> getCryptocurrency() async {
    try {
      CryptocurrencyResponseModel model = await remote.fetchCryptoCurrency();

      if (model.data == null) {
        throw ServerException(
          model.status?.errorMessage ?? 'Something went wrong',
        );
      }

      return Ok(model.data!.map((e) => e.toEntity()).toList());
    } on ServerException {
      return Err(ServerFailure('Server unavailable'));
    } on NetworkException {
      return Err(NetworkFailure('Check your connection'));
    } on ParsingException {
      return Err(ParsingFailure('Failed to parse cryptocurrency data'));
    } catch (e) {
      return Err(NetworkFailure(e.toString()));
    }
  }
}
