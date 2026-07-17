import 'package:logging/logging.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/app_executors.dart';
import 'package:pet_crypto/features/profile/domain/repositories/profile_repository.dart';
import 'package:pet_crypto/features/user/data/datasources/user_reader_local_datasource.dart';
import 'package:pet_crypto/features/user/data/models/user_data_model.dart';
import 'package:pet_crypto/features/user/domain/entities/user_data.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final Logger _log = Logger('ProfileRepositoryImpl');

  final UserReaderLocalDatasource local;

  ProfileRepositoryImpl({required this.local});

  @override
  Result<UserData> getProfileData() {
    return executeRepositorySync(_log, () {
      UserDataModel model = local.fetchUserData();
      return model.toEntity();
    });
  }
}
