import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_datasource.dart';
import 'package:pet_crypto/features/authorization/data/datasources/auth_tokens_local_datasource.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_refresh_request_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_refresh_response_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_request_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_response_model.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_tokens_model.dart';
import 'package:pet_crypto/features/authorization/data/repositories/auth_repository_impl.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_tokens.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';
import 'package:pet_crypto/features/user/data/datasources/user_writer_local_datasource.dart';
import 'package:pet_crypto/features/user/data/models/user_data_model.dart';

class MockAuthDatasource extends Mock implements AuthDatasource {}

class MockAuthTokensLocalDatasource extends Mock
    implements AuthTokensLocalDatasource {}

class MockUserWriterLocalDatasource extends Mock
    implements UserWriterLocalDatasource {}

void main() {
  late AuthRepository authRepository;
  late AuthDatasource mockAuthDatasource;
  late AuthTokensLocalDatasource mockAuthTokensLocalDatasource;
  late UserWriterLocalDatasource mockUserWriterLocalDatasource;

  setUp(() {
    mockAuthDatasource = MockAuthDatasource();
    mockAuthTokensLocalDatasource = MockAuthTokensLocalDatasource();
    mockUserWriterLocalDatasource = MockUserWriterLocalDatasource();
    authRepository = AuthRepositoryImpl(
      remote: mockAuthDatasource,
      localTokens: mockAuthTokensLocalDatasource,
      localUser: mockUserWriterLocalDatasource,
    );
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class AuthRepositoryImpl', () {
    group('method login', () {
      late AuthRequest authRequest;

      setUp(() {
        authRequest = AuthRequest(login: 'login', password: 'pass');
        registerFallbackValue(AuthRequestModel.fromEntity(authRequest));
        registerFallbackValue(
          UserDataModel(fullName: null, email: null, image: null),
        );
        registerFallbackValue(
          AuthTokensModel(accessToken: null, refreshToken: null),
        );

        when(
          () => mockAuthTokensLocalDatasource.saveTokens(any()),
        ).thenAnswer((_) => Future(() {}));
        when(
          () => mockUserWriterLocalDatasource.clearUserData(),
        ).thenAnswer((_) => Future(() {}));
        when(
          () => mockAuthTokensLocalDatasource.clearTokens(),
        ).thenAnswer((_) => Future(() {}));
      });

      test('should return Ok<AuthTokens>', () async {
        when(() => mockAuthDatasource.login(any())).thenAnswer(
          (_) => Future(
            () => AuthResponseModel(
              username: 'user',
              accessToken: 'access',
              refreshToken: 'refresh',
            ),
          ),
        );
        when(
          () => mockUserWriterLocalDatasource.saveUserData(any()),
        ).thenAnswer((_) => Future(() {}));

        Result<AuthTokens> actualResponse = await authRepository.login(
          authRequest,
        );

        expect(actualResponse, isA<Ok<AuthTokens>>());
        verifyInOrder([
          () => mockUserWriterLocalDatasource.saveUserData(any()),
          () => mockAuthTokensLocalDatasource.saveTokens(any()),
        ]);
        verifyNever(() => mockUserWriterLocalDatasource.clearUserData());
        verifyNever(() => mockAuthTokensLocalDatasource.clearTokens());
      });

      test('should return Err<AuthorizationFailure>', () async {
        when(
          () => mockAuthDatasource.login(any()),
        ).thenThrow(AuthorizationException('Something went wrong'));
        when(
          () => mockUserWriterLocalDatasource.saveUserData(any()),
        ).thenAnswer((_) => Future(() {}));

        Result<AuthTokens> actualResponse = await authRepository.login(
          authRequest,
        );

        expect(actualResponse, isA<Err<AuthTokens>>());
        expect((actualResponse as Err).failure, isA<AuthorizationFailure>());
        verifyNever(() => mockUserWriterLocalDatasource.saveUserData(any()));
        verifyNever(() => mockAuthTokensLocalDatasource.saveTokens(any()));
        verifyNever(() => mockUserWriterLocalDatasource.clearUserData());
        verifyNever(() => mockAuthTokensLocalDatasource.clearTokens());
      });

      test('should return Err<StorageFailure>', () async {
        when(() => mockAuthDatasource.login(any())).thenAnswer(
          (_) => Future(
            () => AuthResponseModel(
              username: 'user',
              accessToken: 'access',
              refreshToken: 'refresh',
            ),
          ),
        );
        when(
          () => mockUserWriterLocalDatasource.saveUserData(any()),
        ).thenThrow(StorageException('Something went wrong'));

        Result<AuthTokens> actualResponse = await authRepository.login(
          authRequest,
        );

        expect(actualResponse, isA<Err<AuthTokens>>());
        expect((actualResponse as Err).failure, isA<StorageFailure>());
        verifyInOrder([
          () => mockUserWriterLocalDatasource.saveUserData(any()),
          () => mockAuthTokensLocalDatasource.clearTokens(),
          () => mockUserWriterLocalDatasource.clearUserData(),
        ]);
        verifyNever(() => mockAuthTokensLocalDatasource.saveTokens(any()));
      });

      test('should rollback session when saveTokens throws', () async {
        when(() => mockAuthDatasource.login(any())).thenAnswer(
          (_) => Future(
            () => AuthResponseModel(
              username: 'user',
              accessToken: 'access',
              refreshToken: 'refresh',
            ),
          ),
        );
        when(
          () => mockUserWriterLocalDatasource.saveUserData(any()),
        ).thenAnswer((_) => Future(() {}));
        when(
          () => mockAuthTokensLocalDatasource.saveTokens(any()),
        ).thenThrow(StorageException('Primary save failure'));

        final actualResponse = await authRepository.login(authRequest);

        expect(actualResponse, isA<Err<AuthTokens>>());
        expect(
          (actualResponse as Err<AuthTokens>).failure.message,
          'Primary save failure',
        );
        verifyInOrder([
          () => mockUserWriterLocalDatasource.saveUserData(any()),
          () => mockAuthTokensLocalDatasource.saveTokens(any()),
          () => mockAuthTokensLocalDatasource.clearTokens(),
          () => mockUserWriterLocalDatasource.clearUserData(),
        ]);
      });

      test('rollback errors should not replace the save error', () async {
        when(() => mockAuthDatasource.login(any())).thenAnswer(
          (_) => Future(
            () => AuthResponseModel(
              username: 'user',
              accessToken: 'access',
              refreshToken: 'refresh',
            ),
          ),
        );
        when(
          () => mockUserWriterLocalDatasource.saveUserData(any()),
        ).thenThrow(StorageException('Primary save failure'));
        when(
          () => mockAuthTokensLocalDatasource.clearTokens(),
        ).thenThrow(StorageException('Token rollback failure'));
        when(
          () => mockUserWriterLocalDatasource.clearUserData(),
        ).thenThrow(StorageException('User rollback failure'));

        final actualResponse = await authRepository.login(authRequest);

        expect(actualResponse, isA<Err<AuthTokens>>());
        expect(
          (actualResponse as Err<AuthTokens>).failure.message,
          'Primary save failure',
        );
        verifyInOrder([
          () => mockUserWriterLocalDatasource.saveUserData(any()),
          () => mockAuthTokensLocalDatasource.clearTokens(),
          () => mockUserWriterLocalDatasource.clearUserData(),
        ]);
        verifyNever(() => mockAuthTokensLocalDatasource.saveTokens(any()));
      });
    });

    group('method updateCurrentUser', () {
      setUp(() {
        registerFallbackValue(
          UserDataModel(fullName: null, email: null, image: null),
        );
      });

      test('should return Ok<null>', () async {
        when(
          () => mockAuthDatasource.fetchCurrentUser(),
        ).thenAnswer((_) => Future(() => AuthResponseModel(username: 'user')));
        when(
          () => mockUserWriterLocalDatasource.saveUserData(any()),
        ).thenAnswer((_) => Future(() {}));

        Result<void> actualResponse = await authRepository.updateCurrentUser();

        expect(actualResponse, isA<Ok<void>>());
        verifyInOrder([
          () => mockAuthDatasource.fetchCurrentUser(),
          () => mockUserWriterLocalDatasource.saveUserData(any()),
        ]);
      });

      test('should return Err<AuthorizationFailure>', () async {
        when(
          () => mockAuthDatasource.fetchCurrentUser(),
        ).thenThrow(AuthorizationException('Something went wrong'));
        when(
          () => mockUserWriterLocalDatasource.saveUserData(any()),
        ).thenAnswer((_) => Future(() {}));

        Result<void> actualResponse = await authRepository.updateCurrentUser();

        expect(actualResponse, isA<Err<void>>());
        expect((actualResponse as Err).failure, isA<AuthorizationFailure>());
        verify(() => mockAuthDatasource.fetchCurrentUser()).called(1);
        verifyNever(() => mockUserWriterLocalDatasource.saveUserData(any()));
      });

      test('should return Err<StorageFailure>', () async {
        when(
          () => mockAuthDatasource.fetchCurrentUser(),
        ).thenAnswer((_) => Future(() => AuthResponseModel(username: 'user')));
        when(
          () => mockUserWriterLocalDatasource.saveUserData(any()),
        ).thenThrow(StorageException('Something went wrong'));

        Result<void> actualResponse = await authRepository.updateCurrentUser();

        expect(actualResponse, isA<Err<void>>());
        expect((actualResponse as Err).failure, isA<StorageFailure>());
        verifyInOrder([
          () => mockAuthDatasource.fetchCurrentUser(),
          () => mockUserWriterLocalDatasource.saveUserData(any()),
        ]);
      });
    });

    group('method refreshToken', () {
      setUp(() {
        registerFallbackValue(AuthRefreshRequestModel(refreshToken: ''));
      });

      test('should return Ok<null>', () async {
        when(
          () => mockAuthTokensLocalDatasource.fetchRefreshToken(),
        ).thenAnswer((_) => Future(() => 'refresh'));
        when(() => mockAuthDatasource.refreshToken(any())).thenAnswer(
          (_) => Future(
            () => AuthRefreshResponseModel(
              accessToken: 'new-access',
              refreshToken: 'new-refresh',
            ),
          ),
        );
        when(
          () => mockAuthTokensLocalDatasource.saveTokens(any()),
        ).thenAnswer((_) => Future(() {}));

        Result<void> actualResponse = await authRepository.refreshToken();

        expect(actualResponse, isA<Ok<void>>());
        verifyInOrder([
          () => mockAuthTokensLocalDatasource.fetchRefreshToken(),
          () => mockAuthDatasource.refreshToken(any()),
          () => mockAuthTokensLocalDatasource.saveTokens(any()),
        ]);
      });

      test(
        'should return Err<AuthorizationFailure> when refresh token is empty',
        () async {
          when(
            () => mockAuthTokensLocalDatasource.fetchRefreshToken(),
          ).thenAnswer((_) => Future(() => ''));

          when(() => mockAuthDatasource.refreshToken(any())).thenAnswer(
            (_) => Future(
              () => AuthRefreshResponseModel(
                accessToken: 'new-access',
                refreshToken: 'new-refresh',
              ),
            ),
          );

          when(
            () => mockAuthTokensLocalDatasource.saveTokens(any()),
          ).thenAnswer((_) => Future(() {}));

          Result<void> actualResponse = await authRepository.refreshToken();

          expect(actualResponse, isA<Err<void>>());
          expect((actualResponse as Err).failure, isA<AuthorizationFailure>());
          verify(
            () => mockAuthTokensLocalDatasource.fetchRefreshToken(),
          ).called(1);
          verifyNever(() => mockAuthDatasource.refreshToken(any()));
          verifyNever(() => mockAuthTokensLocalDatasource.saveTokens(any()));
        },
      );

      test(
        'should return Err<AuthorizationFailure> when remote refreshToken is failed',
        () async {
          when(
            () => mockAuthTokensLocalDatasource.fetchRefreshToken(),
          ).thenAnswer((_) => Future(() => 'refresh'));

          when(
            () => mockAuthDatasource.refreshToken(any()),
          ).thenThrow(AuthorizationException('Something went wrong'));

          when(
            () => mockAuthTokensLocalDatasource.saveTokens(any()),
          ).thenAnswer((_) => Future(() {}));

          Result<void> actualResponse = await authRepository.refreshToken();

          expect(actualResponse, isA<Err<void>>());
          expect((actualResponse as Err).failure, isA<AuthorizationFailure>());
          verifyInOrder([
            () => mockAuthTokensLocalDatasource.fetchRefreshToken(),
            () => mockAuthDatasource.refreshToken(any()),
          ]);
          verifyNever(() => mockAuthTokensLocalDatasource.saveTokens(any()));
        },
      );

      test('should return Err<StorageFailure>', () async {
        when(
          () => mockAuthTokensLocalDatasource.fetchRefreshToken(),
        ).thenAnswer((_) => Future(() => 'refresh'));
        when(() => mockAuthDatasource.refreshToken(any())).thenAnswer(
          (_) => Future(
            () => AuthRefreshResponseModel(
              accessToken: 'new-access',
              refreshToken: 'new-refresh',
            ),
          ),
        );
        when(
          () => mockAuthTokensLocalDatasource.saveTokens(any()),
        ).thenThrow(StorageException('Something went wrong'));

        Result<void> actualResponse = await authRepository.refreshToken();

        expect(actualResponse, isA<Err<void>>());
        expect((actualResponse as Err).failure, isA<StorageFailure>());
        verifyInOrder([
          () => mockAuthTokensLocalDatasource.fetchRefreshToken(),
          () => mockAuthDatasource.refreshToken(any()),
          () => mockAuthTokensLocalDatasource.saveTokens(any()),
        ]);
      });
    });

    group('method restoreSession', () {
      test('should return Ok<AuthTokens>', () async {
        when(() => mockAuthTokensLocalDatasource.fetchTokens()).thenAnswer(
          (_) => Future(
            () =>
                AuthTokensModel(accessToken: 'access', refreshToken: 'refresh'),
          ),
        );

        Result<AuthTokens?> actualResponse = await authRepository
            .restoreSession();

        expect(actualResponse, isA<Ok>());
        expect((actualResponse as Ok).value, isA<AuthTokens>());
        verify(() => mockAuthTokensLocalDatasource.fetchTokens()).called(1);
      });

      test('should return Ok<null>', () async {
        when(
          () => mockAuthTokensLocalDatasource.fetchTokens(),
        ).thenAnswer((_) => Future(() => null));

        Result<AuthTokens?> actualResponse = await authRepository
            .restoreSession();

        expect(actualResponse, isA<Ok>());
        expect((actualResponse as Ok).value, isNull);
        verify(() => mockAuthTokensLocalDatasource.fetchTokens()).called(1);
      });

      test('should return Err<StorageFailure>', () async {
        when(
          () => mockAuthTokensLocalDatasource.fetchTokens(),
        ).thenThrow(StorageException('Something went wrong'));

        Result<AuthTokens?> actualResponse = await authRepository
            .restoreSession();

        expect(actualResponse, isA<Err>());
        expect((actualResponse as Err).failure, isA<StorageFailure>());
        verify(() => mockAuthTokensLocalDatasource.fetchTokens()).called(1);
      });
    });

    group('method clearSession', () {
      setUp(() {
        when(
          () => mockAuthTokensLocalDatasource.clearTokens(),
        ).thenAnswer((_) => Future(() {}));
        when(
          () => mockUserWriterLocalDatasource.clearUserData(),
        ).thenAnswer((_) => Future(() {}));
      });

      test('should return Ok<null>', () async {
        Result<void> actualResponse = await authRepository.clearSession();

        expect(actualResponse, isA<Ok<void>>());
        verifyInOrder([
          () => mockAuthTokensLocalDatasource.clearTokens(),
          () => mockUserWriterLocalDatasource.clearUserData(),
        ]);
      });

      test(
        'token cleanup error should still clear user data and return Err',
        () async {
          when(
            () => mockAuthTokensLocalDatasource.clearTokens(),
          ).thenThrow(StorageException('Token cleanup failed'));

          final actualResponse = await authRepository.clearSession();

          expect(actualResponse, isA<Err<void>>());
          expect(
            (actualResponse as Err<void>).failure,
            isA<StorageFailure>().having(
              (failure) => failure.message,
              'message',
              'Token cleanup failed',
            ),
          );
          verifyInOrder([
            () => mockAuthTokensLocalDatasource.clearTokens(),
            () => mockUserWriterLocalDatasource.clearUserData(),
          ]);
        },
      );

      test('user cleanup error should return Err', () async {
        when(
          () => mockUserWriterLocalDatasource.clearUserData(),
        ).thenThrow(StorageException('User cleanup failed'));

        final actualResponse = await authRepository.clearSession();

        expect(actualResponse, isA<Err<void>>());
        expect(
          (actualResponse as Err<void>).failure,
          isA<StorageFailure>().having(
            (failure) => failure.message,
            'message',
            'User cleanup failed',
          ),
        );
        verifyInOrder([
          () => mockAuthTokensLocalDatasource.clearTokens(),
          () => mockUserWriterLocalDatasource.clearUserData(),
        ]);
      });

      test('both cleanup errors should return the first error', () async {
        when(
          () => mockAuthTokensLocalDatasource.clearTokens(),
        ).thenThrow(StorageException('Token cleanup failed'));
        when(
          () => mockUserWriterLocalDatasource.clearUserData(),
        ).thenThrow(StorageException('User cleanup failed'));

        final actualResponse = await authRepository.clearSession();

        expect(actualResponse, isA<Err<void>>());
        expect(
          (actualResponse as Err<void>).failure,
          isA<StorageFailure>().having(
            (failure) => failure.message,
            'message',
            'Token cleanup failed',
          ),
        );
        verifyInOrder([
          () => mockAuthTokensLocalDatasource.clearTokens(),
          () => mockUserWriterLocalDatasource.clearUserData(),
        ]);
      });

      test(
        'unexpected cleanup error should still clear user data and return Err',
        () async {
          when(
            () => mockAuthTokensLocalDatasource.clearTokens(),
          ).thenThrow(StateError('Unexpected token cleanup failure'));

          final actualResponse = await authRepository.clearSession();

          expect(actualResponse, isA<Err<void>>());
          expect(
            (actualResponse as Err<void>).failure,
            isA<UnexpectedFailure>().having(
              (failure) => failure.message,
              'message',
              contains('Unexpected token cleanup failure'),
            ),
          );
          verifyInOrder([
            () => mockAuthTokensLocalDatasource.clearTokens(),
            () => mockUserWriterLocalDatasource.clearUserData(),
          ]);
        },
      );
    });
  });
}
