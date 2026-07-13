import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/dashboard_cryptocurrency_datasource.dart';
import 'package:pet_crypto/features/dashboard/data/models/dashboard_cryptocurrency_response_model.dart';
import 'package:pet_crypto/features/dashboard/data/repositories/dashboard_cryptocurrency_repository_impl.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/dashboard_cryptocurrency_repository.dart';

class MockDashboardCryptocurrencyDatasource extends Mock
    implements DashboardCryptocurrencyDatasource {}

void main() {
  late DashboardCryptocurrencyDatasource mockDashboardCryptocurrencyDatasource;
  late DashboardCryptocurrencyRepository dashboardCryptocurrencyRepository;

  setUp(() {
    mockDashboardCryptocurrencyDatasource =
        MockDashboardCryptocurrencyDatasource();
    dashboardCryptocurrencyRepository = DashboardCryptocurrencyRepositoryImpl(
      remote: mockDashboardCryptocurrencyDatasource,
    );
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class DashboardCryptocurrencyRepositoryImpl', () {
    group('method getCryptocurrency', () {
      test('should return Ok<List<DashboardCryptocurrency>>', () async {
        when(
          () => mockDashboardCryptocurrencyDatasource.fetchCryptoCurrency(),
        ).thenAnswer(
          (_) => Future(
            () => DashboardCryptocurrencyResponseModel(
              data: [
                DashboardCryptocurrencyModel(
                  id: 1,
                  name: 'Bitcoin',
                  symbol: 'BTC',
                ),
              ],
            ),
          ),
        );

        Result<List<DashboardCryptocurrency>> actualResponse =
            await dashboardCryptocurrencyRepository.getCryptocurrency();

        expect(actualResponse, isA<Ok<List<DashboardCryptocurrency>>>());
        expect(
          (actualResponse as Ok<List<DashboardCryptocurrency>>).value,
          isNotEmpty,
        );
        expect(actualResponse.value.first.id, 1);
        expect(actualResponse.value.first.name, 'Bitcoin');
        expect(actualResponse.value.first.symbol, 'BTC');
        verify(
          () => mockDashboardCryptocurrencyDatasource.fetchCryptoCurrency(),
        ).called(1);
      });

      test('should return Err', () async {
        when(
          () => mockDashboardCryptocurrencyDatasource.fetchCryptoCurrency(),
        ).thenThrow(AuthorizationException('Something went wrong'));

        Result<List<DashboardCryptocurrency>> actualResponse =
            await dashboardCryptocurrencyRepository.getCryptocurrency();

        expect(actualResponse, isA<Err<List<DashboardCryptocurrency>>>());
        expect(
          (actualResponse as Err<List<DashboardCryptocurrency>>).failure,
          isA<AuthorizationFailure>(),
        );
        verify(
          () => mockDashboardCryptocurrencyDatasource.fetchCryptoCurrency(),
        ).called(1);
      });
    });
  });
}
