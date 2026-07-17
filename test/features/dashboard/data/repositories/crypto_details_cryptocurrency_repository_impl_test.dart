import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/crypto_details_datasource.dart';
import 'package:pet_crypto/features/dashboard/data/models/crypto_info_response_model.dart';
import 'package:pet_crypto/features/dashboard/data/repositories/crypto_details_cryptocurrency_repository_impl.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/crypto_info.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/crypto_details_cryptocurrency_repository.dart';

class MockCryptoDetailsDatasource extends Mock
    implements CryptoDetailsDatasource {}

void main() {
  late CryptoDetailsDatasource mockCryptoDetailsDatasource;
  late CryptoDetailsCryptocurrencyRepository cryptocurrencyRepository;

  setUp(() {
    mockCryptoDetailsDatasource = MockCryptoDetailsDatasource();
    cryptocurrencyRepository = CryptoDetailsCryptocurrencyRepositoryImpl(
      remote: mockCryptoDetailsDatasource,
    );
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class CryptoDetailsCryptocurrencyRepositoryImpl', () {
    group('method fetchCryptoInfo', () {
      test('should return Ok<CryptoInfo>', () async {
        when(
          () => mockCryptoDetailsDatasource.fetchCryptoInfo(any()),
        ).thenAnswer(
          (_) => Future(
            () => CryptoInfoResponseModel(
              data: {
                '1': CryptoInfoDataModel(id: 1, name: 'Bitcoin', symbol: 'BTC'),
              },
            ),
          ),
        );

        Result<CryptoInfo> actualResponse = await cryptocurrencyRepository
            .fetchCryptoInfo(1);

        expect(actualResponse, isA<Ok<CryptoInfo>>());
        expect((actualResponse as Ok<CryptoInfo>).value.name, 'Bitcoin');
        expect(actualResponse.value.symbol, 'BTC');
        verify(
          () => mockCryptoDetailsDatasource.fetchCryptoInfo(any()),
        ).called(1);
      });

      test('should return Err', () async {
        when(
          () => mockCryptoDetailsDatasource.fetchCryptoInfo(any()),
        ).thenThrow(
          AuthorizationException(
            .accessDenied,
            technicalMessage: 'Something went wrong',
          ),
        );

        Result<CryptoInfo> actualResponse = await cryptocurrencyRepository
            .fetchCryptoInfo(1);

        expect(actualResponse, isA<Err<CryptoInfo>>());
        expect(
          (actualResponse as Err<CryptoInfo>).failure,
          isA<AuthorizationFailure>(),
        );
        verify(
          () => mockCryptoDetailsDatasource.fetchCryptoInfo(any()),
        ).called(1);
      });
    });
  });
}
