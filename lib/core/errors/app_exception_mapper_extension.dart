import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/errors/failure.dart';

extension AppExceptionMapperExtension on AppException {
  Failure map() => switch (this) {
    NetworkException() => NetworkFailure(
      code,
      technicalMessage: technicalMessage,
    ),
    AuthorizationException() => AuthorizationFailure(
      code,
      technicalMessage: technicalMessage,
    ),
    ServerException() => RemoteFailure(
      code,
      technicalMessage: technicalMessage,
    ),
    ParsingException() => ParsingFailure(
      code,
      technicalMessage: technicalMessage,
    ),
    StorageException() => StorageFailure(
      code,
      technicalMessage: technicalMessage,
    ),
    RequestException() => RequestFailure(
      code,
      technicalMessage: technicalMessage,
    ),
    ConfigurationException() => ConfigurationFailure(
      code,
      technicalMessage: technicalMessage,
    ),
    UnexpectedException() => UnexpectedFailure(
      code,
      technicalMessage: technicalMessage,
    ),
  };
}
