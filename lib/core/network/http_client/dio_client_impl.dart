import 'package:dio/dio.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/util/typedef.dart';
import 'base_http_client.dart';

class DioClientImpl implements BaseHttpClient {
  late final Dio dio;

  DioClientImpl({required this.dio});

  @override
  Future<(int?, T)> get<T>(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String>? queryParameters,
    JSON? body,
  }) async {
    return _request<T>(
      () => dio.get(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<(int?, T)> post<T>(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String>? queryParameters,
    JSON? body,
  }) async {
    return _request<T>(
      () => dio.post(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<(int?, T)> put<T>(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String>? queryParameters,
    JSON? body,
  }) async {
    return _request<T>(
      () => dio.put(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<(int?, T)> patch<T>(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String>? queryParameters,
    JSON? body,
  }) async {
    return _request<T>(
      () => dio.patch(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<(int?, T)> delete<T>(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String>? queryParameters,
    JSON? body,
  }) async {
    return _request<T>(
      () => dio.delete(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  Future<(int?, T)> _request<T>(
    Future<Response<dynamic>> Function() send,
  ) async {
    final response = await send();
    final data = response.data;

    try {
      return (response.statusCode, data as T);
    } catch (_) {
      throw ParsingException('Response body is not a $T object');
    }
  }
}
