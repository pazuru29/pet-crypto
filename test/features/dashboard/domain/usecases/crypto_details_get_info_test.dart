import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/crypto_info.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/crypto_details_cryptocurrency_repository.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/crypto_details_get_info.dart';

class MockCryptoDetailsCryptocurrencyRepository extends Mock
    implements CryptoDetailsCryptocurrencyRepository {}

void main() {
  late CryptoDetailsCryptocurrencyRepository
  mockCryptoDetailsCryptocurrencyRepository;
  late CryptoDetailsGetInfo cryptoDetailsGetInfo;

  setUp(() {
    mockCryptoDetailsCryptocurrencyRepository =
        MockCryptoDetailsCryptocurrencyRepository();
    cryptoDetailsGetInfo = CryptoDetailsGetInfo(
      repo: mockCryptoDetailsCryptocurrencyRepository,
    );
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class CryptoDetailsGetInfo', () {
    group('method call', () {
      test('should return Ok<CryptoInfo>', () async {
        when(
          () =>
              mockCryptoDetailsCryptocurrencyRepository.fetchCryptoInfo(any()),
        ).thenAnswer(
          (_) => Future(() => Ok(CryptoInfo(name: 'Bitcoin', symbol: 'BTC'))),
        );

        Result<CryptoInfo> actualResponse = await cryptoDetailsGetInfo.call(
          idString: '1',
        );

        expect(actualResponse, isA<Ok<CryptoInfo>>());
        expect((actualResponse as Ok<CryptoInfo>).value.name, 'Bitcoin');
        expect(actualResponse.value.symbol, 'BTC');
        verify(
          () =>
              mockCryptoDetailsCryptocurrencyRepository.fetchCryptoInfo(any()),
        ).called(1);
      });

      test('should return Err(AuthorizationFailure)', () async {
        when(
          () =>
              mockCryptoDetailsCryptocurrencyRepository.fetchCryptoInfo(any()),
        ).thenAnswer(
          (_) =>
              Future(() => Err(AuthorizationFailure('Something went wrong'))),
        );

        Result<CryptoInfo> actualResponse = await cryptoDetailsGetInfo.call(
          idString: '1',
        );

        expect(actualResponse, isA<Err<CryptoInfo>>());
        expect(
          (actualResponse as Err<CryptoInfo>).failure,
          isA<AuthorizationFailure>(),
        );
        verify(
          () =>
              mockCryptoDetailsCryptocurrencyRepository.fetchCryptoInfo(any()),
        ).called(1);
      });

      test('should return Err(RequestFailure)', () async {
        Result<CryptoInfo> actualResponse = await cryptoDetailsGetInfo.call(
          idString: null,
        );

        expect(actualResponse, isA<Err<CryptoInfo>>());
        expect(
          (actualResponse as Err<CryptoInfo>).failure,
          isA<RequestFailure>(),
        );
        verifyNever(
          () =>
              mockCryptoDetailsCryptocurrencyRepository.fetchCryptoInfo(any()),
        );
      });
    });
  });
}
