import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/network/helper/app_request_headers.dart';
import 'package:pet_crypto/core/network/interceptors/logging_interceptor.dart';

class MockHttpClientAdapter extends Mock implements HttpClientAdapter {}

ResponseBody response(int statusCode) {
  return ResponseBody.fromString(
    '{}',
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

void main() {
  late HttpClientAdapter adapter;
  late Dio dio;
  late Level previousLogLevel;
  late List<LogRecord> records;
  late StreamSubscription<LogRecord> logSubscription;

  setUpAll(() {
    registerFallbackValue(RequestOptions());
  });

  setUp(() {
    adapter = MockHttpClientAdapter();
    records = [];

    previousLogLevel = Logger.root.level;
    Logger.root.level = Level.ALL;
    logSubscription = Logger.root.onRecord
        .where((record) => record.loggerName == 'LoggingInterceptor')
        .listen(records.add);

    dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = adapter
      ..interceptors.add(LoggingInterceptor());
  });

  tearDown(() async {
    dio.close(force: true);
    await logSubscription.cancel();
    Logger.root.level = previousLogLevel;
  });

  group('Class LoggingInterceptor', () {
    group('method onRequest', () {
      test('should mask secret headers', () async {
        when(
          () => adapter.fetch(any(), any(), any()),
        ).thenAnswer((_) async => response(200));

        final result = await dio.get(
          '/1',
          queryParameters: {'limit': 20},
          options: Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer auth-token',
              AppRequestHeaders.dashboardApiKeyHeader: 'api-key',
              'x-client': 'visible-header-value',
            },
          ),
        );

        final log = records.map((record) => record.message.toString()).join();

        expect(result.statusCode, 200);
        expect(log, contains('REQUEST GET https://example.test/1'));
        expect(log, contains('${HttpHeaders.authorizationHeader}: ***'));
        expect(
          log,
          contains('${AppRequestHeaders.dashboardApiKeyHeader}: ***'),
        );
        expect(log, contains('x-client: visible-header-value'));
        expect(log, contains('limit: 20'));
        expect(log, isNot(contains('auth-token')));
        expect(log, isNot(contains('api-key')));
        verify(() => adapter.fetch(any(), any(), any())).called(1);
      });
    });

    group('method onResponse', () {
      test('should log status code', () async {
        when(
          () => adapter.fetch(any(), any(), any()),
        ).thenAnswer((_) async => response(200));

        final result = await dio.get('/1');
        final log = records.map((record) => record.message.toString()).join();

        expect(result.statusCode, 200);
        expect(log, contains('RESPONSE 200'));
        verify(() => adapter.fetch(any(), any(), any())).called(1);
      });
    });

    group('method onError', () {
      test('should log status code, error type', () async {
        when(
          () => adapter.fetch(any(), any(), any()),
        ).thenAnswer((_) async => response(500));

        final call = dio.get('/1');

        await expectLater(
          call,
          throwsA(
            isA<DioException>().having(
              (error) => error.response?.statusCode,
              'status code',
              HttpStatus.internalServerError,
            ),
          ),
        );

        final log = records.map((record) => record.message.toString()).join();

        expect(log, contains('STATUS CODE: 500'));
        expect(log, contains('MESSAGE (badResponse):'));
        verify(() => adapter.fetch(any(), any(), any())).called(1);
      });
    });
  });
}
