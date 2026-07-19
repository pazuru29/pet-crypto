import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:pet_crypto/features/profile/domain/repositories/profile_repository.dart';
import 'package:pet_crypto/features/user/data/datasources/user_reader_local_datasource.dart';
import 'package:pet_crypto/features/user/data/models/user_data_model.dart';
import 'package:pet_crypto/features/user/domain/entities/user_data.dart';

class MockUserReaderLocalDatasource extends Mock
    implements UserReaderLocalDatasource {}

void main() {
  late UserReaderLocalDatasource mockUserReaderLocalDatasource;
  late ProfileRepository profileRepository;

  setUp(() {
    mockUserReaderLocalDatasource = MockUserReaderLocalDatasource();
    profileRepository = ProfileRepositoryImpl(
      local: mockUserReaderLocalDatasource,
    );
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class ProfileRepositoryImpl', () {
    group('method getProfileData', () {
      test('should return Ok<UserData>', () {
        when(() => mockUserReaderLocalDatasource.fetchUserData()).thenAnswer(
          (_) =>
              UserDataModel(fullName: 'name', email: 'email', image: 'image'),
        );

        Result<UserData> actualResponse = profileRepository.getProfileData();

        expect(actualResponse, isA<Ok<UserData>>());
        expect((actualResponse as Ok<UserData>).value.fullName, 'name');
        expect(actualResponse.value.email, 'email');
        expect(actualResponse.value.image, 'image');
      });

      test('should return Err', () {
        when(
          () => mockUserReaderLocalDatasource.fetchUserData(),
        ).thenThrow(StorageException(technicalMessage: 'Something went wrong'));

        Result<UserData> actualResponse = profileRepository.getProfileData();

        expect(actualResponse, isA<Err<UserData>>());
        expect(
          (actualResponse as Err<UserData>).failure,
          isA<StorageFailure>(),
        );
      });
    });
  });
}
