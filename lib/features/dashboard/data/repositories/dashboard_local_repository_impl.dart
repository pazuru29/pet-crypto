import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/dashboard_local_repository.dart';
import 'package:pet_crypto/features/user/data/datasources/user_reader_local_datasource.dart';

class DashboardLocalRepositoryImpl implements DashboardLocalRepository {
  final UserReaderLocalDatasource local;

  DashboardLocalRepositoryImpl({required this.local});

  @override
  Result<String?> getUserImage() {
    try {
      String? userImage = local.fetchUserImage();
      return Ok(userImage);
    } catch (e) {
      return Err(UnexpectedFailure(e.toString()));
    }
  }
}
