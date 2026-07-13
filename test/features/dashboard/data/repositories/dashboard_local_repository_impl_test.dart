import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/dashboard/data/repositories/dashboard_local_repository_impl.dart';
import 'package:pet_crypto/features/dashboard/domain/repositories/dashboard_local_repository.dart';
import 'package:pet_crypto/features/user/data/datasources/user_reader_local_datasource.dart';

class MockUserReaderLocalDatasource extends Mock
    implements UserReaderLocalDatasource {}

void main() {
  late UserReaderLocalDatasource mockUserReaderLocalDatasource;
  late DashboardLocalRepository dashboardLocalRepository;

  setUp(() {
    mockUserReaderLocalDatasource = MockUserReaderLocalDatasource();
    dashboardLocalRepository = DashboardLocalRepositoryImpl(
      local: mockUserReaderLocalDatasource,
    );
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class DashboardLocalRepositoryImpl', () {
    group('method getUserImage', () {
      test('should return Ok(String)', () {
        when(
          () => mockUserReaderLocalDatasource.fetchUserImage(),
        ).thenAnswer((_) => 'image');

        Result<String?> actualResponse = dashboardLocalRepository
            .getUserImage();

        expect(actualResponse, isA<Ok<String?>>());
        expect((actualResponse as Ok<String?>).value, isNotNull);
        expect(actualResponse.value, 'image');
        verify(() => mockUserReaderLocalDatasource.fetchUserImage()).called(1);
      });

      test('should return Ok(null)', () {
        when(
          () => mockUserReaderLocalDatasource.fetchUserImage(),
        ).thenAnswer((_) => null);

        Result<String?> actualResponse = dashboardLocalRepository
            .getUserImage();

        expect(actualResponse, isA<Ok<String?>>());
        expect((actualResponse as Ok<String?>).value, isNull);
        verify(() => mockUserReaderLocalDatasource.fetchUserImage()).called(1);
      });

      test('should return Err', () {
        when(
          () => mockUserReaderLocalDatasource.fetchUserImage(),
        ).thenThrow(StorageException('Something went wrong'));

        Result<String?> actualResponse = dashboardLocalRepository
            .getUserImage();

        expect(actualResponse, isA<Err<String?>>());
        expect((actualResponse as Err<String?>).failure, isA<StorageFailure>());
        verify(() => mockUserReaderLocalDatasource.fetchUserImage()).called(1);
      });
    });
  });
}
