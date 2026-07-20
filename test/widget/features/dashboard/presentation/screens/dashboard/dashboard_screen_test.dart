import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency.dart';
import 'package:pet_crypto/features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/dashboard/widgets/dashboard_cryptocurrency_list.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/dashboard/widgets/dashboard_empty_view.dart';
import 'package:pet_crypto/widgets/app_cached_image.dart';
import 'package:pet_crypto/widgets/app_title_profile.dart';
import 'package:pet_crypto/widgets/error_view.dart';
import 'package:pet_crypto/widgets/loading_view.dart';

import '../../../../../helpers/widget_test_harness.dart';

class MockDashboardBloc extends MockBloc<DashboardEvent, DashboardState>
    implements DashboardBloc {}

DashboardCryptocurrency cryptocurrency(int id) => DashboardCryptocurrency(
  id: id,
  name: 'Crypto $id',
  symbol: 'C$id',
  prices: const [],
);

void main() {
  late DashboardBloc dashboardBloc;

  setUpAll(() {
    registerFallbackValue(DashboardInitEvent());
  });

  setUp(() {
    dashboardBloc = MockDashboardBloc();
  });

  group('Class DashboardScreen', () {
    testWidgets('should add DashboardInitEvent', (tester) async {
      whenListen(
        dashboardBloc,
        Stream<DashboardState>.empty(),
        initialState: DashboardState.initial(),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: dashboardBloc)],
        child: const DashboardScreen(),
      );

      verify(
        () => dashboardBloc.add(any(that: isA<DashboardInitEvent>())),
      ).called(1);
    });

    testWidgets('should show LoadingView for initial and loading states', (
      tester,
    ) async {
      final streamController = StreamController<DashboardState>();
      addTearDown(streamController.close);

      whenListen(
        dashboardBloc,
        streamController.stream,
        initialState: DashboardState.initial(),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: dashboardBloc)],
        child: const DashboardScreen(),
      );

      verify(
        () => dashboardBloc.add(any(that: isA<DashboardInitEvent>())),
      ).called(1);

      expect(find.byType(LoadingView), findsOneWidget);

      streamController.add(DashboardState(status: .loading));
      await tester.pump();

      expect(find.byType(LoadingView), findsOneWidget);
    });

    testWidgets(
      'should show ErrorView for error state and for tap on retry call DashboardInitEvent',
      (tester) async {
        final streamController = StreamController<DashboardState>();
        addTearDown(streamController.close);

        whenListen(
          dashboardBloc,
          streamController.stream,
          initialState: DashboardState.initial(),
        );

        await pumpTestApp(
          tester,
          providers: [BlocProvider.value(value: dashboardBloc)],
          child: const DashboardScreen(),
        );

        verify(
          () => dashboardBloc.add(any(that: isA<DashboardInitEvent>())),
        ).called(1);

        streamController.add(
          DashboardState(status: .error, errorCode: .serverUnavailable),
        );
        await tester.pump();

        final finderErrorView = find.byType(ErrorView);

        expect(finderErrorView, findsOneWidget);

        final element = tester.element(finderErrorView);

        expect(
          find.text(S.of(element).appErrorServerUnavailable),
          findsOneWidget,
        );

        final finderRetryButton = find
            .text(S.of(element).errorViewTryAgain)
            .hitTestable();

        expect(finderRetryButton, findsOneWidget);

        await tester.tap(finderRetryButton);

        verify(
          () => dashboardBloc.add(any(that: isA<DashboardInitEvent>())),
        ).called(1);
      },
    );

    testWidgets('should show DashboardEmptyView', (tester) async {
      final streamController = StreamController<DashboardState>();
      addTearDown(streamController.close);

      whenListen(
        dashboardBloc,
        streamController.stream,
        initialState: DashboardState.initial(),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: dashboardBloc)],
        child: const DashboardScreen(),
      );

      verify(
        () => dashboardBloc.add(any(that: isA<DashboardInitEvent>())),
      ).called(1);

      streamController.add(DashboardState(status: .loaded, listOfCrypto: []));
      await tester.pump();

      expect(find.byType(DashboardEmptyView), findsOneWidget);
    });

    testWidgets('should show DashboardCryptocurrencyList', (tester) async {
      final streamController = StreamController<DashboardState>();
      addTearDown(streamController.close);

      whenListen(
        dashboardBloc,
        streamController.stream,
        initialState: DashboardState.initial(),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: dashboardBloc)],
        child: const DashboardScreen(),
      );

      verify(
        () => dashboardBloc.add(any(that: isA<DashboardInitEvent>())),
      ).called(1);

      final expectedList = List.generate(20, (index) => cryptocurrency(index));

      streamController.add(
        DashboardState(status: .loaded, listOfCrypto: expectedList),
      );
      await tester.pump();

      final finderList = find.byType(DashboardCryptocurrencyList);

      expect(finderList, findsOneWidget);

      final listWidget = tester.widget<DashboardCryptocurrencyList>(finderList);

      expect(listWidget.listOfCrypto, expectedList);
      expect(listWidget.paginationLoading, isFalse);
    });

    testWidgets(
      'should show user image, when loading placeholder is false, when loaded and image is null => placeholder is true, when loaded and image != null => placeholder is false',
      (tester) async {
        final streamController = StreamController<DashboardState>();
        addTearDown(streamController.close);

        whenListen(
          dashboardBloc,
          streamController.stream,
          initialState: DashboardState.initial(),
        );

        await pumpTestApp(
          tester,
          providers: [BlocProvider.value(value: dashboardBloc)],
          child: const DashboardScreen(),
        );

        verify(
          () => dashboardBloc.add(any(that: isA<DashboardInitEvent>())),
        ).called(1);

        final finderTitle = find.byType(AppTitleProfile);

        expect(finderTitle, findsOneWidget);

        final finderUserImage = find.descendant(
          of: finderTitle,
          matching: find.byType(AppCachedImage),
        );

        expect(finderUserImage, findsOneWidget);

        final userImageWidget = tester.widget<AppCachedImage>(finderUserImage);

        expect(userImageWidget.imageUrl, isNull);
        expect(userImageWidget.needPlaceHolder, isFalse);

        streamController.add(DashboardState(status: .loaded, userImage: null));
        await tester.pump();

        final secondUserImageWidget = tester.widget<AppCachedImage>(
          finderUserImage,
        );

        expect(secondUserImageWidget.imageUrl, isNull);
        expect(secondUserImageWidget.needPlaceHolder, isTrue);

        streamController.add(
          DashboardState(status: .loaded, userImage: 'https://example.test'),
        );
        await tester.pump();

        final thirdUserImageWidget = tester.widget<AppCachedImage>(
          finderUserImage,
        );

        expect(thirdUserImageWidget.imageUrl, 'https://example.test');
        expect(thirdUserImageWidget.needPlaceHolder, isFalse);
      },
    );

    testWidgets(
      'should send DashboardRefreshDataEvent and complete refresh future',
      (tester) async {
        final streamController = StreamController<DashboardState>();
        addTearDown(streamController.close);

        final listOfCrypto = [cryptocurrency(1)];

        whenListen(
          dashboardBloc,
          streamController.stream,
          initialState: DashboardState(
            status: .loaded,
            listOfCrypto: listOfCrypto,
          ),
        );

        await pumpTestApp(
          tester,
          providers: [BlocProvider.value(value: dashboardBloc)],
          child: const DashboardScreen(),
        );

        verify(
          () => dashboardBloc.add(any(that: isA<DashboardInitEvent>())),
        ).called(1);

        final finderList = find.byType(DashboardCryptocurrencyList);

        expect(finderList, findsOneWidget);

        final listWidget = tester.widget<DashboardCryptocurrencyList>(
          finderList,
        );

        final refreshFuture = listWidget.onRefresh();

        final capturedEvent =
            verify(
                  () => dashboardBloc.add(
                    captureAny(that: isA<DashboardRefreshDataEvent>()),
                  ),
                ).captured.single
                as DashboardRefreshDataEvent;

        expect(capturedEvent.completer.isCompleted, isFalse);

        var refreshCompleted = false;

        final completionProbe = refreshFuture.then((_) {
          refreshCompleted = true;
        });

        await tester.pump();

        expect(refreshCompleted, isFalse);

        capturedEvent.completer.complete();

        await completionProbe;

        expect(capturedEvent.completer.isCompleted, isTrue);
        expect(refreshCompleted, isTrue);
      },
    );

    testWidgets('should send DashboardNextPageEvent', (tester) async {
      final streamController = StreamController<DashboardState>();
      addTearDown(streamController.close);

      final listOfCrypto = [cryptocurrency(1)];

      whenListen(
        dashboardBloc,
        streamController.stream,
        initialState: DashboardState(
          status: .loaded,
          listOfCrypto: listOfCrypto,
        ),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: dashboardBloc)],
        child: const DashboardScreen(),
      );

      verify(
        () => dashboardBloc.add(any(that: isA<DashboardInitEvent>())),
      ).called(1);

      final finderList = find.byType(DashboardCryptocurrencyList);

      expect(finderList, findsOneWidget);

      final listWidget = tester.widget<DashboardCryptocurrencyList>(finderList);

      listWidget.onScroll();

      verify(
        () => dashboardBloc.add(any(that: isA<DashboardNextPageEvent>())),
      ).called(1);
    });

    testWidgets('should show SnackBar', (tester) async {
      final streamController = StreamController<DashboardState>();
      addTearDown(streamController.close);

      final listOfCrypto = [cryptocurrency(1)];

      whenListen(
        dashboardBloc,
        streamController.stream,
        initialState: DashboardState(
          status: .loaded,
          listOfCrypto: listOfCrypto,
        ),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: dashboardBloc)],
        child: const DashboardScreen(),
      );

      verify(
        () => dashboardBloc.add(any(that: isA<DashboardInitEvent>())),
      ).called(1);

      final finderList = find.byType(DashboardCryptocurrencyList);

      expect(finderList, findsOneWidget);

      final element = tester.element(finderList);

      streamController.add(
        DashboardState(
          status: .loaded,
          listOfCrypto: listOfCrypto,
          alertMessage: .error(.invalidResponse),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(S.of(element).appErrorInvalidResponse), findsOneWidget);
    });
  });
}
