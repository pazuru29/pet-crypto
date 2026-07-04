import 'package:pet_crypto/core/util/typedef.dart';

import 'base_http_client.dart';
import 'package:dio/dio.dart';

class DioClientImpl implements BaseHttpClient {
  late final Dio dio;

  DioClientImpl({required this.dio});

  @override
  Future<(int?, JSON?)> get(
    String path, {
    Map<String, String>? queryParameters,
    JSON? body,
  }) async {
    Response response = await dio.get(
      path,
      data: body,
      queryParameters: queryParameters,
    );

    return (response.statusCode, response.data as JSON?);
  }

  @override
  Future<(int?, JSON?)> post(
    String path, {
    Map<String, String>? queryParameters,
    JSON? body,
  }) async {
    Response response = await dio.post(
      path,
      data: body,
      queryParameters: queryParameters,
    );

    return (response.statusCode, response.data as JSON?);
  }

  @override
  Future<(int?, JSON?)> put(
    String path, {
    Map<String, String>? queryParameters,
    JSON? body,
  }) async {
    Response response = await dio.put(
      path,
      data: body,
      queryParameters: queryParameters,
    );

    return (response.statusCode, response.data as JSON?);
  }

  @override
  Future<(int?, JSON?)> patch(
    String path, {
    Map<String, String>? queryParameters,
    JSON? body,
  }) async {
    Response response = await dio.patch(
      path,
      data: body,
      queryParameters: queryParameters,
    );

    return (response.statusCode, response.data as JSON?);
  }

  @override
  Future<(int?, JSON?)> delete(
    String path, {
    Map<String, String>? queryParameters,
    JSON? body,
  }) async {
    Response response = await dio.delete(
      path,
      data: body,
      queryParameters: queryParameters,
    );

    return (response.statusCode, response.data as JSON?);
  }
}
