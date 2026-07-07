import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/dashboard_local_repository.dart';

class DashboardGetUserImage {
  final DashboardLocalRepository repo;

  const DashboardGetUserImage({required this.repo});

  Result<String?> call() {
    return repo.getUserImage();
  }
}
