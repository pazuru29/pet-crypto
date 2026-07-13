import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/bloc/bloc_message.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_status.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_tokens.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_check_status.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_login_user.dart';
import 'package:pet_crypto/features/authorization/domain/usecases/auth_logout_user.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

class MockAuthCheckStatus extends Mock implements AuthCheckStatus {}

class MockAuthLoginUser extends Mock implements AuthLoginUser {}

class MockAuthLogoutUser extends Mock implements AuthLogoutUser {}

void main() {
  late AuthBloc authBloc;
  late AuthCheckStatus mockAuthCheckStatus;
  late AuthLoginUser mockAuthLoginUser;
  late AuthLogoutUser mockAuthLogoutUser;

  setUp(() {
    mockAuthCheckStatus = MockAuthCheckStatus();
    mockAuthLoginUser = MockAuthLoginUser();
    mockAuthLogoutUser = MockAuthLogoutUser();
    authBloc = AuthBloc(
      authStatus: mockAuthCheckStatus,
      loginUser: mockAuthLoginUser,
      logoutUser: mockAuthLogoutUser,
    );
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class AuthBloc', () {
    group('event AuthCheckEvent', () {
      blocTest(
        'should finish with AuthStatus.authorized',
        build: () {
          when(
            () => mockAuthCheckStatus.call(),
          ).thenAnswer((_) => Future(() => Ok(true)));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthCheckEvent()),
        expect: () => [
          AuthState(status: .loading),
          AuthState(status: .loaded, authStatus: .authorized),
        ],
        verify: (_) {
          verify(() => mockAuthCheckStatus.call()).called(1);
        },
      );

      blocTest(
        'should finish with AuthStatus.unauthorized when return Ok(false)',
        build: () {
          when(
            () => mockAuthCheckStatus.call(),
          ).thenAnswer((_) => Future(() => Ok(false)));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthCheckEvent()),
        expect: () => [
          AuthState(status: .loading),
          AuthState(status: .loaded, authStatus: .unauthorized),
        ],
        verify: (_) {
          verify(() => mockAuthCheckStatus.call()).called(1);
        },
      );

      blocTest(
        'should finish with AuthStatus.unauthorized when return Err(AuthorizationFailure)',
        build: () {
          when(() => mockAuthCheckStatus.call()).thenAnswer(
            (_) =>
                Future(() => Err(AuthorizationFailure('Something went wrong'))),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthCheckEvent()),
        expect: () => [
          AuthState(status: .loading),
          AuthState(status: .loaded, authStatus: .unauthorized),
        ],
        verify: (_) {
          verify(() => mockAuthCheckStatus.call()).called(1);
        },
      );

      blocTest(
        'should finish with error status when return Err(NetworkFailure)',
        build: () {
          when(() => mockAuthCheckStatus.call()).thenAnswer(
            (_) => Future(() => Err(NetworkFailure('Something went wrong'))),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthCheckEvent()),
        expect: () => [
          AuthState(status: .loading),
          AuthState(status: .error, errorMessage: 'Something went wrong'),
        ],
        verify: (_) {
          verify(() => mockAuthCheckStatus.call()).called(1);
        },
      );
    });

    group('event AuthLoginEvent', () {
      blocTest(
        'should finish with AuthStatus.authorized',
        build: () {
          registerFallbackValue(AuthRequest(login: 'login', password: 'pass'));
          when(() => mockAuthLoginUser.call(any())).thenAnswer(
            (_) => Future(
              () => Ok(
                AuthTokens(accessToken: 'access', refreshToken: 'refresh'),
              ),
            ),
          );
          return authBloc;
        },
        seed: () => AuthState(status: .loaded, authStatus: .unauthorized),
        act: (bloc) =>
            bloc.add(AuthLoginEvent(username: 'login', password: 'pass')),
        expect: () => [
          AuthState(status: .loading, authStatus: .unauthorized),
          AuthState(status: .loaded, authStatus: .authorized),
        ],
      );

      blocTest(
        'should finish with AuthStatus.unauthorized',
        build: () {
          registerFallbackValue(AuthRequest(login: 'login', password: 'pass'));
          when(() => mockAuthLoginUser.call(any())).thenAnswer(
            (_) =>
                Future(() => Err(AuthorizationFailure('Something went wrong'))),
          );
          return authBloc;
        },
        seed: () => AuthState(status: .loaded, authStatus: .unauthorized),
        act: (bloc) =>
            bloc.add(AuthLoginEvent(username: 'login', password: 'pass')),
        expect: () => [
          AuthState(status: .loading, authStatus: .unauthorized),
          AuthState(
            status: .loaded,
            authStatus: .unauthorized,
            alertMessage: BlocMessage.error('Something went wrong'),
          ),
        ],
      );
    });

    group('event AuthLogoutEvent', () {
      blocTest(
        'should finish with AuthStatus.unauthorized',
        build: () {
          when(
            () => mockAuthLogoutUser.call(),
          ).thenAnswer((_) => Future(() => Ok(AuthStatus.unauthorized)));
          return authBloc;
        },
        seed: () => AuthState(status: .loaded, authStatus: .authorized),
        act: (bloc) => bloc.add(AuthLogoutEvent()),
        expect: () => [
          AuthState(status: .loading, authStatus: .authorized),
          AuthState(status: .loaded, authStatus: .unauthorized),
        ],
      );

      blocTest(
        'should finish with AuthStatus.unauthorized and alert message when response is Err',
        build: () {
          when(() => mockAuthLogoutUser.call()).thenAnswer(
            (_) => Future(() => Err(StorageFailure('Something went wrong'))),
          );
          return authBloc;
        },
        seed: () => AuthState(status: .loaded, authStatus: .authorized),
        act: (bloc) => bloc.add(AuthLogoutEvent()),
        expect: () => [
          AuthState(status: .loading, authStatus: .authorized),
          AuthState(
            status: .loaded,
            authStatus: .unauthorized,
            alertMessage: BlocMessage.error('Something went wrong'),
          ),
        ],
      );
    });

    group('event AuthSessionExpiredEvent', () {
      blocTest(
        'should finish with AuthStatus.unauthorized',
        build: () => authBloc,
        seed: () => AuthState(status: .loaded, authStatus: .authorized),
        act: (bloc) => bloc.add(AuthSessionExpiredEvent()),
        expect: () => [AuthState(status: .loaded, authStatus: .unauthorized)],
      );
    });
  });
}
