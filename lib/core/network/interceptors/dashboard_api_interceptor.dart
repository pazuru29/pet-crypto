import 'package:dio/dio.dart';
import 'package:pet_crypto/core/network/http_client/dashboard_dio_helper.dart';

class DashboardApiInterceptor extends Interceptor {
  final String apiKey;

  const DashboardApiInterceptor({required this.apiKey});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.putIfAbsent(DashboardDioHelper.apiKeyHeader, () => apiKey);
    super.onRequest(options, handler);
  }
}
