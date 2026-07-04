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
        throw Exception(model.status?.errorMessage ?? "Something went wrong");
      }

      return Ok(model.data!.map((e) => e.toEntity()).toList());
    } on Exception catch (e) {
      final message = e.toString();
      if (message.contains('Server error')) {
        return Err(ServerFailure('Server unavailable'));
      }
      return Err(NetworkFailure('Check your connection'));
    } catch (e) {
      return Err(NetworkFailure(e.toString()));
    }
  }
}
