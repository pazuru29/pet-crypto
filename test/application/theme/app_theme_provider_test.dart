import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/application/theme/app_theme_provider.dart';
import 'package:pet_crypto/core/errors/app_error_code.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/storage/preferences_storage.dart';

class MockPreferencesStorage extends Mock implements PreferencesStorage {}

void main() {
  late PreferencesStorage mockPreferencesStorage;
  late AppThemeProvider themeProvider;

  setUp(() {
    mockPreferencesStorage = MockPreferencesStorage();
    themeProvider = AppThemeProvider(storage: mockPreferencesStorage);
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class AppThemeProvider', () {
    group('method init', () {
      test('should set default initial theme mode', () {
        when(() => mockPreferencesStorage.getInt(any())).thenAnswer((_) => 3);

        themeProvider.init();

        expect(themeProvider.mode.index, 0);
        verify(() => mockPreferencesStorage.getInt(any())).called(1);
      });

      test('should set initial theme mode', () {
        when(() => mockPreferencesStorage.getInt(any())).thenAnswer((_) => 1);

        themeProvider.init();

        expect(themeProvider.mode.index, 1);
        verify(() => mockPreferencesStorage.getInt(any())).called(1);
      });
    });

    group('method setMode', () {
      setUp(() {
        when(() => mockPreferencesStorage.getInt(any())).thenAnswer((_) => 0);
        themeProvider.init();
      });

      test('should return true', () async {
        expect(themeProvider.mode.index, 0);

        when(
          () => mockPreferencesStorage.setInt(any(), any()),
        ).thenAnswer((_) async {});

        bool actualResponse = await themeProvider.setMode(1);

        expect(actualResponse, isA<bool>());
        expect(actualResponse, isTrue);
        expect(themeProvider.mode.index, 1);
        verify(() => mockPreferencesStorage.setInt('themeMode', 1)).called(1);
      });

      test('should return false', () async {
        expect(themeProvider.mode.index, 0);

        when(
          () => mockPreferencesStorage.setInt(any(), any()),
        ).thenAnswer((_) async {});

        bool actualResponse = await themeProvider.setMode(0);

        expect(actualResponse, isA<bool>());
        expect(actualResponse, isFalse);
        expect(themeProvider.mode.index, 0);
        verifyNever(() => mockPreferencesStorage.setInt(any(), any()));
      });

      test('should throw StorageException', () async {
        expect(themeProvider.mode.index, 0);

        when(
          () => mockPreferencesStorage.setInt(any(), any()),
        ).thenThrow(StorageException());

        Future<bool> call = themeProvider.setMode(1);

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
        expect(themeProvider.mode.index, 0);
        verify(() => mockPreferencesStorage.setInt('themeMode', 1)).called(1);
      });
    });
  });
}
