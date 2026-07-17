import 'package:logging/logging.dart';
import 'package:pet_crypto/core/network/helper/app_request_headers.dart';
import 'package:pet_crypto/core/network/http_client/base_http_client.dart';
import 'package:pet_crypto/core/network/http_client/json_request_executor.dart';
import 'package:pet_crypto/core/util/typedef.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_datasource.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_refresh_request_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_refresh_response_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_request_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_response_model.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final Logger _log = Logger('AuthDatasourceImpl');

  final BaseHttpClient client;
  final BaseHttpClient refreshClient;

  AuthDatasourceImpl({required this.client, required this.refreshClient});

  @override
  Future<AuthResponseModel> login(AuthRequestModel request) async {
    return jsonExecute(
      log: _log,
      context: .login,
      request: () => client.post<JSON>('/auth/login', body: request.toJson()),
      decode: AuthResponseModel.fromJson,
    );
  }

  @override
  Future<AuthResponseModel> fetchCurrentUser() async {
    return jsonExecute(
      log: _log,
      context: .currentUser,
      request: () => client.get<JSON>(
        '/auth/me',
        headers: {AppRequestHeaders.authRequiresAccessToken: true},
      ),
      decode: AuthResponseModel.fromJson,
    );
  }

  @override
  Future<AuthRefreshResponseModel> refreshToken(
    AuthRefreshRequestModel request,
  ) async {
    return jsonExecute(
      log: _log,
      context: .refreshToken,
      request: () =>
          refreshClient.post<JSON>('/auth/refresh', body: request.toJson()),
      decode: AuthRefreshResponseModel.fromJson,
    );
  }
}
