import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:pet_crypto/core/network/helper/app_request_headers.dart';

class LoggingInterceptor extends Interceptor {
  final Logger _log = Logger('LoggingInterceptor');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    StringBuffer buffer = StringBuffer();

    buffer.writeln(
      'REQUEST ${options.method.toUpperCase()} ${options.baseUrl.toString() + options.path}',
    );

    buffer.writeln('Headers:');
    options.headers.forEach((k, v) {
      if (k == AppRequestHeaders.dashboardApiKeyHeader ||
          k == HttpHeaders.authorizationHeader) {
        v = '***';
      }
      buffer.writeln('$k: $v');
    });

    buffer.writeln('QueryParams:');
    options.queryParameters.forEach((k, v) {
      buffer.writeln('$k: $v');
    });

    _log.fine(buffer);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _log.fine('RESPONSE ${response.statusCode}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    StringBuffer buffer = StringBuffer();

    buffer.writeln('STATUS CODE: ${err.response?.statusCode}');
    buffer.writeln('MESSAGE (${err.type.name}):');
    buffer.write(err.message);

    _log.fine(buffer);
    super.onError(err, handler);
  }
}
