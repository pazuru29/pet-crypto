import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/network/helper/app_request_headers.dart';
import 'package:pet_crypto/core/network/interceptors/dashboard_api_interceptor.dart';

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
  late RequestOptions sentRequest;

  setUpAll(() {
    registerFallbackValue(RequestOptions());
  });

  setUp(() {
    adapter = MockHttpClientAdapter();

    dio = Dio()..httpClientAdapter = adapter;

    dio.interceptors.add(const DashboardApiInterceptor(apiKey: 'test-api-key'));

    when(() => adapter.fetch(any(), any(), any())).thenAnswer((answer) async {
      sentRequest = answer.positionalArguments.first as RequestOptions;
      return response(200);
    });
  });

  tearDown(() {
    dio.close(force: true);
  });

  group('Class DashboardApiInterceptor', () {
    group('method onRequest', () {
      test('should add apiKey to headers', () async {
        final result = await dio.get('/1');

        expect(result.statusCode, 200);
        expect(
          sentRequest.headers[AppRequestHeaders.dashboardApiKeyHeader],
          'test-api-key',
        );
        verify(() => adapter.fetch(any(), any(), any())).called(1);
      });

      test('should leave custom apiKey', () async {
        final result = await dio.get(
          '/1',
          options: Options(
            headers: {
              AppRequestHeaders.dashboardApiKeyHeader: 'custom-api-key',
            },
          ),
        );

        expect(result.statusCode, 200);
        expect(
          sentRequest.headers[AppRequestHeaders.dashboardApiKeyHeader],
          'custom-api-key',
        );
        verify(() => adapter.fetch(any(), any(), any())).called(1);
      });
    });
  });
}
