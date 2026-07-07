import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/cryptocurrency.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/cryptocurrency_repository.dart';

class DashboardGetCryptocurrency {
  final CryptocurrencyRepository repo;

  const DashboardGetCryptocurrency({required this.repo});

  Future<Result<List<Cryptocurrency>>> call() {
    return repo.getCryptocurrency();
  }
}
