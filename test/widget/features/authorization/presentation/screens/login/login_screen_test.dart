import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_bloc.dart';
import 'package:pet_crypto/features/authorization/presentation/screens/login/login_screen.dart';
import 'package:pet_crypto/widgets/app_button.dart';
import 'package:pet_crypto/widgets/app_text_form_field.dart';

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

  group('Class LoginScreen', () {
    testWidgets('should show LoginScreen', (tester) async {
      whenListen(
        authBloc,
        const Stream<AuthState>.empty(),
        initialState: AuthState(status: .loaded, authStatus: .unauthorized),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: authBloc)],
        child: const LoginScreen(),
      );

      final finderLoginScreen = find.byType(LoginScreen);

      expect(finderLoginScreen, findsOneWidget);

      final element = tester.element(finderLoginScreen);

      final finderPasswordField = find.widgetWithText(
        TextField,
        S.of(element).loginPassword,
      );

      expect(find.text(S.of(element).loginTitle), findsOneWidget);
      expect(
        find.widgetWithText(AppTextFormField, S.of(element).loginUsername),
        findsOneWidget,
      );
      expect(finderPasswordField, findsOneWidget);
      expect(
        find.widgetWithIcon(AppTextFormField, Icons.person),
        findsOneWidget,
      );
      expect(find.widgetWithIcon(AppTextFormField, Icons.lock), findsOneWidget);
      expect(
        find.widgetWithText(AppButton, S.of(element).loginButton),
        findsOneWidget,
      );

      final passwordWidget = tester.widget<TextField>(finderPasswordField);

      expect(passwordWidget.obscureText, isTrue);
    });

    testWidgets('should change state of obscureText', (tester) async {
      whenListen(
        authBloc,
        const Stream<AuthState>.empty(),
        initialState: AuthState(status: .loaded, authStatus: .unauthorized),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: authBloc)],
        child: const LoginScreen(),
      );

      final finderLoginScreen = find.byType(LoginScreen);

      expect(finderLoginScreen, findsOneWidget);

      final element = tester.element(finderLoginScreen);

      final finderPasswordField = find.widgetWithText(
        TextField,
        S.of(element).loginPassword,
      );

      final passwordWidget = tester.widget<TextField>(finderPasswordField);

      expect(passwordWidget.obscureText, isTrue);

      final passwordSuffixIcon = passwordWidget.decoration?.suffixIcon;

      expect(passwordSuffixIcon, isNotNull);

      final finderPasswordSuffixIcon = find.byWidget(passwordSuffixIcon!);

      expect(finderPasswordSuffixIcon, findsOneWidget);

      await tester.tap(finderPasswordSuffixIcon);
      await tester.pump();

      expect(
        tester.widget<TextField>(finderPasswordField).obscureText,
        isFalse,
      );
    });

    testWidgets('should show error about correct username and password', (
      tester,
    ) async {
      whenListen(
        authBloc,
        const Stream<AuthState>.empty(),
        initialState: AuthState(status: .loaded, authStatus: .unauthorized),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: authBloc)],
        child: const LoginScreen(),
      );

      final finderLoginScreen = find.byType(LoginScreen);

      expect(finderLoginScreen, findsOneWidget);

      final element = tester.element(finderLoginScreen);

      final finderLoginButton = find.widgetWithText(
        AppButton,
        S.of(element).loginButton,
      );

      await tester.tap(finderLoginButton);
      await tester.pump();

      verifyNever(() => authBloc.add(any(that: isA<AuthLoginEvent>())));

      expect(find.text(S.of(element).loginCorrectUsername), findsOneWidget);
      expect(find.text(S.of(element).loginCorrectPassword), findsOneWidget);
    });

    testWidgets('should show error about length of password', (tester) async {
      whenListen(
        authBloc,
        const Stream<AuthState>.empty(),
        initialState: AuthState(status: .loaded, authStatus: .unauthorized),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: authBloc)],
        child: const LoginScreen(),
      );

      final finderLoginScreen = find.byType(LoginScreen);

      expect(finderLoginScreen, findsOneWidget);

      final element = tester.element(finderLoginScreen);

      final finderUsernameField = find.widgetWithText(
        AppTextFormField,
        S.of(element).loginUsername,
      );
      final finderPasswordField = find.widgetWithText(
        AppTextFormField,
        S.of(element).loginPassword,
      );

      expect(finderUsernameField, findsOneWidget);
      expect(finderPasswordField, findsOneWidget);

      await tester.enterText(finderUsernameField, 'Marta');
      await tester.enterText(finderPasswordField, 'pass');

      final finderLoginButton = find.widgetWithText(
        AppButton,
        S.of(element).loginButton,
      );

      await tester.tap(finderLoginButton);
      await tester.pump();

      verifyNever(() => authBloc.add(any(that: isA<AuthLoginEvent>())));

      expect(find.text(S.of(element).loginLengthPassword(8)), findsOneWidget);
    });

    testWidgets('should add AuthLoginEvent by login button', (tester) async {
      whenListen(
        authBloc,
        const Stream<AuthState>.empty(),
        initialState: AuthState(status: .loaded, authStatus: .unauthorized),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: authBloc)],
        child: const LoginScreen(),
      );

      final finderLoginScreen = find.byType(LoginScreen);

      expect(finderLoginScreen, findsOneWidget);

      final element = tester.element(finderLoginScreen);

      final finderUsernameField = find.widgetWithText(
        AppTextFormField,
        S.of(element).loginUsername,
      );
      final finderPasswordField = find.widgetWithText(
        AppTextFormField,
        S.of(element).loginPassword,
      );

      expect(finderUsernameField, findsOneWidget);
      expect(finderPasswordField, findsOneWidget);

      await tester.enterText(finderUsernameField, 'Marta');
      await tester.enterText(finderPasswordField, 'password123');

      final finderLoginButton = find.widgetWithText(
        AppButton,
        S.of(element).loginButton,
      );

      await tester.tap(finderLoginButton);

      final captured =
          verify(
                () => authBloc.add(captureAny(that: isA<AuthLoginEvent>())),
              ).captured.single
              as AuthLoginEvent;

      expect(captured.username, 'Marta');
      expect(captured.password, 'password123');
    });

    testWidgets('should add AuthLoginEvent by TextField action done', (
      tester,
    ) async {
      whenListen(
        authBloc,
        const Stream<AuthState>.empty(),
        initialState: AuthState(status: .loaded, authStatus: .unauthorized),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: authBloc)],
        child: const LoginScreen(),
      );

      final finderLoginScreen = find.byType(LoginScreen);

      expect(finderLoginScreen, findsOneWidget);

      final element = tester.element(finderLoginScreen);

      final finderUsernameField = find.widgetWithText(
        AppTextFormField,
        S.of(element).loginUsername,
      );
      final finderPasswordField = find.widgetWithText(
        AppTextFormField,
        S.of(element).loginPassword,
      );

      expect(finderUsernameField, findsOneWidget);
      expect(finderPasswordField, findsOneWidget);

      await tester.enterText(finderUsernameField, 'Marta');
      await tester.enterText(finderPasswordField, 'password123');

      await tester.testTextInput.receiveAction(.done);

      final captured =
          verify(
                () => authBloc.add(captureAny(that: isA<AuthLoginEvent>())),
              ).captured.single
              as AuthLoginEvent;

      expect(captured.username, 'Marta');
      expect(captured.password, 'password123');
    });

    testWidgets(
      'login button should be disable and have CircularProgressIndicator when state is loading or (loaded and authorized)',
      (tester) async {
        final streamController = StreamController<AuthState>();
        addTearDown(streamController.close);

        whenListen(
          authBloc,
          streamController.stream,
          initialState: AuthState(status: .loading, authStatus: .unauthorized),
        );

        await pumpTestApp(
          tester,
          providers: [BlocProvider.value(value: authBloc)],
          child: const LoginScreen(),
        );

        final finderLoginScreen = find.byType(LoginScreen);

        expect(finderLoginScreen, findsOneWidget);

        final element = tester.element(finderLoginScreen);

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        final finderLoginButton = find.widgetWithText(
          ElevatedButton,
          S.of(element).loginButton,
        );

        final buttonWidget = tester.widget<ElevatedButton>(finderLoginButton);

        expect(buttonWidget.enabled, isFalse);
        expect(buttonWidget.onPressed, isNull);

        streamController.add(
          AuthState(status: .loaded, authStatus: .authorized),
        );
        await tester.pump();

        final newButtonWidget = tester.widget<ElevatedButton>(
          finderLoginButton,
        );

        expect(newButtonWidget.enabled, isFalse);
        expect(newButtonWidget.onPressed, isNull);
      },
    );

    testWidgets('should show alert banner', (tester) async {
      final streamController = StreamController<AuthState>();
      addTearDown(streamController.close);

      whenListen(
        authBloc,
        streamController.stream,
        initialState: AuthState(status: .loaded, authStatus: .unauthorized),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: authBloc)],
        child: const LoginScreen(),
      );

      final finderLoginScreen = find.byType(LoginScreen);

      expect(finderLoginScreen, findsOneWidget);

      final element = tester.element(finderLoginScreen);

      streamController.add(
        AuthState(
          status: .loaded,
          authStatus: .unauthorized,
          alertMessage: .error(.invalidCredentials),
        ),
      );
      await tester.pumpAndSettle();

      final finderBanner = find.byType(MaterialBanner);

      expect(finderBanner, findsOneWidget);
      expect(
        find.text(S.of(element).appErrorInvalidCredentials),
        findsOneWidget,
      );

      final finderCloseButton = find.descendant(
        of: finderBanner,
        matching: find.byIcon(Icons.close),
      );

      expect(finderCloseButton.hitTestable(), findsOneWidget);

      await tester.tap(finderCloseButton);
      await tester.pumpAndSettle();

      expect(finderBanner, findsNothing);
    });
  });
}
