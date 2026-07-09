import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency_request.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/dashboard_cryptocurrency_repository.dart';

class DashboardGetCryptocurrency {
  final DashboardCryptocurrencyRepository repo;

  const DashboardGetCryptocurrency({required this.repo});

  Future<Result<List<DashboardCryptocurrency>>> call({
    DashboardCryptocurrencyRequest? request,
  }) async {
    return await repo.getCryptocurrency(request: request);
  }
}
