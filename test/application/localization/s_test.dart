import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/storage/preferences_storage.dart';

class MockPreferencesStorage extends Mock implements PreferencesStorage {}

void main() {
  late PreferencesStorage mockPreferencesStorage;
  late S localeProvider;

  setUp(() {
    mockPreferencesStorage = MockPreferencesStorage();
    localeProvider = S(storage: mockPreferencesStorage);
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class S', () {
    group('method init', () {
      test('should set default initial locale', () {
        when(
          () => mockPreferencesStorage.getString(any()),
        ).thenAnswer((_) => 'ar');

        localeProvider.init();

        expect(localeProvider.locale.languageCode, 'en');
        verify(() => mockPreferencesStorage.getString(any())).called(1);
      });

      test('should set initial locale', () {
        when(
          () => mockPreferencesStorage.getString(any()),
        ).thenAnswer((_) => 'ru');

        localeProvider.init();

        expect(localeProvider.locale.languageCode, 'ru');
        verify(() => mockPreferencesStorage.getString(any())).called(1);
      });
    });

    group('method setLocale', () {
      setUp(() {
        when(
          () => mockPreferencesStorage.getString(any()),
        ).thenAnswer((_) => 'en');
        localeProvider.init();
      });

      test('should return Ok(true)', () async {
        expect(localeProvider.locale.languageCode, 'en');

        when(
          () => mockPreferencesStorage.setString(any(), any()),
        ).thenAnswer((_) => Future(() => true));

        Result<bool> actualResponse = await localeProvider.setLocale('ru');

        expect(actualResponse, isA<Ok<bool>>());
        expect((actualResponse as Ok<bool>).value, isTrue);
        expect(localeProvider.locale.languageCode, 'ru');
        verify(() => mockPreferencesStorage.setString(any(), any())).called(1);
      });

      test('should return Ok(false)', () async {
        expect(localeProvider.locale.languageCode, 'en');

        when(
          () => mockPreferencesStorage.setString(any(), any()),
        ).thenAnswer((_) => Future(() => true));

        Result<bool> actualResponse = await localeProvider.setLocale('en');

        expect(actualResponse, isA<Ok<bool>>());
        expect((actualResponse as Ok<bool>).value, isFalse);
        expect(localeProvider.locale.languageCode, 'en');
        verifyNever(() => mockPreferencesStorage.setString(any(), any()));
      });

      test('should return Err', () async {
        expect(localeProvider.locale.languageCode, 'en');

        when(
          () => mockPreferencesStorage.setString(any(), any()),
        ).thenAnswer((_) => Future(() => false));

        Result<bool> actualResponse = await localeProvider.setLocale('ru');

        expect(actualResponse, isA<Err<bool>>());
        expect((actualResponse as Err).failure, isA<StorageFailure>());
        expect(localeProvider.locale.languageCode, 'en');
        verify(() => mockPreferencesStorage.setString(any(), any())).called(1);
      });
    });
  });
}
