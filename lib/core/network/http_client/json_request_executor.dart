import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/network/util/dio_exception_mapper_extension.dart';
import 'package:pet_crypto/core/network/util/http_request_context.dart';
import 'package:pet_crypto/core/util/typedef.dart';

Future<T> jsonExecute<T>({
  required Logger log,
  required HttpRequestContext context,
  required Future<JSON> Function() request,
  required T Function(JSON json) decode,
}) async {
  JSON json;

  try {
    final result = await request();
    json = result;
  } on AppException {
    rethrow;
  } on DioException catch (e) {
    final mappedException = e.map(context);
    Error.throwWithStackTrace(mappedException, e.stackTrace);
  }

  try {
    return decode(json);
  } on AppException {
    rethrow;
  } catch (e, s) {
    log.severe('Error', e, s);
    Error.throwWithStackTrace(
      ParsingException(
        technicalMessage: 'Failed to decode JSON response',
        cause: e,
      ),
      s,
    );
  }
}
