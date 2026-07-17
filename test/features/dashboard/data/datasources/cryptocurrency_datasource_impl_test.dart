import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/network/http_client/base_http_client.dart';
import 'package:pet_crypto/core/util/typedef.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/cryptocurrency_datasource.dart';
import 'package:pet_crypto/features/dashboard/data/datasources/cryptocurrency_datasource_impl.dart';
import 'package:pet_crypto/features/dashboard/data/models/crypto_info_response_model.dart';
import 'package:pet_crypto/features/dashboard/data/models/dashboard_cryptocurrency_request_model.dart';
import 'package:pet_crypto/features/dashboard/data/models/dashboard_cryptocurrency_response_model.dart';

class MockBaseHttpClient extends Mock implements BaseHttpClient {}

void main() {
  late BaseHttpClient mockBaseHttpClient;
  late CryptocurrencyDatasource cryptocurrencyDatasource;

  setUp(() {
    mockBaseHttpClient = MockBaseHttpClient();
    cryptocurrencyDatasource = CryptocurrencyDatasourceImpl(
      client: mockBaseHttpClient,
    );
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class CryptocurrencyDatasourceImpl', () {
    group('method fetchCryptoCurrency', () {
      test('should return DashboardCryptocurrencyResponseModel', () async {
        JSON shouldReturn = {
          'data': [
            {'id': 1, 'name': 'Bitcoin', 'symbol': 'BTC'},
          ],
        };

        when(
          () => mockBaseHttpClient.get<JSON>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) => Future(() => shouldReturn));

        DashboardCryptocurrencyResponseModel actualResponse =
            await cryptocurrencyDatasource.fetchCryptoCurrency();

        expect(actualResponse, isA<DashboardCryptocurrencyResponseModel>());
        expect(actualResponse.data, isNotNull);
        expect(actualResponse.data!, isNotEmpty);
        expect(actualResponse.data!.first.id, 1);
        expect(actualResponse.data!.first.name, 'Bitcoin');
        verify(
          () => mockBaseHttpClient.get<JSON>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      });

      test('should throw AuthorizationException', () async {
        when(
          () => mockBaseHttpClient.get<JSON>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            response: Response(
              requestOptions: RequestOptions(),
              statusCode: 401,
            ),
          ),
        );

        Future<DashboardCryptocurrencyResponseModel> Function({
          DashboardCryptocurrencyRequestModel? request,
        })
        call = cryptocurrencyDatasource.fetchCryptoCurrency;

        expect(call, throwsA(isA<AuthorizationException>()));
        verify(
          () => mockBaseHttpClient.get<JSON>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      });

      test('should throw ParsingException', () async {
        JSON shouldReturn = {
          'data': {'id': 1, 'name': 'Bitcoin', 'symbol': 'BTC'},
        };

        when(
          () => mockBaseHttpClient.get<JSON>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) => Future(() => shouldReturn));

        Future<DashboardCryptocurrencyResponseModel> Function({
          DashboardCryptocurrencyRequestModel? request,
        })
        call = cryptocurrencyDatasource.fetchCryptoCurrency;

        expect(call, throwsA(isA<ParsingException>()));
        verify(
          () => mockBaseHttpClient.get<JSON>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      });
    });

    group('method fetchCryptoInfo', () {
      test('should return CryptoInfoResponseModel', () async {
        JSON shouldReturn = {
          'data': {
            '1': {'id': 1, 'name': 'Bitcoin', 'symbol': 'BTC'},
          },
        };

        when(
          () => mockBaseHttpClient.get<JSON>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) => Future(() => shouldReturn));

        CryptoInfoResponseModel actualResponse = await cryptocurrencyDatasource
            .fetchCryptoInfo(1);

        expect(actualResponse, isA<CryptoInfoResponseModel>());
        expect(actualResponse.data, isNotNull);
        expect(actualResponse.data!, isNotEmpty);
        expect(actualResponse.data!.values.first.id, 1);
        expect(actualResponse.data!.values.first.name, 'Bitcoin');
        verify(
          () => mockBaseHttpClient.get<JSON>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      });

      test('should throw AuthorizationException', () async {
        when(
          () => mockBaseHttpClient.get<JSON>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            response: Response(
              requestOptions: RequestOptions(),
              statusCode: 401,
            ),
          ),
        );

        Future<CryptoInfoResponseModel> Function(int) call =
            cryptocurrencyDatasource.fetchCryptoInfo;

        expect(call(1), throwsA(isA<AuthorizationException>()));
        verify(
          () => mockBaseHttpClient.get<JSON>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      });

      test('should throw ParsingException', () async {
        JSON shouldReturn = {
          'data': {'id': 1, 'name': 'Bitcoin', 'symbol': 'BTC'},
        };

        when(
          () => mockBaseHttpClient.get<JSON>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) => Future(() => shouldReturn));

        Future<CryptoInfoResponseModel> Function(int) call =
            cryptocurrencyDatasource.fetchCryptoInfo;

        expect(call(1), throwsA(isA<ParsingException>()));
        verify(
          () => mockBaseHttpClient.get<JSON>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      });
    });
  });
}
