import 'package:pet_crypto/features/authorization/data/models/auth_tokens_model.dart';

abstract interface class AuthTokensLocalDatasource {
  Future<AuthTokensModel?> fetchTokens();

  Future<String?> fetchRefreshToken();

  Future<String?> fetchAccessToken();

  Future<void> saveTokens(AuthTokensModel tokens);

  Future<void> clearTokens();
}
