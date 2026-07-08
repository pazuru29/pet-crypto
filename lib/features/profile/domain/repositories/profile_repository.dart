import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/user/domain/entities/user_data.dart';

abstract interface class ProfileRepository {
  Result<UserData> getProfileData();
}
