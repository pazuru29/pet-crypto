import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/profile/domain/repositories/app_settings_repository.dart';
import 'package:pet_crypto/features/profile/domain/usecases/profile_change_theme_mode.dart';

class MockAppSettingsRepository extends Mock implements AppSettingsRepository {}

void main() {
  late AppSettingsRepository mockAppSettingsRepository;
  late ProfileChangeThemeMode profileChangeThemeMode;

  setUp(() {
    mockAppSettingsRepository = MockAppSettingsRepository();
    profileChangeThemeMode = ProfileChangeThemeMode(
      repo: mockAppSettingsRepository,
    );
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class ProfileChangeThemeMode', () {
    group('method call', () {
      test('should return Ok(true)', () async {
        when(
          () => mockAppSettingsRepository.setThemeMode(any()),
        ).thenAnswer((_) => Future(() => Ok(true)));

        Result<bool> actualResponse = await profileChangeThemeMode.call(0);

        expect(actualResponse, isA<Ok<bool>>());
        expect((actualResponse as Ok<bool>).value, isTrue);
        verify(() => mockAppSettingsRepository.setThemeMode(any()));
      });

      test('should return Ok(false)', () async {
        when(
          () => mockAppSettingsRepository.setThemeMode(any()),
        ).thenAnswer((_) => Future(() => Ok(false)));

        Result<bool> actualResponse = await profileChangeThemeMode.call(0);

        expect(actualResponse, isA<Ok<bool>>());
        expect((actualResponse as Ok<bool>).value, isFalse);
        verify(() => mockAppSettingsRepository.setThemeMode(any()));
      });

      test('should return Err', () async {
        when(() => mockAppSettingsRepository.setThemeMode(any())).thenAnswer(
          (_) => Future(() => Err(StorageFailure('Something went wrong'))),
        );

        Result<bool> actualResponse = await profileChangeThemeMode.call(0);

        expect(actualResponse, isA<Err<bool>>());
        expect((actualResponse as Err<bool>).failure, isA<StorageFailure>());
        verify(() => mockAppSettingsRepository.setThemeMode(any()));
      });
    });
  });
}
