import 'package:dio/dio.dart';
import 'package:pet_crypto/core/network/http_client/http_helper.dart';

class ApiInterceptor extends Interceptor {
  final String apiKey;

  ApiInterceptor({required this.apiKey});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.putIfAbsent(HttpHelper.apiKeyHeader, () => apiKey);
    super.onRequest(options, handler);
  }
}
