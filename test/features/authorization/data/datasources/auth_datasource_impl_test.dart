import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/network/http_client/base_http_client.dart';
import 'package:pet_crypto/core/util/typedef.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_datasource.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_datasource_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_refresh_request_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_refresh_response_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_request_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_response_model.dart';

class MockDioClient extends Mock implements BaseHttpClient {}

class MockDioRefreshClient extends Mock implements BaseHttpClient {}

void main() {
  late MockDioClient mockDioClient;
  late MockDioRefreshClient mockDioRefreshClient;
  late AuthDatasource authDatasource;

  setUp(() {
    mockDioClient = MockDioClient();
    mockDioRefreshClient = MockDioRefreshClient();

    authDatasource = AuthDatasourceImpl(
      client: mockDioClient,
      refreshClient: mockDioRefreshClient,
    );
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class AuthDatasourceImpl', () {
    group('method login', () {
      test('should return AuthResponseModel', () async {
        AuthResponseModel shouldReturn = AuthResponseModel(
          username: 'user',
          accessToken: 'access',
          refreshToken: 'refresh',
        );

        when(
          () => mockDioClient.post<JSON>(any(), body: any(named: 'body')),
        ).thenAnswer((_) => Future(() => shouldReturn.toJson()));

        AuthRequestModel request = AuthRequestModel(
          username: 'username',
          password: 'password',
        );

        AuthResponseModel actualResponse = await authDatasource.login(request);

        expect(actualResponse, isA<AuthResponseModel>());
        expect(actualResponse.username, shouldReturn.username);
        expect(actualResponse.accessToken, shouldReturn.accessToken);
        expect(actualResponse.refreshToken, shouldReturn.refreshToken);
      });

      test('should throw AuthorizationException', () async {
        when(
          () => mockDioClient.post<JSON>(any(), body: any(named: 'body')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            response: Response(
              requestOptions: RequestOptions(),
              statusCode: 401,
            ),
          ),
        );

        AuthRequestModel request = AuthRequestModel(
          username: 'username',
          password: 'password',
        );

        Future<AuthResponseModel> Function(AuthRequestModel) call =
            authDatasource.login;

        expect(call(request), throwsA(isA<AuthorizationException>()));
      });

      test('should throw ParsingException', () async {
        when(
          () => mockDioClient.post<JSON>(any(), body: any(named: 'body')),
        ).thenAnswer((_) => Future(() => {'username': 1}));

        AuthRequestModel request = AuthRequestModel(
          username: 'username',
          password: 'password',
        );

        Future<AuthResponseModel> Function(AuthRequestModel) call =
            authDatasource.login;

        expect(call(request), throwsA(isA<ParsingException>()));
      });
    });

    group('method fetchCurrentUser', () {
      test('should return AuthResponseModel', () async {
        AuthResponseModel shouldReturn = AuthResponseModel(
          username: 'user',
          accessToken: 'access',
          refreshToken: 'refresh',
        );

        when(
          () => mockDioClient.get<JSON>(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) => Future(() => shouldReturn.toJson()));

        AuthResponseModel actualResponse = await authDatasource
            .fetchCurrentUser();

        expect(actualResponse, isA<AuthResponseModel>());
        expect(actualResponse.username, shouldReturn.username);
        expect(actualResponse.accessToken, shouldReturn.accessToken);
        expect(actualResponse.refreshToken, shouldReturn.refreshToken);
      });

      test('should throw AuthorizationException', () async {
        when(
          () => mockDioClient.get<JSON>(any(), headers: any(named: 'headers')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            response: Response(
              requestOptions: RequestOptions(),
              statusCode: 401,
            ),
          ),
        );

        Future<AuthResponseModel> Function() call =
            authDatasource.fetchCurrentUser;

        expect(call(), throwsA(isA<AuthorizationException>()));
      });

      test('should throw ParsingException', () async {
        when(
          () => mockDioClient.get<JSON>(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) => Future(() => {'username': 1}));

        Future<AuthResponseModel> Function() call =
            authDatasource.fetchCurrentUser;

        expect(call(), throwsA(isA<ParsingException>()));
      });
    });

    group('method refreshToken', () {
      test('should return AuthRefreshResponseModel', () async {
        AuthRefreshResponseModel shouldReturn = AuthRefreshResponseModel(
          accessToken: 'new-access',
          refreshToken: 'new-refresh',
        );

        when(
          () =>
              mockDioRefreshClient.post<JSON>(any(), body: any(named: 'body')),
        ).thenAnswer((_) => Future(() => shouldReturn.toJson()));

        AuthRefreshRequestModel request = AuthRefreshRequestModel(
          refreshToken: 'refresh',
        );

        AuthRefreshResponseModel actualResponse = await authDatasource
            .refreshToken(request);

        expect(actualResponse, isA<AuthRefreshResponseModel>());
        expect(actualResponse.accessToken, shouldReturn.accessToken);
        expect(actualResponse.refreshToken, shouldReturn.refreshToken);
      });

      test('should throw AuthorizationException', () async {
        when(
          () =>
              mockDioRefreshClient.post<JSON>(any(), body: any(named: 'body')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            response: Response(
              requestOptions: RequestOptions(),
              statusCode: 401,
            ),
          ),
        );

        AuthRefreshRequestModel request = AuthRefreshRequestModel(
          refreshToken: 'refresh',
        );

        Future<AuthRefreshResponseModel> Function(AuthRefreshRequestModel)
        call = authDatasource.refreshToken;

        expect(call(request), throwsA(isA<AuthorizationException>()));
      });

      test('should throw ParsingException', () async {
        when(
          () =>
              mockDioRefreshClient.post<JSON>(any(), body: any(named: 'body')),
        ).thenAnswer((_) => Future(() => {'accessToken': 1}));

        AuthRefreshRequestModel request = AuthRefreshRequestModel(
          refreshToken: 'refresh',
        );

        Future<AuthRefreshResponseModel> Function(AuthRefreshRequestModel)
        call = authDatasource.refreshToken;

        expect(call(request), throwsA(isA<ParsingException>()));
      });
    });
  });
}
