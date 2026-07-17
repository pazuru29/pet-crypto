import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/storage/secure_storage.dart';
import 'package:pet_crypto/core/util/app_storage_keys.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_tokens_local_datasource.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_tokens_local_datasource_impl.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_tokens_model.dart';

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  late MockSecureStorage mockSecureStorage;
  late AuthTokensLocalDatasource authTokensLocalDatasource;

  setUp(() {
    mockSecureStorage = MockSecureStorage();
    authTokensLocalDatasource = AuthTokensLocalDatasourceImpl(
      secureStorage: mockSecureStorage,
    );
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class AuthTokensLocalDatasourceImpl', () {
    group('method fetchAccessToken', () {
      test('should return String', () async {
        String shouldReturn = 'access';

        when(
          () => mockSecureStorage.read(AppStorageKeys.accessTokenKey),
        ).thenAnswer((_) => Future(() => shouldReturn));

        String? actualResponse = await authTokensLocalDatasource
            .fetchAccessToken();

        expect(actualResponse, isNotNull);
        expect(actualResponse, shouldReturn);
      });

      test('should return null', () async {
        when(
          () => mockSecureStorage.read(AppStorageKeys.accessTokenKey),
        ).thenAnswer((_) => Future(() => null));

        String? actualResponse = await authTokensLocalDatasource
            .fetchAccessToken();

        expect(actualResponse, isNull);
      });

      test('should throw StorageException', () async {
        when(
          () => mockSecureStorage.read(AppStorageKeys.accessTokenKey),
        ).thenThrow(
          StorageException(technicalMessage: 'Fetch access token exception'),
        );

        Future<String?> Function() actualResponse =
            authTokensLocalDatasource.fetchAccessToken;

        expect(actualResponse(), throwsA(isA<StorageException>()));
      });
    });

    group('method fetchRefreshToken', () {
      test('should return String', () async {
        String shouldReturn = 'refresh';

        when(
          () => mockSecureStorage.read(AppStorageKeys.refreshTokenKey),
        ).thenAnswer((_) => Future(() => shouldReturn));

        String? actualResponse = await authTokensLocalDatasource
            .fetchRefreshToken();

        expect(actualResponse, isNotNull);
        expect(actualResponse, shouldReturn);
      });

      test('should return null', () async {
        when(
          () => mockSecureStorage.read(AppStorageKeys.refreshTokenKey),
        ).thenAnswer((_) => Future(() => null));

        String? actualResponse = await authTokensLocalDatasource
            .fetchRefreshToken();

        expect(actualResponse, isNull);
      });

      test('should throw StorageException', () async {
        when(
          () => mockSecureStorage.read(AppStorageKeys.refreshTokenKey),
        ).thenThrow(
          StorageException(technicalMessage: 'Fetch refresh token exception'),
        );

        Future<String?> Function() actualResponse =
            authTokensLocalDatasource.fetchRefreshToken;

        expect(actualResponse(), throwsA(isA<StorageException>()));
      });
    });

    group('method fetchTokens', () {
      test('should return AuthTokensModel', () async {
        AuthTokensModel shouldReturn = AuthTokensModel(
          accessToken: 'access',
          refreshToken: 'refresh',
        );

        when(
          () => mockSecureStorage.read(AppStorageKeys.accessTokenKey),
        ).thenAnswer((_) => Future(() => shouldReturn.accessToken));
        when(
          () => mockSecureStorage.read(AppStorageKeys.refreshTokenKey),
        ).thenAnswer((_) => Future(() => shouldReturn.refreshToken));

        AuthTokensModel? actualResponse = await authTokensLocalDatasource
            .fetchTokens();

        expect(actualResponse, isNotNull);
        expect(actualResponse?.accessToken, shouldReturn.accessToken);
        expect(actualResponse?.refreshToken, shouldReturn.refreshToken);
      });

      test('should return null', () async {
        when(
          () => mockSecureStorage.read(any()),
        ).thenAnswer((_) => Future(() => null));

        AuthTokensModel? actualResponse = await authTokensLocalDatasource
            .fetchTokens();

        expect(actualResponse, isNull);
        expect(actualResponse?.accessToken, isNull);
        expect(actualResponse?.refreshToken, isNull);
      });

      test('should throw StorageException', () async {
        when(
          () => mockSecureStorage.read(AppStorageKeys.accessTokenKey),
        ).thenAnswer((_) => Future(() => 'access'));
        when(
          () => mockSecureStorage.read(AppStorageKeys.refreshTokenKey),
        ).thenThrow(
          StorageException(technicalMessage: 'Fetch refresh token exception'),
        );

        Future<AuthTokensModel?> Function() actualResponse =
            authTokensLocalDatasource.fetchTokens;

        expect(actualResponse(), throwsA(isA<StorageException>()));
      });
    });

    group('method saveTokens', () {
      test('should call write for access token and refresh token', () async {
        AuthTokensModel request = AuthTokensModel(
          accessToken: 'access',
          refreshToken: 'refresh',
        );

        when(() => mockSecureStorage.read(any())).thenAnswer((_) async => null);
        when(
          () => mockSecureStorage.write(
            AppStorageKeys.accessTokenKey,
            request.accessToken!,
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockSecureStorage.write(
            AppStorageKeys.refreshTokenKey,
            request.refreshToken!,
          ),
        ).thenAnswer((_) async {});

        await authTokensLocalDatasource.saveTokens(request);

        verifyInOrder([
          () => mockSecureStorage.write(
            AppStorageKeys.accessTokenKey,
            request.accessToken!,
          ),
          () => mockSecureStorage.write(
            AppStorageKeys.refreshTokenKey,
            request.refreshToken!,
          ),
        ]);
      });

      test('should throw StorageException', () async {
        AuthTokensModel request = AuthTokensModel(
          accessToken: null,
          refreshToken: null,
        );

        when(
          () => mockSecureStorage.write(any(), any()),
        ).thenAnswer((_) async {});

        Future<void> Function(AuthTokensModel) call =
            authTokensLocalDatasource.saveTokens;

        expect(call(request), throwsA(isA<StorageException>()));
        verifyNever(() => mockSecureStorage.write(any(), any()));
      });
    });

    group('method clearTokens', () {
      test('should call delete for access token and refresh token', () async {
        when(() => mockSecureStorage.delete(any())).thenAnswer((_) async {});

        await authTokensLocalDatasource.clearTokens();

        verifyInOrder([
          () => mockSecureStorage.delete(AppStorageKeys.accessTokenKey),
          () => mockSecureStorage.delete(AppStorageKeys.refreshTokenKey),
        ]);
      });

      test(
        'access token delete error should still delete refresh token',
        () async {
          when(
            () => mockSecureStorage.delete(AppStorageKeys.accessTokenKey),
          ).thenThrow(
            StorageException(technicalMessage: 'Access token delete failed'),
          );
          when(
            () => mockSecureStorage.delete(AppStorageKeys.refreshTokenKey),
          ).thenAnswer((_) => Future(() {}));

          await expectLater(
            authTokensLocalDatasource.clearTokens(),
            throwsA(
              isA<StorageException>().having(
                (exception) => exception.technicalMessage,
                'message',
                'Access token delete failed',
              ),
            ),
          );
          verifyInOrder([
            () => mockSecureStorage.delete(AppStorageKeys.accessTokenKey),
            () => mockSecureStorage.delete(AppStorageKeys.refreshTokenKey),
          ]);
        },
      );

      test('both delete errors should throw the first error', () async {
        when(
          () => mockSecureStorage.delete(AppStorageKeys.accessTokenKey),
        ).thenThrow(
          StorageException(technicalMessage: 'Access token delete failed'),
        );
        when(
          () => mockSecureStorage.delete(AppStorageKeys.refreshTokenKey),
        ).thenThrow(
          StorageException(technicalMessage: 'Refresh token delete failed'),
        );

        await expectLater(
          authTokensLocalDatasource.clearTokens(),
          throwsA(
            isA<StorageException>().having(
              (exception) => exception.technicalMessage,
              'message',
              'Access token delete failed',
            ),
          ),
        );
        verifyInOrder([
          () => mockSecureStorage.delete(AppStorageKeys.accessTokenKey),
          () => mockSecureStorage.delete(AppStorageKeys.refreshTokenKey),
        ]);
      });
    });
  });
}
