import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:pet_crypto/core/network/http_client/user_dio_helper.dart';
import 'package:pet_crypto/core/util/typedef.dart';

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
      if (k == UserDioHelper.apiKeyHeader) {
        v = '***';
      }
      buffer.writeln('$k: $v');
    });

    buffer.writeln('QueryParams:');
    options.queryParameters.forEach((k, v) {
      buffer.writeln('$k: $v');
    });

    if (options.data != null && options.data is JSON) {
      buffer.writeln('Body:');
      buffer.writeln(jsonEncode(options.data as JSON));
    }

    _log.fine(buffer);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    StringBuffer buffer = StringBuffer();

    buffer.writeln('RESPONSE ${response.statusCode}');

    if (response.data != null && response.data is JSON) {
      buffer.writeln('Body:');
      buffer.write(jsonEncode(response.data as JSON));
    }

    _log.fine(buffer);
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
