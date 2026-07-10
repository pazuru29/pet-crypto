import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pet_crypto/core/network/helper/app_request_headers.dart';

class AuthApiInterceptor extends Interceptor {
  final Future<String?> Function() fetchAccessToken;

  const AuthApiInterceptor({required this.fetchAccessToken});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final requiresAuth =
        options.headers.remove(AppRequestHeaders.authRequiresAccessToken) ==
        true;

    if (!requiresAuth) {
      handler.next(options);
      return;
    }

    final accessToken = await fetchAccessToken();

    if (accessToken == null || accessToken.isEmpty) {
      handler.reject(
        DioException(requestOptions: options, error: 'Access token is missing'),
      );
      return;
    }

    options.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';

    super.onRequest(options, handler);
  }
}
