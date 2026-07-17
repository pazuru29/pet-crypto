import 'package:pet_crypto/core/errors/app_error_code.dart';

sealed class Failure {
  final AppErrorCode code;
  final String? technicalMessage;

  const Failure(this.code, {this.technicalMessage});

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

class NetworkFailure extends Failure {
  const NetworkFailure(super.code, {super.technicalMessage});
}

class AuthorizationFailure extends Failure {
  const AuthorizationFailure(super.code, {super.technicalMessage});
}

class RemoteFailure extends Failure {
  const RemoteFailure(super.code, {super.technicalMessage});
}

class ParsingFailure extends Failure {
  const ParsingFailure(super.code, {super.technicalMessage});
}

class StorageFailure extends Failure {
  const StorageFailure(super.code, {super.technicalMessage});
}

class RequestFailure extends Failure {
  const RequestFailure(super.code, {super.technicalMessage});
}

class ConfigurationFailure extends Failure {
  const ConfigurationFailure(super.code, {super.technicalMessage});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.code, {super.technicalMessage});
}
