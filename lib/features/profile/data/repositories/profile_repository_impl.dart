import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/profile/data/datasources/profile_datasource.dart';
import 'package:pet_crypto/features/profile/data/models/profile_data_model.dart';
import 'package:pet_crypto/features/profile/domain/entities/profile_data.dart';
import 'package:pet_crypto/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDatasource local;

  const ProfileRepositoryImpl({required this.local});

  @override
  Future<Result<ProfileData>> getProfileData() async {
    try {
      ProfileDataModel model = await local.fetchProfileData();
      return Ok(model.toEntity());
    } catch (e) {
      return Err(StorageFailure(e.toString()));
    }
  }
}
