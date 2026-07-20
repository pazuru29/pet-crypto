import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_bloc.dart';
import 'package:pet_crypto/features/authorization/presentation/screens/auth_gate/auth_gate_screen.dart';
import 'package:pet_crypto/widgets/app_button.dart';
import 'package:pet_crypto/widgets/error_view.dart';
import 'package:pet_crypto/widgets/loading_view.dart';

import '../../../../../helpers/widget_test_harness.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late AuthBloc authBloc;

  setUpAll(() {
    registerFallbackValue(AuthCheckEvent());
  });

  setUp(() {
    authBloc = MockAuthBloc();
  });

  group('Class AuthGateScreen', () {
    testWidgets('should send init event', (tester) async {
      whenListen(
        authBloc,
        const Stream<AuthState>.empty(),
        initialState: AuthState.initial(),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: authBloc)],
        child: const AuthGateScreen(),
      );

      verify(() => authBloc.add(any(that: isA<AuthCheckEvent>()))).called(1);
    });

    testWidgets('should show LoadingView', (tester) async {
      final stateController = StreamController<AuthState>();
      addTearDown(stateController.close);

      whenListen(
        authBloc,
        stateController.stream,
        initialState: AuthState.initial(),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: authBloc)],
        child: const AuthGateScreen(),
      );

      verify(() => authBloc.add(any(that: isA<AuthCheckEvent>()))).called(1);

      expect(find.byType(LoadingView), findsOneWidget);

      stateController.add(AuthState(status: .loading));
      await tester.pump();

      expect(find.byType(LoadingView), findsOneWidget);

      stateController.add(AuthState(status: .loaded));
      await tester.pump();

      expect(find.byType(LoadingView), findsOneWidget);
    });

    testWidgets('should show ErrorView', (tester) async {
      final stateController = StreamController<AuthState>();
      addTearDown(stateController.close);

      whenListen(
        authBloc,
        stateController.stream,
        initialState: AuthState.initial(),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: authBloc)],
        child: const AuthGateScreen(),
      );

      stateController.add(
        AuthState(status: .error, errorCode: .storageFailure),
      );
      await tester.pump();

      final finderErrorView = find.byType(ErrorView);

      expect(finderErrorView, findsOneWidget);

      final element = tester.element(finderErrorView);

      expect(find.text(S.of(element).appErrorStorageFailure), findsOneWidget);
    });

    testWidgets('press on try again button should add AuthCheckEvent', (
      tester,
    ) async {
      final stateController = StreamController<AuthState>();
      addTearDown(stateController.close);

      whenListen(
        authBloc,
        stateController.stream,
        initialState: AuthState.initial(),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: authBloc)],
        child: const AuthGateScreen(),
      );

      verify(() => authBloc.add(any(that: isA<AuthCheckEvent>()))).called(1);

      stateController.add(
        AuthState(status: .error, errorCode: .storageFailure),
      );
      await tester.pump();

      expect(find.byType(ErrorView), findsOneWidget);

      final finderButton = find.byType(AppButton);

      expect(finderButton, findsOneWidget);

      await tester.tap(finderButton);
      await tester.pump();

      verify(() => authBloc.add(any(that: isA<AuthCheckEvent>()))).called(1);
    });
  });
}
