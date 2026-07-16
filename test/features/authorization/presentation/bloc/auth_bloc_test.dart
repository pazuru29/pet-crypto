import 'dart:async';

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
          registerFallbackValue(AuthRequest(login: '', password: ''));
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
        verify: (_) {
          verify(() => mockAuthLoginUser.call(any())).called(1);
        },
      );

      blocTest(
        'should finish with AuthStatus.unauthorized',
        build: () {
          registerFallbackValue(AuthRequest(login: '', password: ''));
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
        verify: (_) {
          verify(() => mockAuthLoginUser.call(any())).called(1);
        },
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
        verify: (_) {
          verify(() => mockAuthLogoutUser.call()).called(1);
        },
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
        verify: (_) {
          verify(() => mockAuthLogoutUser.call()).called(1);
        },
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

    group('concurrent events priority', () {
      setUpAll(() {
        registerFallbackValue(AuthRequest(login: '', password: ''));
      });

      blocTest(
        'active check prevents login',
        build: () => authBloc,
        act: (bloc) async {
          final startedCheckCompleter = Completer<void>();
          final resultCheckCompleter = Completer<Result<bool>>();

          when(mockAuthCheckStatus.call).thenAnswer((_) async {
            startedCheckCompleter.complete();
            return await resultCheckCompleter.future;
          });

          bloc.add(AuthCheckEvent());
          await startedCheckCompleter.future;

          bloc.add(AuthLoginEvent(username: 'username', password: 'password'));
          await Future.delayed(.zero);

          resultCheckCompleter.complete(Ok(false));
        },
        expect: () => [
          AuthState(status: .loading),
          AuthState(status: .loaded, authStatus: .unauthorized),
        ],
        verify: (_) {
          verifyNever(() => mockAuthLoginUser.call(any()));
        },
      );

      blocTest(
        'session expired invalidates an active check result',
        build: () => authBloc,
        act: (bloc) async {
          final startedCheckCompleter = Completer<void>();
          final resultCheckCompleter = Completer<Result<bool>>();

          when(mockAuthCheckStatus.call).thenAnswer((_) async {
            startedCheckCompleter.complete();
            return await resultCheckCompleter.future;
          });

          bloc.add(AuthCheckEvent());
          await startedCheckCompleter.future;

          final sessionExpiredHandled = bloc.stream.firstWhere(
            (state) =>
                state.status == .loaded && state.authStatus == .unauthorized,
          );

          bloc.add(AuthSessionExpiredEvent());
          await sessionExpiredHandled;

          resultCheckCompleter.complete(Ok(true));
        },
        expect: () => [
          AuthState(status: .loading),
          AuthState(status: .loaded, authStatus: .unauthorized),
        ],
      );

      blocTest(
        'session expired invalidates an active login result',
        build: () => authBloc,
        seed: () => AuthState(status: .loaded, authStatus: .unauthorized),
        act: (bloc) async {
          final startedLoginCompleter = Completer<void>();
          final resultLoginCompleter = Completer<Result<AuthTokens>>();

          when(() => mockAuthLoginUser.call(any())).thenAnswer((_) async {
            startedLoginCompleter.complete();
            return await resultLoginCompleter.future;
          });

          bloc.add(AuthLoginEvent(username: 'username', password: 'password'));
          await startedLoginCompleter.future;

          final sessionExpiredHandled = bloc.stream.firstWhere(
            (state) =>
                state.status == .loaded && state.authStatus == .unauthorized,
          );

          bloc.add(AuthSessionExpiredEvent());
          await sessionExpiredHandled;

          resultLoginCompleter.complete(
            Ok(AuthTokens(accessToken: 'access', refreshToken: 'refresh')),
          );
        },
        expect: () => [
          AuthState(status: .loading, authStatus: .unauthorized),
          AuthState(status: .loaded, authStatus: .unauthorized),
        ],
      );

      blocTest(
        'session expired invalidates an active logout result',
        build: () => authBloc,
        seed: () => AuthState(status: .loaded, authStatus: .authorized),
        act: (bloc) async {
          final startedLogoutCompleter = Completer<void>();
          final resultLogoutCompleter = Completer<Result<AuthStatus>>();

          when(mockAuthLogoutUser.call).thenAnswer((_) async {
            startedLogoutCompleter.complete();
            return await resultLogoutCompleter.future;
          });

          bloc.add(AuthLogoutEvent());
          await startedLogoutCompleter.future;

          final sessionExpiredHandled = bloc.stream.firstWhere(
            (state) =>
                state.status == .loaded && state.authStatus == .unauthorized,
          );

          bloc.add(AuthSessionExpiredEvent());
          await sessionExpiredHandled;

          resultLogoutCompleter.complete(
            Err(StorageFailure('Something went wrong')),
          );
        },
        expect: () => [
          AuthState(status: .loading, authStatus: .authorized),
          AuthState(status: .loaded, authStatus: .unauthorized),
        ],
      );
    });
  });
}
