import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/profile/domain/repositories/app_settings_repository.dart';
import 'package:pet_crypto/features/profile/domain/usecases/profile_change_locale.dart';

class MockAppSettingsRepository extends Mock implements AppSettingsRepository {}

void main() {
  late AppSettingsRepository mockAppSettingsRepository;
  late ProfileChangeLocale profileChangeLocale;

  setUp(() {
    mockAppSettingsRepository = MockAppSettingsRepository();
    profileChangeLocale = ProfileChangeLocale(repo: mockAppSettingsRepository);
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class ProfileChangeLocale', () {
    group('method call', () {
      test('should return Ok(true)', () async {
        when(
          () => mockAppSettingsRepository.setLocale(any()),
        ).thenAnswer((_) => Future(() => Ok(true)));

        Result<bool> actualResponse = await profileChangeLocale.call('en');

        expect(actualResponse, isA<Ok<bool>>());
        expect((actualResponse as Ok<bool>).value, isTrue);
        verify(() => mockAppSettingsRepository.setLocale(any()));
      });

      test('should return Ok(false)', () async {
        when(
          () => mockAppSettingsRepository.setLocale(any()),
        ).thenAnswer((_) => Future(() => Ok(false)));

        Result<bool> actualResponse = await profileChangeLocale.call('en');

        expect(actualResponse, isA<Ok<bool>>());
        expect((actualResponse as Ok<bool>).value, isFalse);
        verify(() => mockAppSettingsRepository.setLocale(any()));
      });

      test('should return Err', () async {
        when(() => mockAppSettingsRepository.setLocale(any())).thenAnswer(
          (_) => Future(
            () => Err(
              StorageFailure(
                .storageFailure,
                technicalMessage: 'Something went wrong',
              ),
            ),
          ),
        );

        Result<bool> actualResponse = await profileChangeLocale.call('en');

        expect(actualResponse, isA<Err<bool>>());
        expect((actualResponse as Err<bool>).failure, isA<StorageFailure>());
        verify(() => mockAppSettingsRepository.setLocale(any()));
      });
    });
  });
}
