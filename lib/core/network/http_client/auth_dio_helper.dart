import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'base_dio_helper.dart';

class AuthDioHelper extends BaseDioHelper {
  late final String _baseURL;
  late final BaseOptions _options;

  @override
  String get baseUrl => _baseURL;

  @override
  BaseOptions get options => _options;

  @override
  Future<void> init() async {
    try {
      _baseURL = const String.fromEnvironment('AUTH_URL');
      Logger('AuthDioHelper').fine("Base URL: $_baseURL");
      _options = baseOptions..baseUrl = _baseURL;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
