import 'package:pet_crypto/features/user/domain/entities/user_data.dart';

class UserDataModel {
  final String? fullName;
  final String? email;
  final String? image;

  const UserDataModel({
    required this.fullName,
    required this.email,
    required this.image,
  });

  UserDataModel.fromEntity(UserData entity)
    : this(fullName: entity.fullName, email: entity.email, image: entity.image);

  UserData toEntity() =>
      UserData(fullName: fullName, email: email, image: image);
}
