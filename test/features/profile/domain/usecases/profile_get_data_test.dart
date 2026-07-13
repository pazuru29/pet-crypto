import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/features/profile/domain/repositories/profile_repository.dart';
import 'package:pet_crypto/features/profile/domain/usecases/profile_get_data.dart';
import 'package:pet_crypto/features/user/domain/entities/user_data.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late ProfileRepository mockProfileRepository;
  late ProfileGetData profileGetData;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    profileGetData = ProfileGetData(repo: mockProfileRepository);
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class MockProfileRepository', () {
    group('method call', () {
      test('should return Ok<UserData>', () {
        UserData shouldData = UserData(
          fullName: 'name',
          email: 'email',
          image: 'image',
        );

        when(
          () => mockProfileRepository.getProfileData(),
        ).thenAnswer((_) => Ok(shouldData));

        Result<UserData> actualResponse = profileGetData.call();

        expect(actualResponse, isA<Ok<UserData>>());
        expect(
          (actualResponse as Ok<UserData>).value.fullName,
          shouldData.fullName,
        );
        expect(actualResponse.value.email, shouldData.email);
        expect(actualResponse.value.image, shouldData.image);
        verify(() => mockProfileRepository.getProfileData()).called(1);
      });

      test('should return Err', () {
        when(
          () => mockProfileRepository.getProfileData(),
        ).thenAnswer((_) => Err(StorageFailure('Something went wrong')));

        Result<UserData> actualResponse = profileGetData.call();

        expect(actualResponse, isA<Err<UserData>>());
        expect(
          (actualResponse as Err<UserData>).failure,
          isA<StorageFailure>(),
        );
        verify(() => mockProfileRepository.getProfileData()).called(1);
      });
    });
  });
}
