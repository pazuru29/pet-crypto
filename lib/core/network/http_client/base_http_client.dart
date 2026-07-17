import 'package:pet_crypto/core/util/typedef.dart';

abstract interface class BaseHttpClient {
  Future<T> get<T>(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String>? queryParameters,
    JSON? body,
  });

  Future<T> post<T>(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String>? queryParameters,
    JSON? body,
  });

  Future<T> put<T>(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String>? queryParameters,
    JSON? body,
  });

  Future<T> patch<T>(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String>? queryParameters,
    JSON? body,
  });

  Future<T> delete<T>(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String>? queryParameters,
    JSON? body,
  });
}
