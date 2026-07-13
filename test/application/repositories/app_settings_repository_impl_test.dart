import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/application/repositories/app_settings_repository_impl.dart';
import 'package:pet_crypto/application/theme/app_theme_provider.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/profile/domain/repositories/app_settings_repository.dart';

class MockS extends Mock implements S {}

class MockAppThemeProvider extends Mock implements AppThemeProvider {}

void main() {
  late S mockS;
  late AppThemeProvider mockAppThemeProvider;
  late AppSettingsRepository appSettingsRepository;

  setUp(() {
    mockS = MockS();
    mockAppThemeProvider = MockAppThemeProvider();
    appSettingsRepository = AppSettingsRepositoryImpl(
      localeProvider: mockS,
      themeProvider: mockAppThemeProvider,
    );
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class AppSettingsRepository', () {
    group('method setLocale', () {
      test('should return Ok(true)', () async {
        when(
          () => mockS.setLocale(any()),
        ).thenAnswer((_) => Future(() => Ok(true)));

        Result<bool> actualResponse = await appSettingsRepository.setLocale(
          'en',
        );

        expect(actualResponse, isA<Ok<bool>>());
        expect((actualResponse as Ok<bool>).value, isTrue);
        verify(() => mockS.setLocale(any()));
      });

      test('should return Ok(false)', () async {
        when(
          () => mockS.setLocale(any()),
        ).thenAnswer((_) => Future(() => Ok(false)));

        Result<bool> actualResponse = await appSettingsRepository.setLocale(
          'en',
        );

        expect(actualResponse, isA<Ok<bool>>());
        expect((actualResponse as Ok<bool>).value, isFalse);
        verify(() => mockS.setLocale(any()));
      });

      test('should return Err', () async {
        when(() => mockS.setLocale(any())).thenAnswer(
          (_) => Future(() => Err(StorageFailure('Something went wrong'))),
        );

        Result<bool> actualResponse = await appSettingsRepository.setLocale(
          'en',
        );

        expect(actualResponse, isA<Err<bool>>());
        expect((actualResponse as Err<bool>).failure, isA<StorageFailure>());
        verify(() => mockS.setLocale(any()));
      });
    });

    group('method setThemeMode', () {
      test('should return Ok(true)', () async {
        when(
          () => mockAppThemeProvider.setMode(any()),
        ).thenAnswer((_) => Future(() => Ok(true)));

        Result<bool> actualResponse = await appSettingsRepository.setThemeMode(
          0,
        );

        expect(actualResponse, isA<Ok<bool>>());
        expect((actualResponse as Ok<bool>).value, isTrue);
        verify(() => mockAppThemeProvider.setMode(any()));
      });

      test('should return Ok(false)', () async {
        when(
          () => mockAppThemeProvider.setMode(any()),
        ).thenAnswer((_) => Future(() => Ok(false)));

        Result<bool> actualResponse = await appSettingsRepository.setThemeMode(
          0,
        );

        expect(actualResponse, isA<Ok<bool>>());
        expect((actualResponse as Ok<bool>).value, isFalse);
        verify(() => mockAppThemeProvider.setMode(any()));
      });

      test('should return Err', () async {
        when(() => mockAppThemeProvider.setMode(any())).thenAnswer(
          (_) => Future(() => Err(StorageFailure('Something went wrong'))),
        );

        Result<bool> actualResponse = await appSettingsRepository.setThemeMode(
          0,
        );

        expect(actualResponse, isA<Err<bool>>());
        expect((actualResponse as Err<bool>).failure, isA<StorageFailure>());
        verify(() => mockAppThemeProvider.setMode(any()));
      });
    });
  });
}
