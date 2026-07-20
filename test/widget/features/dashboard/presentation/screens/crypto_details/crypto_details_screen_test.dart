import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/crypto_info.dart';
import 'package:pet_crypto/features/dashboard/presentation/bloc/crypto_details/crypto_details_bloc.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/crypto_details/crypto_details_screen.dart';
import 'package:pet_crypto/features/dashboard/presentation/screens/crypto_details/widgets/crypto_info_view.dart';
import 'package:pet_crypto/widgets/error_view.dart';
import 'package:pet_crypto/widgets/loading_view.dart';

import '../../../../../helpers/widget_test_harness.dart';

class MockCryptoDetailsBloc
    extends MockBloc<CryptoDetailsEvent, CryptoDetailsState>
    implements CryptoDetailsBloc {}

void main() {
  late CryptoDetailsBloc detailsBloc;

  setUpAll(() {
    registerFallbackValue(CryptoDetailsInitEvent(id: null));
  });

  setUp(() {
    detailsBloc = MockCryptoDetailsBloc();
  });

  group('Class CryptoDetailsScreen', () {
    testWidgets('should add CryptoDetailsInitEvent with id', (tester) async {
      whenListen(
        detailsBloc,
        Stream<CryptoDetailsState>.empty(),
        initialState: CryptoDetailsState.initial(),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: detailsBloc)],
        child: const CryptoDetailsScreen(id: '10'),
      );

      final capturedEvent =
          verify(
                () => detailsBloc.add(
                  captureAny(that: isA<CryptoDetailsInitEvent>()),
                ),
              ).captured.single
              as CryptoDetailsInitEvent;

      expect(capturedEvent.id, '10');
    });

    testWidgets('should show LoadingView', (tester) async {
      final streamController = StreamController<CryptoDetailsState>();
      addTearDown(streamController.close);

      whenListen(
        detailsBloc,
        streamController.stream,
        initialState: CryptoDetailsState.initial(),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: detailsBloc)],
        child: const CryptoDetailsScreen(id: '10'),
      );

      verify(
        () => detailsBloc.add(any(that: isA<CryptoDetailsInitEvent>())),
      ).called(1);

      streamController.add(CryptoDetailsState(status: .loading));
      await tester.pump();

      expect(find.byType(LoadingView), findsOneWidget);
    });

    testWidgets(
      'should show ErrorView and add CryptoDetailsInitEvent on try again',
      (tester) async {
        final streamController = StreamController<CryptoDetailsState>();
        addTearDown(streamController.close);

        whenListen(
          detailsBloc,
          streamController.stream,
          initialState: CryptoDetailsState.initial(),
        );

        await pumpTestApp(
          tester,
          providers: [BlocProvider.value(value: detailsBloc)],
          child: const CryptoDetailsScreen(id: '10'),
        );

        verify(
          () => detailsBloc.add(any(that: isA<CryptoDetailsInitEvent>())),
        ).called(1);

        streamController.add(
          CryptoDetailsState(status: .error, errorCode: .serverUnavailable),
        );
        await tester.pump();

        final finderDetailsScreen = find.byType(CryptoDetailsScreen);

        expect(finderDetailsScreen, findsOneWidget);

        final element = tester.element(finderDetailsScreen);

        expect(find.byType(ErrorView), findsOneWidget);
        expect(
          find.text(S.of(element).appErrorServerUnavailable),
          findsOneWidget,
        );

        final finderRetryButton = find
            .widgetWithText(ElevatedButton, S.of(element).errorViewTryAgain)
            .hitTestable();

        expect(finderRetryButton, findsOneWidget);

        await tester.tap(finderRetryButton);

        final capturedEvent =
            verify(
                  () => detailsBloc.add(
                    captureAny(that: isA<CryptoDetailsInitEvent>()),
                  ),
                ).captured.single
                as CryptoDetailsInitEvent;

        expect(capturedEvent.id, '10');
      },
    );

    testWidgets('should show CryptoInfoView', (tester) async {
      final expectedInfo = CryptoInfo(name: 'Crypto 1', symbol: 'C1');

      final streamController = StreamController<CryptoDetailsState>();
      addTearDown(streamController.close);

      whenListen(
        detailsBloc,
        streamController.stream,
        initialState: CryptoDetailsState.initial(),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: detailsBloc)],
        child: const CryptoDetailsScreen(id: '10'),
      );

      verify(
        () => detailsBloc.add(any(that: isA<CryptoDetailsInitEvent>())),
      ).called(1);

      streamController.add(
        CryptoDetailsState(status: .loaded, info: expectedInfo),
      );
      await tester.pump();

      final finderDetailsScreen = find.byType(CryptoDetailsScreen);

      expect(finderDetailsScreen, findsOneWidget);

      final infoFinder = find.byType(CryptoInfoView);

      expect(infoFinder, findsOneWidget);

      final infoWidget = tester.widget<CryptoInfoView>(infoFinder);

      expect(infoWidget.info, expectedInfo);
    });

    testWidgets(
      'should show CryptoInfoView and add CryptoDetailsOpenLinkEvent on tap link',
      (tester) async {
        final expectedLink = 'https://example.test';

        final expectedInfo = CryptoInfo(
          name: 'Crypto 1',
          symbol: 'C1',
          website: [expectedLink],
        );

        final streamController = StreamController<CryptoDetailsState>();
        addTearDown(streamController.close);

        whenListen(
          detailsBloc,
          streamController.stream,
          initialState: CryptoDetailsState.initial(),
        );

        await pumpTestApp(
          tester,
          providers: [BlocProvider.value(value: detailsBloc)],
          child: const CryptoDetailsScreen(id: '10'),
        );

        verify(
          () => detailsBloc.add(any(that: isA<CryptoDetailsInitEvent>())),
        ).called(1);

        streamController.add(
          CryptoDetailsState(status: .loaded, info: expectedInfo),
        );
        await tester.pump();

        final finderDetailsScreen = find.byType(CryptoDetailsScreen);

        expect(finderDetailsScreen, findsOneWidget);

        expect(find.byType(CryptoInfoView), findsOneWidget);

        final linkFinder = find.text(expectedLink);

        expect(linkFinder, findsOneWidget);

        await tester.tap(linkFinder);

        final capturedEvent =
            verify(
                  () => detailsBloc.add(
                    captureAny(that: isA<CryptoDetailsOpenLinkEvent>()),
                  ),
                ).captured.single
                as CryptoDetailsOpenLinkEvent;

        expect(capturedEvent.link, expectedLink);
      },
    );

    testWidgets('should show SnackBar', (tester) async {
      final expectedInfo = CryptoInfo(name: 'Crypto 1', symbol: 'C1');

      final streamController = StreamController<CryptoDetailsState>();
      addTearDown(streamController.close);

      whenListen(
        detailsBloc,
        streamController.stream,
        initialState: CryptoDetailsState.initial(),
      );

      await pumpTestApp(
        tester,
        providers: [BlocProvider.value(value: detailsBloc)],
        child: const CryptoDetailsScreen(id: '10'),
      );

      verify(
        () => detailsBloc.add(any(that: isA<CryptoDetailsInitEvent>())),
      ).called(1);

      streamController.add(
        CryptoDetailsState(status: .loaded, info: expectedInfo),
      );
      await tester.pump();

      final finderDetailsScreen = find.byType(CryptoDetailsScreen);

      expect(finderDetailsScreen, findsOneWidget);

      final element = tester.element(finderDetailsScreen);

      streamController.add(
        CryptoDetailsState(
          status: .loaded,
          info: expectedInfo,
          alertMessage: .error(.invalidLink),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(S.of(element).appErrorInvalidLink), findsOneWidget);
    });
  });
}
