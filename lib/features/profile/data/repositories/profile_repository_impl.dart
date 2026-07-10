import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/profile/domain/repositories/profile_repository.dart';
import 'package:pet_crypto/features/user/data/datasources/user_reader_local_datasource.dart';
import 'package:pet_crypto/features/user/data/models/user_data_model.dart';
import 'package:pet_crypto/features/user/domain/entities/user_data.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final UserReaderLocalDatasource local;

  const ProfileRepositoryImpl({required this.local});

  @override
  Result<UserData> getProfileData() {
    try {
      UserDataModel model = local.fetchUserData();
      return Ok(model.toEntity());
    } on StorageException catch (e) {
      return Err(StorageFailure(e.message));
    } catch (e) {
      return Err(UnexpectedFailure(e.toString()));
    }
  }
}
