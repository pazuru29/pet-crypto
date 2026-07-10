import 'package:dio/dio.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/network/helper/app_request_headers.dart';
import 'package:pet_crypto/core/network/http_client/base_http_client.dart';
import 'package:pet_crypto/core/util/typedef.dart';
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
    (int? statusCode, JSON body) result;

    try {
      result = await client.post<JSON>('/auth/login', body: request.toJson());
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 400: //bad request
        case 401: //not authorized
          throw AuthorizationException('Incorrect username or password');
        case 403: //forbidden
          throw AuthorizationException('Access Denied');
        case 404: //not found
          throw ServerException('Data not found');
        case int status when status >= 500 && status < 600: //server error
          throw ServerException('Server is unavailable');
        default:
          throw NetworkException('Check your Internet connection');
      }
    } on AppException {
      rethrow;
    } catch (_) {
      throw NetworkException('Check your Internet connection');
    }

    try {
      return AuthResponseModel.fromJson(result.$2);
    } catch (e) {
      throw ParsingException(e.toString());
    }
  }

  @override
  Future<AuthResponseModel> fetchCurrentUser() async {
    (int? statusCode, JSON body) result;

    try {
      result = await client.get<JSON>(
        '/auth/me',
        headers: {AppRequestHeaders.authRequiresAccessToken: true},
      );
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 400: //bad request
        case 401: //not authorized
          throw AuthorizationException('Token expired');
        case 403: //forbidden
          throw AuthorizationException('Access Denied');
        case 404: //not found
          throw ServerException('Data not found');
        case int status when status >= 500 && status < 600: //server error
          throw ServerException('Server is unavailable');
        default:
          throw NetworkException('Check your Internet connection');
      }
    } on AppException {
      rethrow;
    } catch (_) {
      throw NetworkException('Check your Internet connection');
    }

    try {
      return AuthResponseModel.fromJson(result.$2);
    } catch (e) {
      throw ParsingException(e.toString());
    }
  }

  @override
  Future<AuthRefreshResponseModel> refreshToken(
    AuthRefreshRequestModel request,
  ) async {
    (int? statusCode, JSON body) result;

    try {
      result = await refreshClient.post<JSON>(
        '/auth/refresh',
        body: request.toJson(),
      );
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 400: //bad request
        case 401: //not authorized
          throw AuthorizationException('Token expired');
        case 403: //forbidden
          throw AuthorizationException('Access Denied');
        case 404: //not found
          throw ServerException('Data not found');
        case int status when status >= 500 && status < 600: //server error
          throw ServerException('Server is unavailable');
        default:
          throw NetworkException('Check your Internet connection');
      }
    } on AppException {
      rethrow;
    } catch (_) {
      throw NetworkException('Check your Internet connection');
    }

    try {
      return AuthRefreshResponseModel.fromJson(result.$2);
    } catch (e) {
      throw ParsingException(e.toString());
    }
  }
}
