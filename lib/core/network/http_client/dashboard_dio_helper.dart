import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:pet_crypto/core/network/http_client/base_dio_helper.dart';

class DashboardDioHelper extends BaseDioHelper {
  static const String apiKeyHeader = 'X-CMC_PRO_API_KEY';

  late final String _baseURL;
  late final String _apiKey;
  late final BaseOptions? _options;

  @override
  String get baseUrl => _baseURL;

  @override
  BaseOptions? get options => _options;

  String get apiKey => _apiKey;

  @override
  Future<void> init() async {
    try {
      _baseURL = const String.fromEnvironment('API_URL');
      _apiKey = const String.fromEnvironment('API_KEY');
      Logger('DashboardDioHelper').fine("Base API URL: $_baseURL");
      _options = baseOptions..baseUrl = _baseURL;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
