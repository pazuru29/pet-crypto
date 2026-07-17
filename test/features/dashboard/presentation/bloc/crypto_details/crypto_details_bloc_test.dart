import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/bloc/bloc_message.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/crypto_info.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/crypto_details_get_info.dart';
import 'package:pet_crypto/features/dashboard/presentation/bloc/crypto_details/crypto_details_bloc.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockCryptoDetailsGetInfo extends Mock implements CryptoDetailsGetInfo {}

class MockUrlLauncherPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

CryptoInfo cryptoInfo(int id) => CryptoInfo(name: 'Crypto $id', symbol: 'C$id');

void main() {
  late CryptoDetailsGetInfo mockCryptoDetailsGetInfo;
  late CryptoDetailsBloc cryptoDetailsBloc;

  setUp(() {
    mockCryptoDetailsGetInfo = MockCryptoDetailsGetInfo();
    cryptoDetailsBloc = CryptoDetailsBloc(getInfo: mockCryptoDetailsGetInfo);
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class CryptoDetailsBloc', () {
    group('event CryptoDetailsInitEvent', () {
      blocTest(
        'should finish with status loaded and info',
        build: () {
          when(
            () =>
                mockCryptoDetailsGetInfo.call(idString: any(named: 'idString')),
          ).thenAnswer((_) => Future(() => Ok(cryptoInfo(1))));
          return cryptoDetailsBloc;
        },
        act: (bloc) => bloc.add(CryptoDetailsInitEvent(id: '1')),
        expect: () => [
          CryptoDetailsState(status: .loading),
          CryptoDetailsState(status: .loaded, info: cryptoInfo(1)),
        ],
        verify: (_) {
          verify(
            () =>
                mockCryptoDetailsGetInfo.call(idString: any(named: 'idString')),
          ).called(1);
        },
      );

      blocTest(
        'should finish with status error and errorCode',
        build: () {
          when(
            () =>
                mockCryptoDetailsGetInfo.call(idString: any(named: 'idString')),
          ).thenAnswer(
            (_) => Future(
              () => Err(
                AuthorizationFailure(
                  .accessDenied,
                  technicalMessage: 'Something went wrong',
                ),
              ),
            ),
          );
          return cryptoDetailsBloc;
        },
        act: (bloc) => bloc.add(CryptoDetailsInitEvent(id: '1')),
        expect: () => [
          CryptoDetailsState(status: .loading),
          CryptoDetailsState(status: .error, errorCode: .accessDenied),
        ],
        verify: (_) {
          verify(
            () =>
                mockCryptoDetailsGetInfo.call(idString: any(named: 'idString')),
          ).called(1);
        },
      );
    });

    group('event CryptoDetailsOpenLinkEvent', () {
      late UrlLauncherPlatform originalUrlLauncher;
      late MockUrlLauncherPlatform mockUrlLauncher;

      setUp(() {
        originalUrlLauncher = UrlLauncherPlatform.instance;
        mockUrlLauncher = MockUrlLauncherPlatform();

        UrlLauncherPlatform.instance = mockUrlLauncher;

        registerFallbackValue(const LaunchOptions());
      });

      tearDown(() {
        UrlLauncherPlatform.instance = originalUrlLauncher;
        resetMocktailState();
      });

      blocTest(
        'should open link',
        build: () {
          when(
            () => mockUrlLauncher.launchUrl(any(), any()),
          ).thenAnswer((_) async => true);

          return cryptoDetailsBloc;
        },
        seed: () => CryptoDetailsState(status: .loaded),
        act: (bloc) =>
            bloc.add(CryptoDetailsOpenLinkEvent(link: 'https://bitcoin.org')),
        expect: () => [],
        verify: (_) {
          final captured = verify(
            () => mockUrlLauncher.launchUrl(captureAny(), captureAny()),
          ).captured;

          expect(captured[0], 'https://bitcoin.org');
          expect(
            (captured[1] as LaunchOptions).mode,
            PreferredLaunchMode.externalApplication,
          );
        },
      );

      blocTest(
        'should add openLinkFailed alert when launcher returns false',
        build: () {
          when(
            () => mockUrlLauncher.launchUrl(any(), any()),
          ).thenAnswer((_) async => false);

          return cryptoDetailsBloc;
        },
        seed: () => CryptoDetailsState(status: .loaded),
        act: (bloc) =>
            bloc.add(CryptoDetailsOpenLinkEvent(link: 'https://bitcoin.org')),
        expect: () => [
          CryptoDetailsState(
            status: .loaded,
            alertMessage: BlocMessage.error(.openLinkFailed),
          ),
        ],
        verify: (_) {
          final captured = verify(
            () => mockUrlLauncher.launchUrl(captureAny(), captureAny()),
          ).captured;

          expect(captured[0], 'https://bitcoin.org');
          expect(
            (captured[1] as LaunchOptions).mode,
            PreferredLaunchMode.externalApplication,
          );
        },
      );

      blocTest(
        'should add openLinkFailed alert when launcher throws',
        build: () {
          when(
            () => mockUrlLauncher.launchUrl(any(), any()),
          ).thenThrow(Exception('Something went wrong'));

          return cryptoDetailsBloc;
        },
        seed: () => CryptoDetailsState(status: .loaded),
        act: (bloc) =>
            bloc.add(CryptoDetailsOpenLinkEvent(link: 'https://bitcoin.org')),
        expect: () => [
          CryptoDetailsState(
            status: .loaded,
            alertMessage: BlocMessage.error(.openLinkFailed),
          ),
        ],
        verify: (_) {
          final captured = verify(
            () => mockUrlLauncher.launchUrl(captureAny(), captureAny()),
          ).captured;

          expect(captured[0], 'https://bitcoin.org');
          expect(
            (captured[1] as LaunchOptions).mode,
            PreferredLaunchMode.externalApplication,
          );
        },
      );

      blocTest(
        'should add invalidLink alert',
        build: () {
          when(
            () => mockUrlLauncher.launchUrl(any(), any()),
          ).thenAnswer((_) async => true);

          return cryptoDetailsBloc;
        },
        seed: () => CryptoDetailsState(status: .loaded),
        act: (bloc) => bloc.add(CryptoDetailsOpenLinkEvent(link: '://invalid')),
        expect: () => [
          CryptoDetailsState(
            status: .loaded,
            alertMessage: BlocMessage.error(.invalidLink),
          ),
        ],
        verify: (_) {
          verifyNever(
            () => mockUrlLauncher.launchUrl(captureAny(), captureAny()),
          );
        },
      );

      blocTest(
        'should add unsupportedLink alert',
        build: () {
          when(
            () => mockUrlLauncher.launchUrl(any(), any()),
          ).thenAnswer((_) async => true);

          return cryptoDetailsBloc;
        },
        seed: () => CryptoDetailsState(status: .loaded),
        act: (bloc) =>
            bloc.add(CryptoDetailsOpenLinkEvent(link: 'ftp://bitcoin.org')),
        expect: () => [
          CryptoDetailsState(
            status: .loaded,
            alertMessage: BlocMessage.error(.unsupportedLink),
          ),
        ],
        verify: (_) {
          verifyNever(
            () => mockUrlLauncher.launchUrl(captureAny(), captureAny()),
          );
        },
      );
    });
  });

  group('concurrent init events restartable', () {
    blocTest(
      'active second init invalidates previous init',
      build: () {
        return cryptoDetailsBloc;
      },
      act: (bloc) async {
        final firstStartedInitCompleter = Completer<void>();
        final firstResultInitCompleter = Completer<Result<CryptoInfo>>();
        final secondStartedInitCompleter = Completer<void>();
        final secondResultInitCompleter = Completer<Result<CryptoInfo>>();
        var callCount = 0;

        when(
          () => mockCryptoDetailsGetInfo.call(idString: any(named: 'idString')),
        ).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) {
            firstStartedInitCompleter.complete();
            return await firstResultInitCompleter.future;
          }

          secondStartedInitCompleter.complete();
          return await secondResultInitCompleter.future;
        });

        bloc.add(CryptoDetailsInitEvent(id: '1'));
        await firstStartedInitCompleter.future;

        bloc.add(CryptoDetailsInitEvent(id: '2'));
        await secondStartedInitCompleter.future;

        final secondResultApplied = bloc.stream.firstWhere(
          (state) => state.status == .loaded && state.info?.symbol == 'C2',
        );

        secondResultInitCompleter.complete(Ok(cryptoInfo(2)));
        await secondResultApplied;

        firstResultInitCompleter.complete(Ok(cryptoInfo(1)));
        await Future.delayed(.zero);
      },
      expect: () => [
        CryptoDetailsState(status: .loading),
        CryptoDetailsState(status: .loaded, info: cryptoInfo(2)),
      ],
      verify: (_) {
        verify(() => mockCryptoDetailsGetInfo.call(idString: '1')).called(1);
        verify(() => mockCryptoDetailsGetInfo.call(idString: '2')).called(1);
      },
    );
  });
}
