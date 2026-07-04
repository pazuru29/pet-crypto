import 'package:pet_crypto/core/network/errors/errors.dart';

sealed class Result<T> {
  const Result();
}

class Ok<T> extends Result<T> {
  final T value;

  const Ok(this.value);
}

class Err<T> extends Result<T> {
  final Failure failure;

  const Err(this.failure);
}
