import 'package:dio/dio.dart';
import 'package:pet_crypto/core/network/helper/app_request_headers.dart';

class DashboardApiInterceptor extends Interceptor {
  final String apiKey;

  const DashboardApiInterceptor({required this.apiKey});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.putIfAbsent(
      AppRequestHeaders.dashboardApiKeyHeader,
      () => apiKey,
    );
    super.onRequest(options, handler);
  }
}
