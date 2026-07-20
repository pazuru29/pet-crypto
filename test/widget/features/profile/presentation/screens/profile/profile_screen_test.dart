import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_bloc.dart';
import 'package:pet_crypto/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pet_crypto/features/profile/presentation/profile/profile_screen.dart';
import 'package:pet_crypto/features/profile/presentation/profile/widgets/profile_header_widget.dart';
import 'package:pet_crypto/features/profile/presentation/profile/widgets/profile_locale_widget.dart';
import 'package:pet_crypto/features/profile/presentation/profile/widgets/profile_theme_widget.dart';
import 'package:pet_crypto/features/user/domain/entities/user_data.dart';
import 'package:pet_crypto/widgets/app_icon_button.dart';
import 'package:pet_crypto/widgets/error_view.dart';
import 'package:pet_crypto/widgets/loading_view.dart';

import '../../../../../helpers/widget_test_harness.dart';

class MockProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late ProfileBloc profileBloc;
  late AuthBloc authBloc;

  setUpAll(() {
    registerFallbackValue(ProfileInitEvent());
    registerFallbackValue(AuthCheckEvent());
  });

  setUp(() {
    profileBloc = MockProfileBloc();
    authBloc = MockAuthBloc();
  });

  group('Class ProfileScreen', () {
    testWidgets('should add ProfileInitEvent', (tester) async {
      whenListen(
        profileBloc,
        Stream<ProfileState>.empty(),
        initialState: ProfileState.initial(),
      );

      whenListen(
        authBloc,
        Stream<AuthState>.empty(),
        initialState: AuthState(status: .loaded, authStatus: .authorized),
      );

      await pumpTestApp(
        tester,
        providers: [
          BlocProvider.value(value: profileBloc),
          BlocProvider.value(value: authBloc),
        ],
        child: const ProfileScreen(),
      );

      verify(
        () => profileBloc.add(any(that: isA<ProfileInitEvent>())),
      ).called(1);
    });

    testWidgets('should show LoadingView for initial an loading states', (
      tester,
    ) async {
      final streamController = StreamController<ProfileState>();
      addTearDown(streamController.close);

      whenListen(
        profileBloc,
        streamController.stream,
        initialState: ProfileState.initial(),
      );

      whenListen(
        authBloc,
        Stream<AuthState>.empty(),
        initialState: AuthState(status: .loaded, authStatus: .authorized),
      );

      await pumpTestApp(
        tester,
        providers: [
          BlocProvider.value(value: profileBloc),
          BlocProvider.value(value: authBloc),
        ],
        child: const ProfileScreen(),
      );

      verify(
        () => profileBloc.add(any(that: isA<ProfileInitEvent>())),
      ).called(1);

      final loadingFinder = find.byType(LoadingView);

      expect(loadingFinder, findsOneWidget);

      streamController.add(ProfileState(status: .loading));
      await tester.pump();

      expect(loadingFinder, findsOneWidget);
    });

    testWidgets(
      'should show ErrorView and add ProfileInitEvent when tap on retry button',
      (tester) async {
        final streamController = StreamController<ProfileState>();
        addTearDown(streamController.close);

        whenListen(
          profileBloc,
          streamController.stream,
          initialState: ProfileState.initial(),
        );

        whenListen(
          authBloc,
          Stream<AuthState>.empty(),
          initialState: AuthState(status: .loaded, authStatus: .authorized),
        );

        await pumpTestApp(
          tester,
          providers: [
            BlocProvider.value(value: profileBloc),
            BlocProvider.value(value: authBloc),
          ],
          child: const ProfileScreen(),
        );

        verify(
          () => profileBloc.add(any(that: isA<ProfileInitEvent>())),
        ).called(1);

        streamController.add(
          ProfileState(status: .error, errorCode: .serverUnavailable),
        );
        await tester.pump();

        final errorFinder = find.byType(ErrorView);

        expect(errorFinder, findsOneWidget);

        final element = tester.element(errorFinder);

        expect(
          find.text(S.of(element).appErrorServerUnavailable),
          findsOneWidget,
        );

        final finderRetry = find
            .widgetWithText(ElevatedButton, S.of(element).errorViewTryAgain)
            .hitTestable();

        expect(finderRetry, findsOneWidget);

        await tester.tap(finderRetry);

        verify(
          () => profileBloc.add(any(that: isA<ProfileInitEvent>())),
        ).called(1);
      },
    );

    testWidgets('should show loaded state', (tester) async {
      final expectedUser = UserData(
        fullName: 'Marta',
        email: 'test@example.test',
        image: 'https://example.test',
      );

      final expectedInitImageUrl = 'https://init.example.test';

      final streamController = StreamController<ProfileState>();
      addTearDown(streamController.close);

      whenListen(
        profileBloc,
        streamController.stream,
        initialState: ProfileState.initial(),
      );

      whenListen(
        authBloc,
        Stream<AuthState>.empty(),
        initialState: AuthState(status: .loaded, authStatus: .authorized),
      );

      await pumpTestApp(
        tester,
        providers: [
          BlocProvider.value(value: profileBloc),
          BlocProvider.value(value: authBloc),
        ],
        child: ProfileScreen(initUserImage: expectedInitImageUrl),
      );

      verify(
        () => profileBloc.add(any(that: isA<ProfileInitEvent>())),
      ).called(1);

      streamController.add(
        ProfileState(status: .loaded, profileData: expectedUser),
      );
      await tester.pump();

      final profileFinder = find.byType(ProfileScreen);

      expect(profileFinder, findsOneWidget);

      final element = tester.element(profileFinder);

      expect(find.byType(ProfileThemeWidget), findsOneWidget);
      expect(find.byType(ProfileLocaleWidget), findsOneWidget);
      expect(find.text(S.of(element).profileLogout), findsOneWidget);

      final headerFinder = find.byType(ProfileHeaderWidget);

      expect(headerFinder, findsOneWidget);

      final headerWidget = tester.widget<ProfileHeaderWidget>(headerFinder);

      expect(headerWidget.fullName, expectedUser.fullName);
      expect(headerWidget.profileImage, expectedUser.image);
      expect(headerWidget.initUserImage, expectedInitImageUrl);
      expect(headerWidget.needPlaceHolder, isFalse);
    });

    testWidgets(
      'should add ProfileChangeThemeModeEvent when tap on theme button',
      (tester) async {
        final streamController = StreamController<ProfileState>();
        addTearDown(streamController.close);

        whenListen(
          profileBloc,
          streamController.stream,
          initialState: ProfileState.initial(),
        );

        whenListen(
          authBloc,
          Stream<AuthState>.empty(),
          initialState: AuthState(status: .loaded, authStatus: .authorized),
        );

        await pumpTestApp(
          tester,
          providers: [
            BlocProvider.value(value: profileBloc),
            BlocProvider.value(value: authBloc),
          ],
          child: ProfileScreen(),
        );

        verify(
          () => profileBloc.add(any(that: isA<ProfileInitEvent>())),
        ).called(1);

        streamController.add(ProfileState(status: .loaded));
        await tester.pump();

        final themeFinder = find.byType(ProfileThemeWidget);

        expect(themeFinder, findsOneWidget);

        final findButton = find.descendant(
          of: themeFinder,
          matching: find.byType(AppIconButton),
        );

        expect(findButton, findsExactly(3));

        await tester.tap(findButton.last);

        final capturedEvent =
            verify(
                  () => profileBloc.add(
                    captureAny(that: isA<ProfileChangeThemeModeEvent>()),
                  ),
                ).captured.single
                as ProfileChangeThemeModeEvent;

        expect(capturedEvent.themeIndex, 2);
      },
    );

    testWidgets('should add ProfileChangeLocaleEvent when tap on locale', (
      tester,
    ) async {
      final streamController = StreamController<ProfileState>();
      addTearDown(streamController.close);

      whenListen(
        profileBloc,
        streamController.stream,
        initialState: ProfileState.initial(),
      );

      whenListen(
        authBloc,
        Stream<AuthState>.empty(),
        initialState: AuthState(status: .loaded, authStatus: .authorized),
      );

      await pumpTestApp(
        tester,
        providers: [
          BlocProvider.value(value: profileBloc),
          BlocProvider.value(value: authBloc),
        ],
        child: ProfileScreen(),
      );

      verify(
        () => profileBloc.add(any(that: isA<ProfileInitEvent>())),
      ).called(1);

      streamController.add(ProfileState(status: .loaded));
      await tester.pump();

      final localeFinder = find.byType(ProfileLocaleWidget);

      expect(localeFinder, findsOneWidget);

      final findDropdownMenu = find.descendant(
        of: localeFinder,
        matching: find.byType(DropdownMenu<String>).hitTestable(),
      );

      expect(findDropdownMenu, findsOneWidget);

      await tester.tap(findDropdownMenu);
      await tester.pumpAndSettle();

      final localeMenuButtonFinder = find
          .widgetWithText(MenuItemButton, 'UA')
          .hitTestable();

      expect(localeMenuButtonFinder, findsOneWidget);

      await tester.tap(localeMenuButtonFinder);
      await tester.pumpAndSettle();

      final capturedEvent =
          verify(
                () => profileBloc.add(
                  captureAny(that: isA<ProfileChangeLocaleEvent>()),
                ),
              ).captured.single
              as ProfileChangeLocaleEvent;

      expect(capturedEvent.languageCode, 'uk');
    });

    testWidgets('should add AuthLogoutEvent when tap on logout button', (
      tester,
    ) async {
      final profileStreamController = StreamController<ProfileState>();
      final authStreamController = StreamController<AuthState>();
      addTearDown(() async {
        await profileStreamController.close();
        await authStreamController.close();
      });

      whenListen(
        profileBloc,
        profileStreamController.stream,
        initialState: ProfileState.initial(),
      );

      whenListen(
        authBloc,
        authStreamController.stream,
        initialState: AuthState(status: .loaded, authStatus: .authorized),
      );

      await pumpTestApp(
        tester,
        providers: [
          BlocProvider.value(value: profileBloc),
          BlocProvider.value(value: authBloc),
        ],
        child: ProfileScreen(),
      );

      verify(
        () => profileBloc.add(any(that: isA<ProfileInitEvent>())),
      ).called(1);

      profileStreamController.add(ProfileState(status: .loaded));
      await tester.pump();

      final profileFinder = find.byType(ProfileScreen);

      expect(profileFinder, findsOneWidget);

      final element = tester.element(profileFinder);

      final logoutFinder = find.widgetWithText(
        ElevatedButton,
        S.of(element).profileLogout,
      );

      expect(logoutFinder.hitTestable(), findsOneWidget);

      await tester.tap(logoutFinder.hitTestable());
      await tester.pump();

      verify(() => authBloc.add(any(that: isA<AuthLogoutEvent>()))).called(1);

      authStreamController.add(
        AuthState(status: .loading, authStatus: .authorized),
      );
      await tester.pump();

      expect(
        find.descendant(
          of: logoutFinder,
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );

      final logoutWidget = tester.widget<ElevatedButton>(logoutFinder);

      expect(logoutWidget.enabled, isFalse);
      expect(logoutWidget.onPressed, isNull);
    });

    testWidgets('should show SnackBar', (tester) async {
      final streamController = StreamController<ProfileState>();
      addTearDown(streamController.close);

      whenListen(
        profileBloc,
        streamController.stream,
        initialState: ProfileState.initial(),
      );

      whenListen(
        authBloc,
        Stream<AuthState>.empty(),
        initialState: AuthState(status: .loaded, authStatus: .authorized),
      );

      await pumpTestApp(
        tester,
        providers: [
          BlocProvider.value(value: profileBloc),
          BlocProvider.value(value: authBloc),
        ],
        child: ProfileScreen(),
      );

      verify(
        () => profileBloc.add(any(that: isA<ProfileInitEvent>())),
      ).called(1);

      streamController.add(
        ProfileState(status: .loaded, alertMessage: .error(.storageFailure)),
      );
      await tester.pumpAndSettle();

      final profileFinder = find.byType(ProfileScreen);

      expect(profileFinder, findsOneWidget);

      final element = tester.element(profileFinder);

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(S.of(element).appErrorStorageFailure), findsOneWidget);
    });
  });
}
