import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/profile/domain/repositories/profile_repository.dart';
import 'package:pet_crypto/features/user/domain/entities/user_data.dart';

class ProfileGetData {
  final ProfileRepository repo;

  const ProfileGetData({required this.repo});

  Result<UserData> call() {
    return repo.getProfileData();
  }
}
