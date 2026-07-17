import 'package:dio/dio.dart';
import 'package:pet_crypto/core/errors/exception.dart';

abstract class BaseDioHelper {
  final int connectTimeout = 10;
  final int receiveTimeout = 30;

  BaseOptions get baseOptions => BaseOptions(
    connectTimeout: Duration(seconds: connectTimeout),
    receiveTimeout: Duration(seconds: receiveTimeout),
    headers: {
      Headers.acceptHeader: Headers.jsonContentType,
      Headers.contentTypeHeader: Headers.jsonContentType,
    },
  );

  BaseOptions? get options;

  String get baseUrl;

  Future<void> init();

  String validateRequiredEnvironment(String name, String value) {
    final trimmedValue = value.trim();

    if (trimmedValue.isEmpty) {
      throw ConfigurationException(
        technicalMessage: '$name must be provided via --dart-define',
      );
    }

    return trimmedValue;
  }

  String validateRequiredUrlEnvironment(String name, String value) {
    final trimmedValue = validateRequiredEnvironment(name, value);
    final uri = Uri.tryParse(trimmedValue);

    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      throw ConfigurationException(
        technicalMessage: '$name must be a valid absolute URL',
      );
    }

    return trimmedValue;
  }
}
