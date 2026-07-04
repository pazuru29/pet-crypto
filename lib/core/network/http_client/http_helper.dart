import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class HttpHelper {
  static const int connectTimeout = 10;
  static const int receiveTimeout = 30;
  static const String apiKeyHeader = 'X-CMC_PRO_API_KEY';

  late final String _baseURL;
  late final String _apiKey;
  late final BaseOptions? _options;

  String get baseUrl => _baseURL;

  String get apiKey => _apiKey;

  BaseOptions? get options => _options;

  Future<void> init() async {
    try {
      _baseURL = const String.fromEnvironment('API_URL');
      _apiKey = const String.fromEnvironment('API_KEY');
      Logger('HttpHelper').fine("Base URL: $_baseURL");
      _options = BaseOptions(
        baseUrl: _baseURL,
        connectTimeout: const Duration(seconds: connectTimeout),
        receiveTimeout: const Duration(seconds: receiveTimeout),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
