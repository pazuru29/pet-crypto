import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/application/theme/app_theme_provider.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
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
      });

      test('should set initial theme mode', () {
        when(() => mockPreferencesStorage.getInt(any())).thenAnswer((_) => 1);

        themeProvider.init();

        expect(themeProvider.mode.index, 1);
      });
    });

    group('method setMode', () {
      setUp(() {
        when(() => mockPreferencesStorage.getInt(any())).thenAnswer((_) => 0);
        themeProvider.init();
      });

      test('should return Ok(true)', () async {
        expect(themeProvider.mode.index, 0);

        when(
          () => mockPreferencesStorage.setInt(any(), any()),
        ).thenAnswer((_) => Future(() => true));

        Result<bool> actualResponse = await themeProvider.setMode(1);

        expect(actualResponse, isA<Ok<bool>>());
        expect((actualResponse as Ok<bool>).value, isTrue);
        expect(themeProvider.mode.index, 1);
      });

      test('should return Ok(false)', () async {
        expect(themeProvider.mode.index, 0);

        when(
          () => mockPreferencesStorage.setInt(any(), any()),
        ).thenAnswer((_) => Future(() => true));

        Result<bool> actualResponse = await themeProvider.setMode(0);

        expect(actualResponse, isA<Ok<bool>>());
        expect((actualResponse as Ok<bool>).value, isFalse);
        expect(themeProvider.mode.index, 0);
      });

      test('should return Err', () async {
        expect(themeProvider.mode.index, 0);

        when(
          () => mockPreferencesStorage.setInt(any(), any()),
        ).thenAnswer((_) => Future(() => false));

        Result<bool> actualResponse = await themeProvider.setMode(1);

        expect(actualResponse, isA<Err<bool>>());
        expect((actualResponse as Err).failure, isA<StorageFailure>());
        expect(themeProvider.mode.index, 0);
      });
    });
  });
}
