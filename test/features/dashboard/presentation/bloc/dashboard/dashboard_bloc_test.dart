import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/bloc/bloc_message.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency_request.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/dashboard_get_cryptocurrency.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/dashboard_get_user_image.dart';
import 'package:pet_crypto/features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';

class MockDashboardGetCryptocurrency extends Mock
    implements DashboardGetCryptocurrency {}

class MockDashboardGetUserImage extends Mock implements DashboardGetUserImage {}

void main() {
  late DashboardGetCryptocurrency mockDashboardGetCryptocurrency;
  late DashboardGetUserImage mockDashboardGetUserImage;
  late DashboardBloc dashboardBloc;

  setUp(() {
    mockDashboardGetCryptocurrency = MockDashboardGetCryptocurrency();
    mockDashboardGetUserImage = MockDashboardGetUserImage();
    dashboardBloc = DashboardBloc(
      getCryptocurrency: mockDashboardGetCryptocurrency,
      getUserImage: mockDashboardGetUserImage,
    );
    registerFallbackValue(DashboardCryptocurrencyRequest());
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class DashboardBloc', () {
    group('event DashboardInitEvent', () {
      blocTest(
        'should finish with loaded status and image',
        build: () {
          when(
            () => mockDashboardGetUserImage.call(),
          ).thenAnswer((_) => Ok('image'));
          when(
            () => mockDashboardGetCryptocurrency.call(
              request: any(named: 'request'),
            ),
          ).thenAnswer((_) => Future(() => Ok([])));
          return dashboardBloc;
        },
        act: (bloc) => bloc.add(DashboardInitEvent()),
        expect: () => [
          DashboardState(status: .loading),
          DashboardState(status: .loading, userImage: 'image'),
          DashboardState(
            status: .loaded,
            userImage: 'image',
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
            listOfCrypto: [],
            hasNextPage: false,
          ),
        ],
      );

      blocTest(
        'should finish with loaded status and null image',
        build: () {
          when(
            () => mockDashboardGetUserImage.call(),
          ).thenAnswer((_) => Ok(null));
          when(
            () => mockDashboardGetCryptocurrency.call(
              request: any(named: 'request'),
            ),
          ).thenAnswer((_) => Future(() => Ok([])));
          return dashboardBloc;
        },
        act: (bloc) => bloc.add(DashboardInitEvent()),
        expect: () => [
          DashboardState(status: .loading),
          DashboardState(
            status: .loaded,
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
            listOfCrypto: [],
            hasNextPage: false,
          ),
        ],
      );

      blocTest(
        'should finish with loaded status and error image',
        build: () {
          when(
            () => mockDashboardGetUserImage.call(),
          ).thenAnswer((_) => Err(StorageFailure('Something went wrong')));
          when(
            () => mockDashboardGetCryptocurrency.call(
              request: any(named: 'request'),
            ),
          ).thenAnswer((_) => Future(() => Ok([])));
          return dashboardBloc;
        },
        act: (bloc) => bloc.add(DashboardInitEvent()),
        expect: () => [
          DashboardState(status: .loading),
          DashboardState(
            status: .loading,
            alertMessage: BlocMessage.error('Something went wrong'),
          ),
          DashboardState(
            status: .loaded,
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
            listOfCrypto: [],
            hasNextPage: false,
          ),
        ],
      );

      blocTest(
        'should finish with loaded status and image',
        build: () {
          when(
            () => mockDashboardGetUserImage.call(),
          ).thenAnswer((_) => Ok('image'));
          when(
            () => mockDashboardGetCryptocurrency.call(
              request: any(named: 'request'),
            ),
          ).thenAnswer(
            (_) =>
                Future(() => Err(AuthorizationFailure('Something went wrong'))),
          );
          return dashboardBloc;
        },
        act: (bloc) => bloc.add(DashboardInitEvent()),
        expect: () => [
          DashboardState(status: .loading),
          DashboardState(status: .loading, userImage: 'image'),
          DashboardState(
            status: .error,
            errorMessage: 'Something went wrong',
            userImage: 'image',
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
          ),
        ],
      );
    });

    group('event DashboardRefreshDataEvent', () {
      late Completer completer;

      setUp(() {
        completer = Completer();
      });

      blocTest(
        'should refresh complete',
        build: () {
          when(
            () => mockDashboardGetCryptocurrency.call(
              request: any(named: 'request'),
            ),
          ).thenAnswer(
            (_) => Future(
              () => Ok([
                DashboardCryptocurrency(
                  id: 1,
                  name: 'Bitcoin',
                  symbol: 'BTC',
                  prices: [],
                ),
              ]),
            ),
          );

          return dashboardBloc;
        },
        seed: () => DashboardState(
          status: .loaded,
          listOfCrypto: [],
          currentPaginationStart: 21,
          currentPaginationLimit: 20,
        ),
        act: (bloc) =>
            bloc.add(DashboardRefreshDataEvent(completer: completer)),
        expect: () => [
          DashboardState(
            status: .loaded,
            listOfCrypto: [
              DashboardCryptocurrency(
                id: 1,
                name: 'Bitcoin',
                symbol: 'BTC',
                prices: [],
              ),
            ],
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
            hasNextPage: false,
          ),
        ],
        verify: (_) {
          expect(completer.isCompleted, isTrue);
        },
      );

      blocTest(
        'should refresh fail',
        build: () {
          when(
            () => mockDashboardGetCryptocurrency.call(
              request: any(named: 'request'),
            ),
          ).thenAnswer(
            (_) =>
                Future(() => Err(AuthorizationFailure('Something went wrong'))),
          );

          return dashboardBloc;
        },
        seed: () => DashboardState(
          status: .loaded,
          listOfCrypto: [],
          currentPaginationStart: 21,
          currentPaginationLimit: 20,
        ),
        act: (bloc) =>
            bloc.add(DashboardRefreshDataEvent(completer: completer)),
        expect: () => [
          DashboardState(
            status: .loaded,
            listOfCrypto: [],
            currentPaginationStart: 21,
            currentPaginationLimit: 20,
            alertMessage: BlocMessage.error('Something went wrong'),
          ),
        ],
        verify: (_) {
          expect(completer.isCompleted, isTrue);
        },
      );
    });

    group('event DashboardRefreshDataEvent', () {
      blocTest(
        'should scroll next complete',
        build: () {
          when(
            () => mockDashboardGetCryptocurrency.call(
              request: any(named: 'request'),
            ),
          ).thenAnswer(
            (_) => Future(
              () => Ok([
                DashboardCryptocurrency(
                  id: 1,
                  name: 'Bitcoin',
                  symbol: 'BTC',
                  prices: [],
                ),
              ]),
            ),
          );
          return dashboardBloc;
        },
        seed: () => DashboardState(
          status: .loaded,
          listOfCrypto: [],
          currentPaginationStart: 1,
          currentPaginationLimit: 20,
          hasNextPage: true,
        ),
        act: (bloc) => bloc.add(DashboardNextPageEvent()),
        expect: () => [
          DashboardState(
            status: .loaded,
            listOfCrypto: [],
            paginationLoading: true,
            hasNextPage: true,
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
          ),
          DashboardState(
            status: .loaded,
            listOfCrypto: [
              DashboardCryptocurrency(
                id: 1,
                name: 'Bitcoin',
                symbol: 'BTC',
                prices: [],
              ),
            ],
            paginationLoading: false,
            hasNextPage: false,
            currentPaginationStart: 21,
            currentPaginationLimit: 20,
          ),
        ],
      );

      blocTest(
        'should scroll next do nothing',
        build: () {
          return dashboardBloc;
        },
        seed: () => DashboardState(
          status: .loaded,
          listOfCrypto: [],
          currentPaginationStart: 1,
          currentPaginationLimit: 20,
          hasNextPage: false,
        ),
        act: (bloc) => bloc.add(DashboardNextPageEvent()),
        expect: () => [],
      );

      blocTest(
        'should scroll next fail',
        build: () {
          when(
            () => mockDashboardGetCryptocurrency.call(
              request: any(named: 'request'),
            ),
          ).thenAnswer(
            (_) =>
                Future(() => Err(AuthorizationFailure('Something went wrong'))),
          );
          return dashboardBloc;
        },
        seed: () => DashboardState(
          status: .loaded,
          listOfCrypto: [],
          currentPaginationStart: 1,
          currentPaginationLimit: 20,
          hasNextPage: true,
        ),
        act: (bloc) => bloc.add(DashboardNextPageEvent()),
        expect: () => [
          DashboardState(
            status: .loaded,
            listOfCrypto: [],
            paginationLoading: true,
            hasNextPage: true,
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
          ),
          DashboardState(
            status: .loaded,
            alertMessage: BlocMessage.error('Something went wrong'),
            listOfCrypto: [],
            paginationLoading: false,
            hasNextPage: true,
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
          ),
        ],
      );
    });
  });
}
