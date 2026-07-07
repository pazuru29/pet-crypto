import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency.dart';

abstract interface class DashboardCryptocurrencyRepository {
  Future<Result<List<DashboardCryptocurrency>>> getCryptocurrency();
}
