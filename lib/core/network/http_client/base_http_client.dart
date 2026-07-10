import 'package:pet_crypto/core/util/typedef.dart';

abstract interface class BaseHttpClient {
  Future<(int? status, T data)> get<T>(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String>? queryParameters,
    JSON? body,
  });

  Future<(int? status, T data)> post<T>(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String>? queryParameters,
    JSON? body,
  });

  Future<(int? status, T data)> put<T>(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String>? queryParameters,
    JSON? body,
  });

  Future<(int? status, T data)> patch<T>(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String>? queryParameters,
    JSON? body,
  });

  Future<(int? status, T data)> delete<T>(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String>? queryParameters,
    JSON? body,
  });
}
