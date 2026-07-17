import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/core/errors/app_error_code.dart';
import 'package:pet_crypto/core/errors/exception.dart';
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
      test('should set default (en) initial locale', () {
        when(
          () => mockPreferencesStorage.getString(any()),
        ).thenAnswer((_) => 'ar');

        localeProvider.init();

        expect(localeProvider.locale.languageCode, 'en');
        verify(() => mockPreferencesStorage.getString(any())).called(1);
      });

      test('should set ru initial locale', () {
        when(
          () => mockPreferencesStorage.getString(any()),
        ).thenAnswer((_) => 'ru');

        localeProvider.init();

        expect(localeProvider.locale.languageCode, 'ru');
        verify(() => mockPreferencesStorage.getString(any())).called(1);
      });

      test('should set uk initial locale', () {
        when(
          () => mockPreferencesStorage.getString(any()),
        ).thenAnswer((_) => 'uk');

        localeProvider.init();

        expect(localeProvider.locale, const Locale('uk'));
        verify(() => mockPreferencesStorage.getString('locale')).called(1);
      });
    });

    group('method setLocale', () {
      setUp(() {
        when(
          () => mockPreferencesStorage.getString(any()),
        ).thenAnswer((_) => 'en');
        localeProvider.init();
      });

      test('should save ru locale', () async {
        expect(localeProvider.locale.languageCode, 'en');

        when(
          () => mockPreferencesStorage.setString(any(), any()),
        ).thenAnswer((_) async {});

        bool actualResponse = await localeProvider.setLocale('ru');

        expect(actualResponse, isA<bool>());
        expect(actualResponse, isTrue);
        expect(localeProvider.locale.languageCode, 'ru');
        verify(
          () => mockPreferencesStorage.setString('locale', 'ru'),
        ).called(1);
      });

      test('should save uk locale', () async {
        when(
          () => mockPreferencesStorage.setString(any(), any()),
        ).thenAnswer((_) async {});

        final actualResponse = await localeProvider.setLocale('uk');

        expect(actualResponse, isTrue);
        expect(localeProvider.locale, const Locale('uk'));
        verify(
          () => mockPreferencesStorage.setString('locale', 'uk'),
        ).called(1);
      });

      test('should return false', () async {
        expect(localeProvider.locale.languageCode, 'en');

        when(
          () => mockPreferencesStorage.setString(any(), any()),
        ).thenAnswer((_) async {});

        bool actualResponse = await localeProvider.setLocale('en');

        expect(actualResponse, isA<bool>());
        expect(actualResponse, isFalse);
        expect(localeProvider.locale.languageCode, 'en');
        verifyNever(() => mockPreferencesStorage.setString(any(), any()));
      });

      test('should throw StorageException', () async {
        expect(localeProvider.locale.languageCode, 'en');

        when(() => mockPreferencesStorage.setString(any(), any())).thenThrow(
          StorageException(
            technicalMessage: 'SharedPreferences.setString returned false',
          ),
        );

        Future<bool> call = localeProvider.setLocale('ru');

        await expectLater(
          call,
          throwsA(
            isA<StorageException>().having(
              (error) => error.code,
              'app error code',
              AppErrorCode.storageFailure,
            ),
          ),
        );
        expect(localeProvider.locale.languageCode, 'en');
        verify(
          () => mockPreferencesStorage.setString('locale', 'ru'),
        ).called(1);
      });
    });
  });
}
