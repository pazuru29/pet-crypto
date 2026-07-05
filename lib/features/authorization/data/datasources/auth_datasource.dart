import 'package:pet_crypto/features/authorization/data/models/auth_refresh_request_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_refresh_response_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_request_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_response_model.dart';

abstract interface class AuthDatasource {
  Future<AuthResponseModel> login(AuthRequestModel request);

  Future<AuthRefreshResponseModel> refreshToken(
    AuthRefreshRequestModel request,
  );
}
