import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/profile/domain/entities/profile_data.dart';
import 'package:pet_crypto/features/profile/domain/repositories/profile_repository.dart';

class ProfileGetData {
  final ProfileRepository repo;

  const ProfileGetData({required this.repo});

  Future<Result<ProfileData>> call() async {
    return await repo.getProfileData();
  }
}
