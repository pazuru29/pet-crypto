import 'package:pet_crypto/core/errors/exception.dart';

T requiredField<T>(T? value, String fieldName) {
  if (value == null) {
    throw ParsingException('Missing required field: $fieldName');
  }

  return value;
}
