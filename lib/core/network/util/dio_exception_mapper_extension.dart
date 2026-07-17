import 'package:dio/dio.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/network/util/http_request_context.dart';

extension DioExceptionMapperExtension on DioException {
  AppException map(HttpRequestContext context) {
    final nestedError = error;

    if (nestedError is AppException) {
      return nestedError;
    }

    if (type == DioExceptionType.cancel) {
      return UnexpectedException(
        technicalMessage: 'Request was cancelled',
        cause: this,
      );
    }

    final nestedResponse = response;

    if (nestedResponse == null) {
      return NetworkException(technicalMessage: message, cause: this);
    }

    final statusCode = nestedResponse.statusCode;

    if (statusCode == null) {
      return UnexpectedException(
        technicalMessage: 'Unexpected response',
        cause: this,
      );
    }

    final backendMessage =
        _extractBackendMessage(nestedResponse.data) ?? message;

    if (statusCode == 404) {
      return ServerException(
        .notFound,
        technicalMessage: backendMessage,
        cause: this,
      );
    }

    if (statusCode >= 500 && statusCode < 600) {
      return ServerException(
        .serverUnavailable,
        technicalMessage: backendMessage,
        cause: this,
      );
    }

    return switch ((context, statusCode)) {
      (.login, 400 || 401) => AuthorizationException(
        .invalidCredentials,
        technicalMessage: backendMessage,
        cause: this,
      ),
      (.login, 403) => AuthorizationException(
        .accessDenied,
        technicalMessage: backendMessage,
        cause: this,
      ),
      (.currentUser, 400) => RequestException(
        .invalidRequest,
        technicalMessage: backendMessage,
        cause: this,
      ),
      (.currentUser, 401) => AuthorizationException(
        .sessionExpired,
        technicalMessage: backendMessage,
        cause: this,
      ),
      (.currentUser, 403) => AuthorizationException(
        .accessDenied,
        technicalMessage: backendMessage,
        cause: this,
      ),
      (.refreshToken, 400 || 401) => AuthorizationException(
        .sessionExpired,
        technicalMessage: backendMessage,
        cause: this,
      ),
      (.refreshToken, 403) => AuthorizationException(
        .accessDenied,
        technicalMessage: backendMessage,
        cause: this,
      ),
      (.dashboard, 400) => RequestException(
        .invalidRequest,
        technicalMessage: backendMessage,
        cause: this,
      ),
      (.dashboard, 401 || 403) => AuthorizationException(
        .accessDenied,
        technicalMessage: backendMessage,
        cause: this,
      ),
      _ => UnexpectedException(
        technicalMessage: 'Unexpected HTTP status: $statusCode',
        cause: this,
      ),
    };
  }

  String? _extractBackendMessage(Object? data) {
    if (data is! Map) {
      return null;
    }

    final status = data['status'];

    return switch (data) {
      {'message': final String message} => message,
      {'error': final String error} => error,
      _ when status is Map && status['error_message'] is String =>
        status['error_message'] as String,
      _ => null,
    };
  }
}
