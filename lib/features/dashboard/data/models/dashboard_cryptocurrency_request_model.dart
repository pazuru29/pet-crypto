import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency_request.dart';

class DashboardCryptocurrencyRequestModel {
  final int? start;
  final int? limit;

  const DashboardCryptocurrencyRequestModel({this.start, this.limit});

  DashboardCryptocurrencyRequestModel.fromEntity(
    DashboardCryptocurrencyRequest request,
  ) : this(start: request.start, limit: request.limit);
}
