import 'package:pet_crypto/core/util/required_field.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_tokens.dart';

class AuthTokensModel {
  final String? accessToken;
  final String? refreshToken;

  AuthTokensModel({required this.accessToken, required this.refreshToken});

  AuthTokensModel.fromEntity(AuthTokens entity)
    : this(accessToken: entity.accessToken, refreshToken: entity.refreshToken);

  AuthTokens toEntity() => AuthTokens(
    accessToken: requiredField(accessToken, 'accessToken'),
    refreshToken: requiredField(refreshToken, 'refreshToken'),
  );
}
