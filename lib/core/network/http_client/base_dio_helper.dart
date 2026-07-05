import 'dart:io';

import 'package:dio/dio.dart';

abstract class BaseDioHelper {
  final int connectTimeout = 10;
  final int receiveTimeout = 30;

  BaseOptions get baseOptions => BaseOptions(
    connectTimeout: Duration(seconds: connectTimeout),
    receiveTimeout: Duration(seconds: receiveTimeout),
    headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/json',
    },
  );

  BaseOptions? get options;

  String get baseUrl;

  Future<void> init();
}
