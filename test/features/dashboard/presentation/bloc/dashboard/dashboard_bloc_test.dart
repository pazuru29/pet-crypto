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

DashboardCryptocurrency cryptocurrency(int id) => DashboardCryptocurrency(
  id: id,
  name: 'Crypto $id',
  symbol: 'C$id',
  prices: const [],
);

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
          when(() => mockDashboardGetUserImage.call()).thenAnswer(
            (_) => Err(
              StorageFailure(
                .storageFailure,
                technicalMessage: 'Something went wrong',
              ),
            ),
          );
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
            alertMessage: BlocMessage.error(.storageFailure),
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
            (_) => Future(
              () => Err(
                AuthorizationFailure(
                  .accessDenied,
                  technicalMessage: 'Something went wrong',
                ),
              ),
            ),
          );
          return dashboardBloc;
        },
        act: (bloc) => bloc.add(DashboardInitEvent()),
        expect: () => [
          DashboardState(status: .loading),
          DashboardState(status: .loading, userImage: 'image'),
          DashboardState(
            status: .error,
            errorCode: .accessDenied,
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
            (_) => Future(() => Ok(List.generate(20, cryptocurrency))),
          );

          return dashboardBloc;
        },
        seed: () => DashboardState(
          status: .loaded,
          listOfCrypto: List.generate(40, cryptocurrency),
          currentPaginationStart: 21,
          currentPaginationLimit: 20,
        ),
        act: (bloc) =>
            bloc.add(DashboardRefreshDataEvent(completer: completer)),
        expect: () => [
          DashboardState(
            status: .loaded,
            listOfCrypto: List.generate(20, cryptocurrency),
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
            hasNextPage: true,
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
            (_) => Future(
              () => Err(
                AuthorizationFailure(
                  .accessDenied,
                  technicalMessage: 'Something went wrong',
                ),
              ),
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
            listOfCrypto: [],
            currentPaginationStart: 21,
            currentPaginationLimit: 20,
            alertMessage: BlocMessage.error(.accessDenied),
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
            (_) => Future(() => Ok(List.generate(20, cryptocurrency))),
          );
          return dashboardBloc;
        },
        seed: () => DashboardState(
          status: .loaded,
          listOfCrypto: List.generate(20, cryptocurrency),
          currentPaginationStart: 1,
          currentPaginationLimit: 20,
          hasNextPage: true,
        ),
        act: (bloc) => bloc.add(DashboardNextPageEvent()),
        expect: () => [
          DashboardState(
            status: .loaded,
            listOfCrypto: List.generate(20, cryptocurrency),
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
            hasNextPage: true,
            paginationLoading: true,
          ),
          DashboardState(
            status: .loaded,
            listOfCrypto: List.generate(
              40,
              (index) => cryptocurrency(index % 20),
            ),
            paginationLoading: false,
            hasNextPage: true,
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
            (_) => Future(
              () => Err(
                AuthorizationFailure(
                  .accessDenied,
                  technicalMessage: 'Something went wrong',
                ),
              ),
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
            alertMessage: BlocMessage.error(.accessDenied),
            listOfCrypto: [],
            paginationLoading: false,
            hasNextPage: true,
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
          ),
        ],
      );
    });

    group('concurrent events priority', () {
      blocTest(
        'init blocks refresh and completes its completer',
        build: () {
          when(
            () => mockDashboardGetUserImage.call(),
          ).thenAnswer((_) => const Ok(null));
          return dashboardBloc;
        },
        act: (bloc) async {
          final initStarted = Completer<void>();
          final initResult = Completer<Result<List<DashboardCryptocurrency>>>();
          final refreshCompleter = Completer<void>();

          when(
            () => mockDashboardGetCryptocurrency.call(
              request: any(named: 'request'),
            ),
          ).thenAnswer((_) {
            initStarted.complete();
            return initResult.future;
          });

          bloc.add(DashboardInitEvent());
          await initStarted.future;

          bloc.add(DashboardRefreshDataEvent(completer: refreshCompleter));
          await refreshCompleter.future;

          initResult.complete(const Ok([]));
        },
        expect: () => [
          DashboardState(status: .loading),
          DashboardState(status: .loaded),
        ],
        verify: (_) {
          verify(
            () => mockDashboardGetCryptocurrency.call(
              request: any(named: 'request'),
            ),
          ).called(1);
        },
      );

      blocTest(
        'init invalidates an active refresh result',
        build: () {
          when(
            () => mockDashboardGetUserImage.call(),
          ).thenAnswer((_) => const Ok(null));
          return dashboardBloc;
        },
        seed: () => DashboardState(
          status: .loaded,
          listOfCrypto: [cryptocurrency(0)],
          currentPaginationStart: 21,
          currentPaginationLimit: 20,
        ),
        act: (bloc) async {
          final refreshStarted = Completer<void>();
          final initStarted = Completer<void>();
          final refreshResult =
              Completer<Result<List<DashboardCryptocurrency>>>();
          final initResult = Completer<Result<List<DashboardCryptocurrency>>>();
          final refreshCompleter = Completer<void>();
          var callCount = 0;

          when(
            () => mockDashboardGetCryptocurrency.call(
              request: any(named: 'request'),
            ),
          ).thenAnswer((_) {
            callCount++;

            if (callCount == 1) {
              refreshStarted.complete();
              return refreshResult.future;
            }

            initStarted.complete();
            return initResult.future;
          });

          bloc.add(DashboardRefreshDataEvent(completer: refreshCompleter));
          await refreshStarted.future;

          bloc.add(DashboardInitEvent());
          await initStarted.future;

          initResult.complete(Ok([cryptocurrency(1)]));
          refreshResult.complete(Ok([cryptocurrency(2)]));
          await refreshCompleter.future;
        },
        expect: () => [
          DashboardState(
            status: .loading,
            listOfCrypto: [cryptocurrency(0)],
            currentPaginationStart: 21,
            currentPaginationLimit: 20,
          ),
          DashboardState(
            status: .loaded,
            listOfCrypto: [cryptocurrency(1)],
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
          ),
        ],
      );

      blocTest(
        'refresh invalidates an active pagination result',
        build: () => dashboardBloc,
        seed: () => DashboardState(
          status: .loaded,
          listOfCrypto: [cryptocurrency(0)],
          currentPaginationStart: 1,
          currentPaginationLimit: 20,
          hasNextPage: true,
        ),
        act: (bloc) async {
          final paginationStarted = Completer<void>();
          final refreshStarted = Completer<void>();
          final paginationResult =
              Completer<Result<List<DashboardCryptocurrency>>>();
          final refreshResult =
              Completer<Result<List<DashboardCryptocurrency>>>();
          final refreshCompleter = Completer<void>();

          when(
            () => mockDashboardGetCryptocurrency.call(
              request: any(named: 'request'),
            ),
          ).thenAnswer((invocation) {
            final request =
                invocation.namedArguments[#request]
                    as DashboardCryptocurrencyRequest;

            if (request.start == 21) {
              paginationStarted.complete();
              return paginationResult.future;
            }

            refreshStarted.complete();
            return refreshResult.future;
          });

          bloc.add(DashboardNextPageEvent());
          await paginationStarted.future;

          bloc.add(DashboardRefreshDataEvent(completer: refreshCompleter));
          await refreshStarted.future;

          refreshResult.complete(Ok([cryptocurrency(1)]));
          await refreshCompleter.future;

          paginationResult.complete(Ok([cryptocurrency(2)]));
        },
        expect: () => [
          DashboardState(
            status: .loaded,
            listOfCrypto: [cryptocurrency(0)],
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
            hasNextPage: true,
            paginationLoading: true,
          ),
          DashboardState(
            status: .loaded,
            listOfCrypto: [cryptocurrency(0)],
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
            hasNextPage: true,
          ),
          DashboardState(
            status: .loaded,
            listOfCrypto: [cryptocurrency(1)],
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
          ),
        ],
      );

      blocTest(
        'pagination does not start during refresh',
        build: () => dashboardBloc,
        seed: () => DashboardState(
          status: .loaded,
          listOfCrypto: [cryptocurrency(0)],
          currentPaginationStart: 1,
          currentPaginationLimit: 20,
          hasNextPage: true,
        ),
        act: (bloc) async {
          final refreshStarted = Completer<void>();
          final refreshResult =
              Completer<Result<List<DashboardCryptocurrency>>>();
          final refreshCompleter = Completer<void>();

          when(
            () => mockDashboardGetCryptocurrency.call(
              request: any(named: 'request'),
            ),
          ).thenAnswer((_) {
            refreshStarted.complete();
            return refreshResult.future;
          });

          bloc.add(DashboardRefreshDataEvent(completer: refreshCompleter));
          await refreshStarted.future;

          bloc.add(DashboardNextPageEvent());
          await Future.delayed(.zero);

          refreshResult.complete(Ok([cryptocurrency(1)]));
          await refreshCompleter.future;
        },
        expect: () => [
          DashboardState(
            status: .loaded,
            listOfCrypto: [cryptocurrency(1)],
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
          ),
        ],
        verify: (_) {
          verify(
            () => mockDashboardGetCryptocurrency.call(
              request: any(named: 'request'),
            ),
          ).called(1);
        },
      );

      blocTest(
        'active init invalidates pagination',
        build: () {
          when(
            () => mockDashboardGetUserImage.call(),
          ).thenAnswer((_) => const Ok(null));
          return dashboardBloc;
        },
        seed: () => DashboardState(
          status: .loaded,
          listOfCrypto: [cryptocurrency(0)],
          currentPaginationStart: 1,
          currentPaginationLimit: 20,
          hasNextPage: true,
        ),
        act: (bloc) async {
          final paginationStarted = Completer<void>();
          final initStarted = Completer<void>();

          final paginationResult =
              Completer<Result<List<DashboardCryptocurrency>>>();
          final initResult = Completer<Result<List<DashboardCryptocurrency>>>();

          when(
            () => mockDashboardGetCryptocurrency.call(
              request: any(named: 'request'),
            ),
          ).thenAnswer((invocation) {
            final request =
                invocation.namedArguments[#request]
                    as DashboardCryptocurrencyRequest;

            if (request.start == 21) {
              paginationStarted.complete();
              return paginationResult.future;
            }

            initStarted.complete();
            return initResult.future;
          });

          bloc.add(DashboardNextPageEvent());
          await paginationStarted.future;

          bloc.add(DashboardInitEvent());
          await initStarted.future;

          final initApplied = bloc.stream.firstWhere(
            (state) =>
                state.status == .loaded &&
                state.listOfCrypto.length == 1 &&
                state.listOfCrypto.first.id == 1,
          );

          initResult.complete(Ok([cryptocurrency(1)]));
          await initApplied;

          paginationResult.complete(Ok([cryptocurrency(2)]));
          await Future.delayed(.zero);
        },
        expect: () => [
          DashboardState(
            status: .loaded,
            listOfCrypto: [cryptocurrency(0)],
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
            hasNextPage: true,
            paginationLoading: true,
          ),
          DashboardState(
            status: .loading,
            listOfCrypto: [cryptocurrency(0)],
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
            hasNextPage: true,
            paginationLoading: false,
          ),
          DashboardState(
            status: .loaded,
            listOfCrypto: [cryptocurrency(1)],
            currentPaginationStart: 1,
            currentPaginationLimit: 20,
            hasNextPage: false,
            paginationLoading: false,
          ),
        ],
        verify: (_) {
          verify(
            () => mockDashboardGetCryptocurrency.call(
              request: any(named: 'request'),
            ),
          ).called(2);
        },
      );
    });
  });
}
