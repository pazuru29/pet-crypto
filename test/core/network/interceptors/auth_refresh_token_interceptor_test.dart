import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/network/interceptors/auth_refresh_token_interceptor.dart';
import 'package:pet_crypto/core/network/result/refresh_token_result.dart';

class MockHttpClientAdapter extends Mock implements HttpClientAdapter {}

abstract interface class AuthInterceptorDependencies {
  Future<String?> fetchAccessToken();

  Future<RefreshTokenResult> refreshTokens();

  Future<void> onSessionExpired();
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
  late AuthInterceptorDependencies dependencies;
  late Dio dio;
  late Completer<void> refreshStarted;
  late Completer<RefreshTokenResult> finishRefresh;
  late int refreshCalls;

  setUpAll(() {
    registerFallbackValue(RequestOptions());
  });

  setUp(() {
    adapter = MockHttpClientAdapter();
    dependencies = MockAuthInterceptorDependencies();

    dio = Dio()..httpClientAdapter = adapter;

    dio.interceptors.add(
      AuthRefreshTokenInterceptor(
        dio: dio,
        fetchAccessToken: dependencies.fetchAccessToken,
        refreshTokens: dependencies.refreshTokens,
        onSessionExpired: dependencies.onSessionExpired,
      ),
    );

    refreshStarted = Completer<void>();
    finishRefresh = Completer<RefreshTokenResult>();
    refreshCalls = 0;

    when(dependencies.refreshTokens).thenAnswer((_) {
      refreshCalls++;

      if (!refreshStarted.isCompleted) {
        refreshStarted.complete();
      }

      return finishRefresh.future;
    });

    when(dependencies.onSessionExpired).thenAnswer((_) async {});
  });

  tearDown(() {
    dio.close(force: true);
  });

  group('Class AuthRefreshTokenInterceptor', () {
    group('successful onError', () {
      late int initialTokenReadCount;
      late int oldTokenRequests;
      late int newTokenRequests;

      setUp(() {
        initialTokenReadCount = 0;
        oldTokenRequests = 0;
        newTokenRequests = 0;

        when(() => adapter.fetch(any(), any(), any())).thenAnswer((
          answer,
        ) async {
          final options = answer.positionalArguments.first as RequestOptions;

          final authorization =
              options.headers[HttpHeaders.authorizationHeader];

          if (authorization == 'Bearer old-token') {
            oldTokenRequests++;
            return response(401);
          }

          if (authorization == 'Bearer new-token') {
            newTokenRequests++;
            return response(200);
          }

          return response(401);
        });
      });

      test(
        'concurrent 401 responses call only one refresh and wait refreshFuture',
        () async {
          final allRequestsReadOldToken = Completer<void>();

          when(dependencies.fetchAccessToken).thenAnswer((_) async {
            if (initialTokenReadCount < 3) {
              initialTokenReadCount++;

              if (initialTokenReadCount == 3 &&
                  !allRequestsReadOldToken.isCompleted) {
                allRequestsReadOldToken.complete();
              }

              return 'old-token';
            }

            return 'new-token';
          });

          final requests = List.generate(
            3,
            (index) => dio.get(
              '/$index',
              options: Options(
                headers: {HttpHeaders.authorizationHeader: 'Bearer old-token'},
              ),
            ),
          );

          await Future.wait([
            allRequestsReadOldToken.future,
            refreshStarted.future,
          ]);

          expect(initialTokenReadCount, 3);
          expect(refreshCalls, 1);
          expect(finishRefresh.isCompleted, isFalse);

          finishRefresh.complete(RefreshTokenResult.refreshed);

          final responses = await Future.wait(requests);

          expect(responses.map((e) => e.statusCode), everyElement(200));
          expect(oldTokenRequests, 3);
          expect(newTokenRequests, 3);
          verify(dependencies.refreshTokens).called(1);
          verifyNever(dependencies.onSessionExpired);
        },
      );

      test(
        'concurrent 401 responses call only one refresh and others use already refreshed token',
        () async {
          int requestsWaitingForRefresh = 0;
          final allOtherRequestsWaitingForRefresh = Completer<void>();
          final firstRequestsReadOldToken = Completer<void>();

          when(dependencies.fetchAccessToken).thenAnswer((_) async {
            if (initialTokenReadCount < 1) {
              initialTokenReadCount++;

              if (!firstRequestsReadOldToken.isCompleted) {
                firstRequestsReadOldToken.complete();
              }

              return 'old-token';
            }

            if (!finishRefresh.isCompleted) {
              requestsWaitingForRefresh++;

              if (requestsWaitingForRefresh == 2 &&
                  !allOtherRequestsWaitingForRefresh.isCompleted) {
                allOtherRequestsWaitingForRefresh.complete();
              }

              await finishRefresh.future;
            }

            return 'new-token';
          });

          final requests = List.generate(
            3,
            (index) => dio.get(
              '/$index',
              options: Options(
                headers: {HttpHeaders.authorizationHeader: 'Bearer old-token'},
              ),
            ),
          );

          await Future.wait([
            firstRequestsReadOldToken.future,
            refreshStarted.future,
            allOtherRequestsWaitingForRefresh.future,
          ]);

          expect(requestsWaitingForRefresh, 2);
          expect(initialTokenReadCount, 1);
          expect(refreshCalls, 1);
          expect(finishRefresh.isCompleted, isFalse);

          finishRefresh.complete(RefreshTokenResult.refreshed);

          final responses = await Future.wait(requests);

          expect(responses.map((e) => e.statusCode), everyElement(200));
          expect(oldTokenRequests, 3);
          expect(newTokenRequests, 3);
          verify(dependencies.refreshTokens).called(1);
          verifyNever(dependencies.onSessionExpired);
        },
      );
    });

    group('failed onError', () {
      test(
        'retry should return 401 status code, then call onSessionExpired, and return error',
        () async {
          when(
            () => adapter.fetch(any(), any(), any()),
          ).thenAnswer((_) async => response(401));

          when(
            dependencies.fetchAccessToken,
          ).thenAnswer((_) async => 'new-token');

          final call = dio.get(
            '/1',
            options: Options(
              headers: {HttpHeaders.authorizationHeader: 'Bearer old-token'},
            ),
          );

          await expectLater(
            call,
            throwsA(
              isA<DioException>().having(
                (error) => error.response?.statusCode,
                'status code',
                HttpStatus.unauthorized,
              ),
            ),
          );
          verify(() => adapter.fetch(any(), any(), any())).called(2);
          verify((dependencies.fetchAccessToken)).called(2);
          verify((dependencies.onSessionExpired)).called(1);
          verifyNever((dependencies.refreshTokens));
        },
      );

      test(
        'concurrent 401 retry responses call only one onSessionExpired and return error',
        () async {
          final allAdapterCallsStarted = Completer<void>();
          final expirationStarted = Completer<void>();
          final finishExpiration = Completer<void>();

          var dioCallCount = 0;

          when(dependencies.onSessionExpired).thenAnswer((_) {
            if (!expirationStarted.isCompleted) {
              expirationStarted.complete();
            }

            return finishExpiration.future;
          });

          when(() => adapter.fetch(any(), any(), any())).thenAnswer((_) async {
            dioCallCount++;

            if (dioCallCount == 6) {
              allAdapterCallsStarted.complete();
            }

            return response(401);
          });

          when(
            dependencies.fetchAccessToken,
          ).thenAnswer((_) async => 'new-token');

          final requests = List.generate(
            3,
            (index) => dio.get(
              '/$index',
              options: Options(
                headers: {HttpHeaders.authorizationHeader: 'Bearer old-token'},
              ),
            ),
          );

          final expectations = requests
              .map(
                (request) => expectLater(
                  request,
                  throwsA(
                    isA<DioException>().having(
                      (error) => error.response?.statusCode,
                      'status code',
                      HttpStatus.unauthorized,
                    ),
                  ),
                ),
              )
              .toList();

          await expirationStarted.future;
          await allAdapterCallsStarted.future;
          await Future<void>.delayed(Duration.zero);
          finishExpiration.complete();

          await Future.wait(expectations);

          verify(() => adapter.fetch(any(), any(), any())).called(6);
          verify((dependencies.fetchAccessToken)).called(6);
          verify((dependencies.onSessionExpired)).called(1);
          verifyNever((dependencies.refreshTokens));
        },
      );

      test('retry should return 500 status code and return error', () async {
        var initialCallCount = 0;

        when(() => adapter.fetch(any(), any(), any())).thenAnswer((_) async {
          if (initialCallCount < 1) {
            initialCallCount++;
            return response(401);
          }

          return response(500);
        });

        when(
          dependencies.fetchAccessToken,
        ).thenAnswer((_) async => 'new-token');

        final call = dio.get(
          '/1',
          options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer old-token'},
          ),
        );

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
        verify(() => adapter.fetch(any(), any(), any())).called(2);
        verify((dependencies.fetchAccessToken)).called(2);
        verifyNever((dependencies.onSessionExpired));
        verifyNever((dependencies.refreshTokens));
      });

      test(
        'refresh token should return rejected status, then call onSessionExpired, and return error',
        () async {
          when(
            () => adapter.fetch(any(), any(), any()),
          ).thenAnswer((_) async => response(401));

          when(
            dependencies.fetchAccessToken,
          ).thenAnswer((_) async => 'old-token');

          final call = dio.get(
            '/1',
            options: Options(
              headers: {HttpHeaders.authorizationHeader: 'Bearer old-token'},
            ),
          );

          await refreshStarted.future;

          finishRefresh.complete(.rejected);

          await expectLater(
            call,
            throwsA(
              isA<DioException>().having(
                (error) => error.response?.statusCode,
                'status code',
                HttpStatus.unauthorized,
              ),
            ),
          );
          verify(() => adapter.fetch(any(), any(), any())).called(1);
          verify((dependencies.refreshTokens)).called(1);
          verify((dependencies.fetchAccessToken)).called(1);
          verify((dependencies.onSessionExpired)).called(1);
        },
      );

      test(
        'refresh token should return temporaryFailure status and return error',
        () async {
          when(
            () => adapter.fetch(any(), any(), any()),
          ).thenAnswer((_) async => response(401));

          when(
            dependencies.fetchAccessToken,
          ).thenAnswer((_) async => 'old-token');

          final call = dio.get(
            '/1',
            options: Options(
              headers: {HttpHeaders.authorizationHeader: 'Bearer old-token'},
            ),
          );

          await refreshStarted.future;

          finishRefresh.complete(.temporaryFailure);

          await expectLater(
            call,
            throwsA(
              isA<DioException>().having(
                (error) => error.response?.statusCode,
                'status code',
                HttpStatus.unauthorized,
              ),
            ),
          );
          verify(() => adapter.fetch(any(), any(), any())).called(1);
          verify((dependencies.refreshTokens)).called(1);
          verify((dependencies.fetchAccessToken)).called(1);
          verifyNever((dependencies.onSessionExpired));
        },
      );

      final tokenCases = <String, String?>{'null': null, 'empty': ''};
      for (final tokenCase in tokenCases.entries) {
        test(
          'refreshed token is ${tokenCase.key}, expires session and returns error',
          () async {
            var initialCallCount = 0;

            when(
              () => adapter.fetch(any(), any(), any()),
            ).thenAnswer((_) async => response(401));

            when(dependencies.fetchAccessToken).thenAnswer((_) async {
              if (initialCallCount == 0) {
                initialCallCount++;
                return 'old-token';
              }

              return tokenCase.value;
            });

            final call = dio.get(
              '/1',
              options: Options(
                headers: {HttpHeaders.authorizationHeader: 'Bearer old-token'},
              ),
            );

            await refreshStarted.future;

            finishRefresh.complete(.refreshed);

            await expectLater(
              call,
              throwsA(
                isA<DioException>().having(
                  (error) => error.response?.statusCode,
                  'status code',
                  HttpStatus.unauthorized,
                ),
              ),
            );

            verify(() => adapter.fetch(any(), any(), any())).called(1);
            verify((dependencies.onSessionExpired)).called(1);
            verify((dependencies.refreshTokens)).called(1);
            verify((dependencies.fetchAccessToken)).called(2);
          },
        );
      }

      test('should return 500 status code', () async {
        when(
          () => adapter.fetch(any(), any(), any()),
        ).thenAnswer((_) async => response(500));

        final call = dio.get(
          '/1',
          options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer old-token'},
          ),
        );

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
        verify(() => adapter.fetch(any(), any(), any())).called(1);
        verifyNever((dependencies.onSessionExpired));
        verifyNever((dependencies.refreshTokens));
        verifyNever((dependencies.fetchAccessToken));
      });

      test('call without auth token should return 401 status code', () async {
        when(
          () => adapter.fetch(any(), any(), any()),
        ).thenAnswer((_) async => response(401));

        final call = dio.get('/1');

        await expectLater(
          call,
          throwsA(
            isA<DioException>().having(
              (error) => error.response?.statusCode,
              'status code',
              HttpStatus.unauthorized,
            ),
          ),
        );
        verify(() => adapter.fetch(any(), any(), any())).called(1);
        verifyNever((dependencies.onSessionExpired));
        verifyNever((dependencies.refreshTokens));
        verifyNever((dependencies.fetchAccessToken));
      });
    });
  });
}
