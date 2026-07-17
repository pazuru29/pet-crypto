import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/app_error_code.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/network/helper/app_request_headers.dart';
import 'package:pet_crypto/core/network/interceptors/auth_api_interceptor.dart';

class MockHttpClientAdapter extends Mock implements HttpClientAdapter {}

abstract interface class AuthInterceptorDependencies {
  Future<String?> fetchAccessToken();
}

class MockAuthInterceptorDependencies extends Mock
    implements AuthInterceptorDependencies {}

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
  late AuthInterceptorDependencies dependencies;
  RequestOptions? sentRequest;

  setUpAll(() {
    registerFallbackValue(RequestOptions());
  });

  setUp(() {
    dependencies = MockAuthInterceptorDependencies();
    adapter = MockHttpClientAdapter();

    dio = Dio()..httpClientAdapter = adapter;

    dio.interceptors.add(
      AuthApiInterceptor(fetchAccessToken: dependencies.fetchAccessToken),
    );

    sentRequest = null;

    when(() => adapter.fetch(any(), any(), any())).thenAnswer((answer) async {
      sentRequest = answer.positionalArguments.first as RequestOptions;
      return response(200);
    });
  });

  tearDown(() {
    dio.close(force: true);
  });

  group('Class AuthApiInterceptor', () {
    group('method onRequest', () {
      test('should add auth token', () async {
        when(
          dependencies.fetchAccessToken,
        ).thenAnswer((_) async => 'auth-token');

        final result = await dio.get(
          '/1',
          options: Options(
            headers: {AppRequestHeaders.authRequiresAccessToken: true},
          ),
        );

        expect(result.statusCode, 200);
        expect(
          sentRequest?.headers[HttpHeaders.authorizationHeader],
          'Bearer auth-token',
        );
        expect(
          sentRequest?.headers[AppRequestHeaders.authRequiresAccessToken],
          isNull,
        );
        verify(dependencies.fetchAccessToken).called(1);
        verify(() => adapter.fetch(any(), any(), any())).called(1);
      });

      test('should call request without authorization header', () async {
        final result = await dio.get('/1');

        expect(result.statusCode, 200);
        expect(sentRequest?.headers[HttpHeaders.authorizationHeader], isNull);
        verify(() => adapter.fetch(any(), any(), any())).called(1);
        verifyNever(dependencies.fetchAccessToken);
      });

      const List<String?> tokenCases = [null, ''];
      for (var tokenCase in tokenCases) {
        test('token is "$tokenCase" and should return reject call', () async {
          when(
            dependencies.fetchAccessToken,
          ).thenAnswer((_) async => tokenCase);

          final call = dio.get(
            '/1',
            options: Options(
              headers: {AppRequestHeaders.authRequiresAccessToken: true},
            ),
          );

          await expectLater(
            call,
            throwsA(
              isA<DioException>().having(
                (response) => response.error,
                'is AuthorizationException',
                isA<AuthorizationException>()
                    .having(
                      (exception) => exception.code,
                      'code',
                      AppErrorCode.sessionExpired,
                    )
                    .having(
                      (exception) => exception.technicalMessage,
                      'technicalMessage',
                      'Access token is missing',
                    ),
              ),
            ),
          );
          verifyNever(() => adapter.fetch(any(), any(), any()));
          verify(dependencies.fetchAccessToken).called(1);
        });
      }
    });
  });
}
