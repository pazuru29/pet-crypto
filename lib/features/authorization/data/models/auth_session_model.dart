import 'package:pet_crypto/core/util/required_field.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_session.dart';

class AuthSessionModel {
  final String? accessToken;
  final String? refreshToken;
  final String? fullName;
  final String? email;
  final String? image;

  const AuthSessionModel({
    required this.accessToken,
    required this.refreshToken,
    required this.fullName,
    required this.email,
    required this.image,
  });

  AuthSessionModel.fromEntity(AuthSession response)
    : this(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        fullName: response.fullName,
        email: response.email,
        image: response.image,
      );

  AuthSession toEntity() => AuthSession(
    accessToken: requiredField(accessToken, 'accessToken'),
    refreshToken: requiredField(refreshToken, 'refreshToken'),
    fullName: fullName ?? '',
    email: email ?? '',
    image: image ?? '',
  );
}
