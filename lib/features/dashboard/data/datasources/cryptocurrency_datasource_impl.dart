import 'package:dio/dio.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/network/http_client/base_http_client.dart';
import 'package:pet_crypto/core/util/typedef.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/cryptocurrency_datasource.dart';
import 'package:pet_crypto/features/dashboard/data/models/crypto_info_response_model.dart';
import 'package:pet_crypto/features/dashboard/data/models/dashboard_cryptocurrency_request_model.dart';
import 'package:pet_crypto/features/dashboard/data/models/dashboard_cryptocurrency_response_model.dart';

class CryptocurrencyDatasourceImpl implements CryptocurrencyDatasource {
  final BaseHttpClient client;

  const CryptocurrencyDatasourceImpl({required this.client});

  @override
  Future<DashboardCryptocurrencyResponseModel> fetchCryptoCurrency({
    DashboardCryptocurrencyRequestModel? request,
  }) async {
    (int? statusCode, JSON body) result;

    try {
      result = await client.get(
        '/v1/cryptocurrency/listings/latest',
        queryParameters: {
          if (request?.start != null) 'start': '${request!.start}',
          if (request?.limit != null) 'limit': '${request!.limit}',
        },
      );
    } on DioException catch (e) {
      final error = e.error;
      if (error is AppException) {
        throw error;
      }

      switch (e.response?.statusCode) {
        case 400: //bad request
        case 401: //not authorized
          throw AuthorizationException('Something went wrong');
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
      return DashboardCryptocurrencyResponseModel.fromJson(result.$2);
    } catch (e) {
      throw ParsingException(e.toString());
    }
  }

  @override
  Future<CryptoInfoResponseModel> fetchCryptoInfo(int? id) async {
    (int? statusCode, JSON body) result;

    try {
      result = await client.get(
        '/v2/cryptocurrency/info',
        queryParameters: {'id': '$id'},
      );
    } on DioException catch (e) {
      final error = e.error;
      if (error is AppException) {
        throw error;
      }

      switch (e.response?.statusCode) {
        case 400: //bad request
        case 401: //not authorized
          throw AuthorizationException('Something went wrong');
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
      return CryptoInfoResponseModel.fromJson(result.$2);
    } catch (e) {
      throw ParsingException(e.toString());
    }
  }
}
