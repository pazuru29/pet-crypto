import 'package:pet_crypto/features/authorization/domain/entities/auth_session.dart';

class AuthSessionModel {
  final String? fullName;
  final String? email;
  final String? image;

  const AuthSessionModel({
    required this.fullName,
    required this.email,
    required this.image,
  });

  AuthSessionModel.fromEntity(AuthSession response)
    : this(
        fullName: response.fullName,
        email: response.email,
        image: response.image,
      );

  AuthSession toEntity() => AuthSession(
    fullName: fullName ?? '',
    email: email ?? '',
    image: image ?? '',
  );
}
