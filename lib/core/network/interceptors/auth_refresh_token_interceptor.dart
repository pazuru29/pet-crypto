import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/network/result/refresh_token_result.dart';

class AuthRefreshTokenInterceptor extends Interceptor {
  static const _retryKey = 'auth.refreshRetried';

  final Dio dio;
  final Future<String?> Function() fetchAccessToken;
  final Future<RefreshTokenResult> Function() refreshTokens;
  final Future<void> Function() onSessionExpired;

  Future<RefreshTokenResult>? _refreshFuture;
  Future<void>? _sessionExpirationFuture;

  AuthRefreshTokenInterceptor({
    required this.dio,
    required this.fetchAccessToken,
    required this.refreshTokens,
    required this.onSessionExpired,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;
    final authorization = request.headers[HttpHeaders.authorizationHeader]
        ?.toString();

    final shouldRefresh =
        err.response?.statusCode == HttpStatus.unauthorized &&
        authorization != null &&
        request.extra[_retryKey] != true;

    if (!shouldRefresh) {
      handler.next(err);
      return;
    }

    try {
      final refreshResult = await _refreshToken(authorization);

      switch (refreshResult) {
        case .rejected:
          await _expireSession();
          handler.next(err);
          return;
        case .temporaryFailure:
          handler.next(err);
          return;
        case .refreshed:
          break;
      }

      final accessToken = await fetchAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        await _expireSession();
        handler.next(err);
        return;
      }

      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
      request.extra[_retryKey] = true;

      final response = await dio.fetch<dynamic>(request);

      handler.resolve(response);
    } on DioException catch (retryError) {
      if (retryError.response?.statusCode == HttpStatus.unauthorized) {
        await _expireSession();
      }
      handler.next(retryError);
    } catch (error, stackTrace) {
      final AppException nestedError;

      if (error is AppException) {
        nestedError = error;
      } else {
        nestedError = UnexpectedException(
          technicalMessage: 'Unexpected error during token refresh',
          cause: error,
        );
      }

      handler.next(
        err.copyWith(
          type: DioExceptionType.unknown,
          error: nestedError,
          stackTrace: stackTrace,
          message: 'Unexpected error during token refresh',
        ),
      );
    }
  }

  Future<RefreshTokenResult> _refreshToken(String failedAuthorization) async {
    final currentToken = await fetchAccessToken();

    if (currentToken != null && failedAuthorization != 'Bearer $currentToken') {
      return .refreshed;
    }

    final activeRefresh = _refreshFuture;

    if (activeRefresh != null) {
      return await activeRefresh;
    }

    final refresh = refreshTokens();
    _refreshFuture = refresh;

    try {
      return await refresh;
    } finally {
      if (identical(_refreshFuture, refresh)) {
        _refreshFuture = null;
      }
    }
  }

  Future<void> _expireSession() async {
    final activeExpiration = _sessionExpirationFuture;

    if (activeExpiration != null) {
      return await activeExpiration;
    }

    final expiration = onSessionExpired();
    _sessionExpirationFuture = expiration;

    try {
      await expiration;
    } finally {
      if (identical(_sessionExpirationFuture, expiration)) {
        _sessionExpirationFuture = null;
      }
    }
  }
}
