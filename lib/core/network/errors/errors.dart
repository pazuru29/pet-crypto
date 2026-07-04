sealed class Failure {
  final String message;

  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.m);
}

class ServerFailure extends Failure {
  const ServerFailure(super.m);
}