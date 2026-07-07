import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/profile/domain/entities/profile_data.dart';

abstract interface class ProfileRepository {
  Future<Result<ProfileData>> getProfileData();
}
