import 'package:pet_crypto/core/util/typedef.dart';

abstract interface class BaseHttpClient {
  Future<(int? status, JSON? json)> get(
    String path, {
    Map<String, String>? queryParameters,
    JSON? body,
  });

  Future<(int? status, JSON? json)> post(
    String path, {
    Map<String, String>? queryParameters,
    JSON? body,
  });

  Future<(int? status, JSON? json)> put(
    String path, {
    Map<String, String>? queryParameters,
    JSON? body,
  });

  Future<(int? status, JSON? json)> patch(
    String path, {
    Map<String, String>? queryParameters,
    JSON? body,
  });

  Future<(int? status, JSON? json)> delete(
    String path, {
    Map<String, String>? queryParameters,
    JSON? body,
  });
}
