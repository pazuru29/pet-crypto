import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_tokens.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_check_status.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository mockAuthRepository;
  late AuthCheckStatus authCheckStatus;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authCheckStatus = AuthCheckStatus(repo: mockAuthRepository);
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class AuthCheckStatus', () {
    group('method call', () {
      test('should return Ok<bool> when value is true', () async {
        when(() => mockAuthRepository.restoreSession()).thenAnswer(
          (_) => Future(
            () =>
                Ok(AuthTokens(accessToken: 'access', refreshToken: 'refresh')),
          ),
        );
        when(
          () => mockAuthRepository.updateCurrentUser(),
        ).thenAnswer((_) => Future(() => Ok(null)));

        Result<bool> actualResponse = await authCheckStatus.call();

        expect(actualResponse, isA<Ok>());
        expect((actualResponse as Ok).value, isTrue);
        verifyInOrder([
          () => mockAuthRepository.restoreSession(),
          () => mockAuthRepository.updateCurrentUser(),
        ]);
      });

      test('should return Ok<bool> when value is false', () async {
        when(
          () => mockAuthRepository.restoreSession(),
        ).thenAnswer((_) => Future(() => Ok(null)));
        when(
          () => mockAuthRepository.updateCurrentUser(),
        ).thenAnswer((_) => Future(() => Ok(null)));

        Result<bool> actualResponse = await authCheckStatus.call();

        expect(actualResponse, isA<Ok>());
        expect((actualResponse as Ok).value, isFalse);
        verify(() => mockAuthRepository.restoreSession()).called(1);
        verifyNever(() => mockAuthRepository.updateCurrentUser());
      });

      test('should return Err when called restoreSession', () async {
        when(() => mockAuthRepository.restoreSession()).thenAnswer(
          (_) => Future(() => Err(StorageFailure('Something went wrong'))),
        );
        when(
          () => mockAuthRepository.updateCurrentUser(),
        ).thenAnswer((_) => Future(() => Ok(null)));

        Result<bool> actualResponse = await authCheckStatus.call();

        expect(actualResponse, isA<Err>());
        expect((actualResponse as Err).failure, isA<StorageFailure>());
        verify(() => mockAuthRepository.restoreSession()).called(1);
        verifyNever(() => mockAuthRepository.updateCurrentUser());
      });

      test('should return Err when called updateCurrentUser', () async {
        when(() => mockAuthRepository.restoreSession()).thenAnswer(
          (_) => Future(
            () =>
                Ok(AuthTokens(accessToken: 'access', refreshToken: 'refresh')),
          ),
        );
        when(() => mockAuthRepository.updateCurrentUser()).thenAnswer(
          (_) => Future(() => Err(StorageFailure('Something went wrong'))),
        );

        Result<bool> actualResponse = await authCheckStatus.call();

        expect(actualResponse, isA<Err>());
        expect((actualResponse as Err).failure, isA<StorageFailure>());
        verifyInOrder([
          () => mockAuthRepository.restoreSession(),
          () => mockAuthRepository.updateCurrentUser(),
        ]);
      });
    });
  });
}
