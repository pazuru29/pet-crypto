import 'package:dio/dio.dart';

import 'dart:async';
import 'dart:io';

class AuthRefreshTokenInterceptor extends Interceptor {
  static const _retryKey = 'auth.refreshRetried';

  final Dio dio;
  final Future<String?> Function() fetchAccessToken;
  final Future<bool> Function() refreshTokens;
  final FutureOr<void> Function() onSessionExpired;

  Future<bool>? _refreshFuture;

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
      final refreshed = await _refreshToken(authorization);

      if (!refreshed) {
        await onSessionExpired();
        handler.next(err);
        return;
      }

      final accessToken = await fetchAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        await onSessionExpired();
        handler.next(err);
        return;
      }

      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
      request.extra[_retryKey] = true;

      final response = await dio.fetch<dynamic>(request);

      handler.resolve(response);
    } on DioException catch (retryError) {
      if (retryError.response?.statusCode == HttpStatus.unauthorized) {
        await onSessionExpired();
      }
      handler.next(retryError);
    } catch (_) {
      await onSessionExpired();
      handler.next(err);
    }
  }

  Future<bool> _refreshToken(String failedAuthorization) async {
    final currentToken = await fetchAccessToken();

    if (currentToken != null && failedAuthorization != 'Bearer $currentToken') {
      return true;
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
}
