import 'package:logging/logging.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/app_executors.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/dashboard_local_repository.dart';
import 'package:pet_crypto/features/user/data/datasources/user_reader_local_datasource.dart';

class DashboardLocalRepositoryImpl implements DashboardLocalRepository {
  final Logger _log = Logger('DashboardLocalRepositoryImpl');

  final UserReaderLocalDatasource local;

  DashboardLocalRepositoryImpl({required this.local});

  @override
  Result<String?> getUserImage() {
    return executeRepositorySync(_log, () {
      return local.fetchUserImage();
    });
  }
}
