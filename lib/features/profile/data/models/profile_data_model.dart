import 'package:pet_crypto/features/profile/domain/entities/profile_data.dart';

class ProfileDataModel {
  final String? fullName;
  final String? email;
  final String? userImage;

  ProfileDataModel({
    required this.fullName,
    required this.email,
    required this.userImage,
  });

  ProfileData toEntity() =>
      ProfileData(fullName: fullName, email: email, userImage: userImage);
}
