sealed class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class AuthorizationException extends AppException {
  const AuthorizationException(super.message);
}

class ServerException extends AppException {
  const ServerException(super.message);
}

class ParsingException extends AppException {
  const ParsingException(super.message);
}

class StorageException extends AppException {
  StorageException(super.message);
}

class ConfigurationException extends AppException {
  const ConfigurationException(super.message);
}
