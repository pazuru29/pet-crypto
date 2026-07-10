sealed class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class AuthorizationFailure extends Failure {
  const AuthorizationFailure(super.message);
}

class RemoteFailure extends Failure {
  const RemoteFailure(super.message);
}

class ParsingFailure extends Failure {
  const ParsingFailure(super.message);
}

class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

class RequestFailure extends Failure {
  const RequestFailure(super.message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
