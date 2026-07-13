import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/dashboard_cryptocurrency_repository.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/dashboard_get_cryptocurrency.dart';

class MockDashboardCryptocurrencyRepository extends Mock
    implements DashboardCryptocurrencyRepository {}

void main() {
  late DashboardCryptocurrencyRepository mockDashboardCryptocurrencyRepository;
  late DashboardGetCryptocurrency dashboardGetCryptocurrency;

  setUp(() {
    mockDashboardCryptocurrencyRepository =
        MockDashboardCryptocurrencyRepository();
    dashboardGetCryptocurrency = DashboardGetCryptocurrency(
      repo: mockDashboardCryptocurrencyRepository,
    );
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class DashboardGetCryptocurrency', () {
    group('method call', () {
      test('should return Ok<List<DashboardCryptocurrency>>', () async {
        when(
          () => mockDashboardCryptocurrencyRepository.getCryptocurrency(),
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

        Result<List<DashboardCryptocurrency>> actualResponse =
            await dashboardGetCryptocurrency.call();

        expect(actualResponse, isA<Ok<List<DashboardCryptocurrency>>>());
        expect(
          (actualResponse as Ok<List<DashboardCryptocurrency>>).value,
          isNotEmpty,
        );
        expect(actualResponse.value.first.id, 1);
        expect(actualResponse.value.first.name, 'Bitcoin');
        expect(actualResponse.value.first.symbol, 'BTC');
        verify(
          () => mockDashboardCryptocurrencyRepository.getCryptocurrency(),
        ).called(1);
      });

      test('should return Err', () async {
        when(
          () => mockDashboardCryptocurrencyRepository.getCryptocurrency(),
        ).thenAnswer(
          (_) =>
              Future(() => Err(AuthorizationFailure('Something went wrong'))),
        );

        Result<List<DashboardCryptocurrency>> actualResponse =
            await dashboardGetCryptocurrency.call();

        expect(actualResponse, isA<Err<List<DashboardCryptocurrency>>>());
        expect(
          (actualResponse as Err<List<DashboardCryptocurrency>>).failure,
          isA<AuthorizationFailure>(),
        );
        verify(
          () => mockDashboardCryptocurrencyRepository.getCryptocurrency(),
        ).called(1);
      });
    });
  });
}
