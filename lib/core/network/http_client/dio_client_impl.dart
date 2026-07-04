import 'package:dio/dio.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/util/typedef.dart';
import 'base_http_client.dart';

class DioClientImpl implements BaseHttpClient {
  late final Dio dio;

  DioClientImpl({required this.dio});

  @override
  Future<(int?, JSON?)> get(
    String path, {
    Map<String, String>? queryParameters,
    JSON? body,
  }) async {
    return _request(
      () => dio.get(path, data: body, queryParameters: queryParameters),
    );
  }

  @override
  Future<(int?, JSON?)> post(
    String path, {
    Map<String, String>? queryParameters,
    JSON? body,
  }) async {
    return _request(
      () => dio.post(path, data: body, queryParameters: queryParameters),
    );
  }

  @override
  Future<(int?, JSON?)> put(
    String path, {
    Map<String, String>? queryParameters,
    JSON? body,
  }) async {
    return _request(
      () => dio.put(path, data: body, queryParameters: queryParameters),
    );
  }

  @override
  Future<(int?, JSON?)> patch(
    String path, {
    Map<String, String>? queryParameters,
    JSON? body,
  }) async {
    return _request(
      () => dio.patch(path, data: body, queryParameters: queryParameters),
    );
  }

  @override
  Future<(int?, JSON?)> delete(
    String path, {
    Map<String, String>? queryParameters,
    JSON? body,
  }) async {
    return _request(
      () => dio.delete(path, data: body, queryParameters: queryParameters),
    );
  }

  Future<(int?, JSON?)> _request(
    Future<Response<dynamic>> Function() send,
  ) async {
    try {
      final response = await send();
      final data = response.data;

      if (data == null || data is JSON) {
        return (response.statusCode, data as JSON?);
      }

      throw ParsingException('Response body is not a JSON object');
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  AppException _mapDioException(DioException e) {
    switch (e.type) {
      case .connectionTimeout:
      case .sendTimeout:
      case .receiveTimeout:
      case .transformTimeout:
      case .connectionError:
      case .cancel:
      case .unknown:
        return NetworkException(e.message ?? 'Network error');
      case .badCertificate:
      case .badResponse:
        return ServerException('Server error: ${e.response?.statusCode}');
    }
  }
}
