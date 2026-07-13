import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_tokens.dart';
import 'package:pet_crypto/features/authorization/domain/repositories/auth_repository.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_login_user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository mockAuthRepository;
  late AuthLoginUser authLoginUser;
  late AuthRequest authRequest;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authLoginUser = AuthLoginUser(repo: mockAuthRepository);
    authRequest = AuthRequest(login: 'login', password: 'pass');
    registerFallbackValue(authRequest);
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class AuthLoginUser', () {
    group('method call', () {
      test('should return Ok<AuthTokens>', () async {
        when(() => mockAuthRepository.login(any())).thenAnswer(
          (_) => Future(
            () =>
                Ok(AuthTokens(accessToken: 'access', refreshToken: 'refresh')),
          ),
        );

        Result<AuthTokens> actualResponse = await authLoginUser.call(
          authRequest,
        );

        expect(actualResponse, isA<Ok>());
        verify(() => mockAuthRepository.login(any())).called(1);
      });

      test('should return Err', () async {
        when(() => mockAuthRepository.login(any())).thenAnswer(
          (_) =>
              Future(() => Err(AuthorizationFailure('Something went wrong'))),
        );

        Result<AuthTokens> actualResponse = await authLoginUser.call(
          authRequest,
        );

        expect(actualResponse, isA<Err>());
        expect((actualResponse as Err).failure, isA<AuthorizationFailure>());
        verify(() => mockAuthRepository.login(any())).called(1);
      });
    });
  });
}
