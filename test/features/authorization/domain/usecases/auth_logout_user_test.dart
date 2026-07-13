import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_status.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_logout_user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository mockAuthRepository;
  late AuthLogoutUser authLogoutUser;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authLogoutUser = AuthLogoutUser(repo: mockAuthRepository);
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class AuthLogoutUser', () {
    group('method call', () {
      test('should return Ok<AuthStatus>', () async {
        when(
          () => mockAuthRepository.clearSession(),
        ).thenAnswer((_) => Future(() => Ok(null)));

        Result<AuthStatus> actualResponse = await authLogoutUser.call();

        expect(actualResponse, isA<Ok<AuthStatus>>());
        expect((actualResponse as Ok).value, AuthStatus.unauthorized);
        verify(() => mockAuthRepository.clearSession()).called(1);
      });

      test('should return Err', () async {
        when(() => mockAuthRepository.clearSession()).thenAnswer(
          (_) => Future(() => Err(StorageFailure('Something went wrong'))),
        );

        Result<AuthStatus> actualResponse = await authLogoutUser.call();

        expect(actualResponse, isA<Err>());
        expect((actualResponse as Err).failure, isA<StorageFailure>());
        verify(() => mockAuthRepository.clearSession()).called(1);
      });
    });
  });
}
