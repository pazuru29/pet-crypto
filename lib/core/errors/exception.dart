import 'package:pet_crypto/core/errors/app_error_code.dart';

sealed class AppException implements Exception {
  final AppErrorCode code;
  final String? technicalMessage;
  final Object? cause;

  const AppException(this.code, {this.technicalMessage, this.cause});

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();

    buffer.write(code.name.toUpperCase());

    if (technicalMessage != null) {
      buffer.writeln();
      buffer.write('Message: $technicalMessage');
    }

    return buffer.toString();
  }
}

class AuthorizationException extends AppException {
  const AuthorizationException(
    super.code, {
    super.technicalMessage,
    super.cause,
  });
}

class ServerException extends AppException {
  const ServerException(super.code, {super.technicalMessage, super.cause});
}

class RequestException extends AppException {
  RequestException(super.code, {super.technicalMessage, super.cause});
}

class NetworkException extends AppException {
  const NetworkException({super.technicalMessage, super.cause})
    : super(.networkUnavailable);
}

class ParsingException extends AppException {
  const ParsingException({super.technicalMessage, super.cause})
    : super(.invalidResponse);
}

class StorageException extends AppException {
  StorageException({super.technicalMessage, super.cause})
    : super(.storageFailure);
}

class ConfigurationException extends AppException {
  const ConfigurationException({super.technicalMessage, super.cause})
    : super(.configuration);
}

class UnexpectedException extends AppException {
  UnexpectedException({super.technicalMessage, super.cause})
    : super(.unexpected);
}
