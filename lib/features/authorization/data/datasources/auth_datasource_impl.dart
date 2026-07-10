import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/network/helper/app_request_headers.dart';
import 'package:pet_crypto/core/network/http_client/base_http_client.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_datasource.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_refresh_request_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_refresh_response_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_request_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_response_model.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final BaseHttpClient client;
  final BaseHttpClient refreshClient;

  AuthDatasourceImpl({required this.client, required this.refreshClient});

  @override
  Future<AuthResponseModel> login(AuthRequestModel request) async {
    final (status, body) = await client.post(
      '/auth/login',
      body: request.toJson(),
    );

    if (status != 200 || body == null) {
      throw ServerException('Server error: $status');
    }

    try {
      return AuthResponseModel.fromJson(body);
    } catch (e) {
      throw ParsingException(e.toString());
    }
  }

  @override
  Future<AuthResponseModel> fetchCurrentUser() async {
    final (status, body) = await client.get(
      '/auth/me',
      headers: {AppRequestHeaders.authRequiresAccessToken: true},
    );

    if (status != 200 || body == null) {
      throw ServerException('Server error: $status');
    }

    try {
      return AuthResponseModel.fromJson(body);
    } catch (e) {
      throw ParsingException(e.toString());
    }
  }

  @override
  Future<AuthRefreshResponseModel> refreshToken(
    AuthRefreshRequestModel request,
  ) async {
    final (status, body) = await refreshClient.post(
      '/auth/refresh',
      body: request.toJson(),
    );

    if (status != 200 || body == null) {
      throw ServerException('Server error: $status');
    }

    try {
      return AuthRefreshResponseModel.fromJson(body);
    } catch (e) {
      throw ParsingException(e.toString());
    }
  }
}
