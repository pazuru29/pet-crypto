import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/dashboard_local_repository.dart';
import 'package:pet_crypto/features/dashboard/domain/usecases/dashboard_get_user_image.dart';

class MockDashboardLocalRepository extends Mock
    implements DashboardLocalRepository {}

void main() {
  late DashboardLocalRepository mockDashboardLocalRepository;
  late DashboardGetUserImage dashboardGetUserImage;

  setUp(() {
    mockDashboardLocalRepository = MockDashboardLocalRepository();
    dashboardGetUserImage = DashboardGetUserImage(
      repo: mockDashboardLocalRepository,
    );
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class DashboardGetUserImage', () {
    group('method call', () {
      test('should return Ok(String)', () {
        when(
          () => mockDashboardLocalRepository.getUserImage(),
        ).thenAnswer((_) => Ok('image'));

        Result<String?> actualResponse = dashboardGetUserImage.call();

        expect(actualResponse, isA<Ok<String?>>());
        expect((actualResponse as Ok<String?>).value, isNotNull);
        expect(actualResponse.value, 'image');
        verify(() => mockDashboardLocalRepository.getUserImage()).called(1);
      });

      test('should return Ok(null)', () {
        when(
          () => mockDashboardLocalRepository.getUserImage(),
        ).thenAnswer((_) => Ok(null));

        Result<String?> actualResponse = dashboardGetUserImage.call();

        expect(actualResponse, isA<Ok<String?>>());
        expect((actualResponse as Ok<String?>).value, isNull);
        verify(() => mockDashboardLocalRepository.getUserImage()).called(1);
      });

      test('should return Err', () {
        when(() => mockDashboardLocalRepository.getUserImage()).thenAnswer(
          (_) => Err(
            StorageFailure(
              .storageFailure,
              technicalMessage: 'Something went wrong',
            ),
          ),
        );

        Result<String?> actualResponse = dashboardGetUserImage.call();

        expect(actualResponse, isA<Err<String?>>());
        expect((actualResponse as Err<String?>).failure, isA<StorageFailure>());
        verify(() => mockDashboardLocalRepository.getUserImage()).called(1);
      });
    });
  });
}
