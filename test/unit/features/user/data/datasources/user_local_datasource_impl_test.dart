import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/app_error_code.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/storage/preferences_storage.dart';
import 'package:pet_crypto/core/util/app_storage_keys.dart';
import 'package:pet_crypto/features/user/data/datasources/user_local_datasource.dart';
import 'package:pet_crypto/features/user/data/datasources/user_local_datasource_impl.dart';
import 'package:pet_crypto/features/user/data/models/user_data_model.dart';

class MockPreferencesStorage extends Mock implements PreferencesStorage {}

void main() {
  late MockPreferencesStorage mockPreferencesStorage;
  late UserLocalDatasource userLocalDatasource;

  setUp(() {
    mockPreferencesStorage = MockPreferencesStorage();
    userLocalDatasource = UserLocalDatasourceImpl(
      preferencesStorage: mockPreferencesStorage,
    );
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class UserLocalDatasourceImpl', () {
    group('method fetchUserData', () {
      setUp(() {
        when(
          () => mockPreferencesStorage.getString(AppStorageKeys.fullNameKey),
        ).thenAnswer((_) => 'name');
        when(
          () => mockPreferencesStorage.getString(AppStorageKeys.imageKey),
        ).thenAnswer((_) => 'image');
      });

      test('should return UserDataModel', () {
        when(
          () => mockPreferencesStorage.getString(AppStorageKeys.emailKey),
        ).thenAnswer((_) => 'email');

        UserDataModel actualResponse = userLocalDatasource.fetchUserData();

        expect(actualResponse.email, 'email');
        expect(actualResponse.fullName, 'name');
        expect(actualResponse.image, 'image');
        verifyInOrder([
          () => mockPreferencesStorage.getString(AppStorageKeys.emailKey),
          () => mockPreferencesStorage.getString(AppStorageKeys.fullNameKey),
          () => mockPreferencesStorage.getString(AppStorageKeys.imageKey),
        ]);
      });

      test('should throw StorageException', () {
        when(
          () => mockPreferencesStorage.getString(AppStorageKeys.emailKey),
        ).thenThrow(StorageException(technicalMessage: 'Some exception'));

        UserDataModel Function() call = userLocalDatasource.fetchUserData;

        expect(call, throwsA(isA<StorageException>()));
        verify(
          () => mockPreferencesStorage.getString(AppStorageKeys.emailKey),
        ).called(1);
        verifyNever(
          () => mockPreferencesStorage.getString(AppStorageKeys.fullNameKey),
        );
        verifyNever(
          () => mockPreferencesStorage.getString(AppStorageKeys.imageKey),
        );
      });
    });

    group('method fetchUserImage', () {
      test('should return String', () {
        when(
          () => mockPreferencesStorage.getString(AppStorageKeys.imageKey),
        ).thenAnswer((_) => 'image');

        String? actualResponse = userLocalDatasource.fetchUserImage();

        expect(actualResponse, 'image');
        verify(() => mockPreferencesStorage.getString(AppStorageKeys.imageKey));
      });

      test('should throw StorageException', () {
        when(
          () => mockPreferencesStorage.getString(AppStorageKeys.imageKey),
        ).thenThrow(StorageException(technicalMessage: 'Some exception'));

        String? Function() call = userLocalDatasource.fetchUserImage;

        expect(call, throwsA(isA<StorageException>()));
        verify(() => mockPreferencesStorage.getString(AppStorageKeys.imageKey));
      });
    });

    group('method saveUserData', () {
      test('should save data', () async {
        when(
          () => mockPreferencesStorage.setString(any(), any()),
        ).thenAnswer((_) async {});

        UserDataModel dataModel = UserDataModel(
          fullName: 'name',
          email: 'email',
          image: 'image',
        );

        await userLocalDatasource.saveUserData(dataModel);

        verify(() => mockPreferencesStorage.setString(any(), any())).called(3);
        verifyNever(() => mockPreferencesStorage.remove(any()));
      });

      test('should save data and remove email', () async {
        when(
          () => mockPreferencesStorage.setString(any(), any()),
        ).thenAnswer((_) async {});

        when(
          () => mockPreferencesStorage.remove(any()),
        ).thenAnswer((_) async {});

        UserDataModel dataModel = UserDataModel(
          fullName: 'name',
          email: null,
          image: 'image',
        );

        await userLocalDatasource.saveUserData(dataModel);

        verify(
          () => mockPreferencesStorage.setString(
            AppStorageKeys.fullNameKey,
            dataModel.fullName!,
          ),
        ).called(1);
        verify(
          () => mockPreferencesStorage.setString(
            AppStorageKeys.imageKey,
            dataModel.image!,
          ),
        ).called(1);
        verify(
          () => mockPreferencesStorage.remove(AppStorageKeys.emailKey),
        ).called(1);
      });

      test('should throw StorageException', () async {
        when(
          () =>
              mockPreferencesStorage.setString(AppStorageKeys.emailKey, any()),
        ).thenThrow(StorageException(technicalMessage: 'Email save failed'));
        when(
          () => mockPreferencesStorage.remove(any()),
        ).thenAnswer((_) async {});

        UserDataModel dataModel = UserDataModel(
          fullName: 'name',
          email: 'email',
          image: 'image',
        );

        Future<void> Function(UserDataModel) call =
            userLocalDatasource.saveUserData;

        await expectLater(call(dataModel), throwsA(isA<StorageException>()));
        verify(
          () =>
              mockPreferencesStorage.setString(AppStorageKeys.emailKey, any()),
        ).called(1);
        verifyNever(
          () => mockPreferencesStorage.setString(
            AppStorageKeys.fullNameKey,
            any(),
          ),
        );
        verifyNever(
          () =>
              mockPreferencesStorage.setString(AppStorageKeys.imageKey, any()),
        );
        verify(() => mockPreferencesStorage.remove(any())).called(3);
      });
    });

    group('method clearUserData', () {
      test('should remove data', () async {
        when(
          () => mockPreferencesStorage.remove(any()),
        ).thenAnswer((_) async {});

        await userLocalDatasource.clearUserData();

        verify(() => mockPreferencesStorage.remove(any())).called(3);
      });

      test(
        'first remove error should not stop the remaining removals',
        () async {
          when(
            () => mockPreferencesStorage.remove(AppStorageKeys.emailKey),
          ).thenThrow(Exception('Some Exception'));
          when(
            () => mockPreferencesStorage.remove(AppStorageKeys.fullNameKey),
          ).thenAnswer((_) async {});
          when(
            () => mockPreferencesStorage.remove(AppStorageKeys.imageKey),
          ).thenAnswer((_) async {});

          await expectLater(
            userLocalDatasource.clearUserData(),
            throwsA(isA<StorageException>()),
          );
          verifyInOrder([
            () => mockPreferencesStorage.remove(AppStorageKeys.emailKey),
            () => mockPreferencesStorage.remove(AppStorageKeys.fullNameKey),
            () => mockPreferencesStorage.remove(AppStorageKeys.imageKey),
          ]);
        },
      );

      test('storage remove error should be propagated', () async {
        when(
          () => mockPreferencesStorage.remove(AppStorageKeys.emailKey),
        ).thenThrow(StorageException());
        when(
          () => mockPreferencesStorage.remove(AppStorageKeys.fullNameKey),
        ).thenAnswer((_) async {});
        when(
          () => mockPreferencesStorage.remove(AppStorageKeys.imageKey),
        ).thenAnswer((_) async {});

        await expectLater(
          userLocalDatasource.clearUserData,
          throwsA(
            isA<StorageException>().having(
              (exception) => exception.code,
              'app error code',
              AppErrorCode.storageFailure,
            ),
          ),
        );
        verify(() => mockPreferencesStorage.remove(any())).called(3);
      });

      test('multiple remove errors should throw the first error', () async {
        when(
          () => mockPreferencesStorage.remove(AppStorageKeys.emailKey),
        ).thenThrow(StorageException(technicalMessage: 'Email delete failed'));
        when(
          () => mockPreferencesStorage.remove(AppStorageKeys.fullNameKey),
        ).thenThrow(
          StorageException(technicalMessage: 'Full name delete failed'),
        );
        when(
          () => mockPreferencesStorage.remove(AppStorageKeys.imageKey),
        ).thenAnswer((_) async {});

        await expectLater(
          userLocalDatasource.clearUserData(),
          throwsA(
            isA<StorageException>().having(
              (exception) => exception.technicalMessage,
              'message',
              'Email delete failed',
            ),
          ),
        );
        verifyInOrder([
          () => mockPreferencesStorage.remove(AppStorageKeys.emailKey),
          () => mockPreferencesStorage.remove(AppStorageKeys.fullNameKey),
          () => mockPreferencesStorage.remove(AppStorageKeys.imageKey),
        ]);
      });
    });
  });
}
