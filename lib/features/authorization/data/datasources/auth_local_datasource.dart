import 'package:pet_crypto/features/authorization/data/models/auth_session_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_tokens_model.dart';

abstract interface class AuthLocalDatasource {
  Future<AuthSessionModel?> getSession();

  Future<String?> getRefreshToken();

  Future<String?> getAccessToken();

  Future<void> saveSession(AuthSessionModel session);

  Future<void> saveTokens(AuthTokensModel tokens);

  Future<void> clearSession();
}
