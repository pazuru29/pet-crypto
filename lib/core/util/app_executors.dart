import 'package:logging/logging.dart';
import 'package:pet_crypto/core/errors/app_exception_mapper_extension.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';

Future<Result<T>> executeRepository<T>(
  Logger log,
  Future<T> Function() operation,
) async {
  try {
    final response = await operation();
    return Ok<T>(response);
  } on AppException catch (e) {
    final failure = e.map();
    return Err<T>(failure);
  } catch (e, s) {
    log.severe('Unexpected error', e, s);
    return Err<T>(
      UnexpectedFailure(.unexpected, technicalMessage: e.toString()),
    );
  }
}

Result<T> executeRepositorySync<T>(Logger log, T Function() operation) {
  try {
    final response = operation();
    return Ok<T>(response);
  } on AppException catch (e) {
    final failure = e.map();
    return Err<T>(failure);
  } catch (e, s) {
    log.severe('Unexpected error', e, s);
    return Err<T>(
      UnexpectedFailure(.unexpected, technicalMessage: e.toString()),
    );
  }
}
