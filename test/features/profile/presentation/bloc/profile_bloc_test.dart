import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_crypto/core/errors/failure.dart';
import 'package:pet_crypto/core/result/result.dart';
import 'package:pet_crypto/core/util/bloc/bloc_message.dart';
import 'package:pet_crypto/features/profile/domain/usecases/profile_change_locale.dart';
import 'package:pet_crypto/features/profile/domain/usecases/profile_change_theme_mode.dart';
import 'package:pet_crypto/features/profile/domain/usecases/profile_get_data.dart';
import 'package:pet_crypto/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pet_crypto/features/user/domain/entities/user_data.dart';

class MockProfileChangeLocale extends Mock implements ProfileChangeLocale {}

class MockProfileChangeThemeMode extends Mock
    implements ProfileChangeThemeMode {}

class MockProfileGetData extends Mock implements ProfileGetData {}

void main() {
  late ProfileChangeLocale mockProfileChangeLocale;
  late ProfileChangeThemeMode mockProfileChangeThemeMode;
  late ProfileGetData mockProfileGetData;
  late ProfileBloc profileBloc;

  setUp(() {
    mockProfileChangeLocale = MockProfileChangeLocale();
    mockProfileChangeThemeMode = MockProfileChangeThemeMode();
    mockProfileGetData = MockProfileGetData();
    profileBloc = ProfileBloc(
      profileGetData: mockProfileGetData,
      profileChangeLocale: mockProfileChangeLocale,
      profileChangeThemeMode: mockProfileChangeThemeMode,
    );
  });

  tearDown(() {
    resetMocktailState();
  });

  group('Class ProfileBloc', () {
    group('event ProfileInitEvent', () {
      blocTest(
        'should finish with status loaded and profile data',
        build: () {
          when(() => mockProfileGetData.call()).thenAnswer(
            (_) =>
                Ok(UserData(fullName: 'name', email: 'email', image: 'image')),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(ProfileInitEvent()),
        expect: () => [
          ProfileState(status: .loading),
          ProfileState(
            status: .loaded,
            profileData: UserData(
              fullName: 'name',
              email: 'email',
              image: 'image',
            ),
          ),
        ],
        verify: (_) {
          verify(() => mockProfileGetData.call()).called(1);
        },
      );

      blocTest(
        'should finish with status error and errorMessage',
        build: () {
          when(
            () => mockProfileGetData.call(),
          ).thenAnswer((_) => Err(StorageFailure('Something went wrong')));
          return profileBloc;
        },
        act: (bloc) => bloc.add(ProfileInitEvent()),
        expect: () => [
          ProfileState(status: .loading),
          ProfileState(status: .error, errorMessage: 'Something went wrong'),
        ],
        verify: (_) {
          verify(() => mockProfileGetData.call()).called(1);
        },
      );
    });

    group('event ProfileChangeThemeModeEvent', () {
      blocTest(
        'should call change theme',
        build: () {
          when(
            () => mockProfileChangeThemeMode.call(any()),
          ).thenAnswer((_) => Future(() => Ok(true)));
          return profileBloc;
        },
        seed: () => ProfileState(
          status: .loaded,
          profileData: UserData(
            fullName: 'name',
            email: 'email',
            image: 'image',
          ),
        ),
        act: (bloc) => bloc.add(ProfileChangeThemeModeEvent(themeIndex: 0)),
        expect: () => [],
        verify: (_) {
          verify(() => mockProfileChangeThemeMode.call(any())).called(1);
        },
      );

      blocTest(
        'should finish with alertMessage',
        build: () {
          when(() => mockProfileChangeThemeMode.call(any())).thenAnswer(
            (_) => Future(() => Err(StorageFailure('Something went wrong'))),
          );
          return profileBloc;
        },
        seed: () => ProfileState(
          status: .loaded,
          profileData: UserData(
            fullName: 'name',
            email: 'email',
            image: 'image',
          ),
        ),
        act: (bloc) => bloc.add(ProfileChangeThemeModeEvent(themeIndex: 0)),
        expect: () => [
          ProfileState(
            status: .loaded,
            profileData: UserData(
              fullName: 'name',
              email: 'email',
              image: 'image',
            ),
            alertMessage: BlocMessage.error('Something went wrong'),
          ),
        ],
        verify: (_) {
          verify(() => mockProfileChangeThemeMode.call(any())).called(1);
        },
      );
    });

    group('event ProfileChangeLocaleEvent', () {
      blocTest(
        'should call change locale',
        build: () {
          when(
            () => mockProfileChangeLocale.call(any()),
          ).thenAnswer((_) => Future(() => Ok(true)));
          return profileBloc;
        },
        seed: () => ProfileState(
          status: .loaded,
          profileData: UserData(
            fullName: 'name',
            email: 'email',
            image: 'image',
          ),
        ),
        act: (bloc) => bloc.add(ProfileChangeLocaleEvent(languageCode: 'en')),
        expect: () => [],
        verify: (_) {
          verify(() => mockProfileChangeLocale.call(any())).called(1);
        },
      );

      blocTest(
        'should finish with alertMessage',
        build: () {
          when(() => mockProfileChangeLocale.call(any())).thenAnswer(
            (_) => Future(() => Err(StorageFailure('Something went wrong'))),
          );
          return profileBloc;
        },
        seed: () => ProfileState(
          status: .loaded,
          profileData: UserData(
            fullName: 'name',
            email: 'email',
            image: 'image',
          ),
        ),
        act: (bloc) => bloc.add(ProfileChangeLocaleEvent(languageCode: 'en')),
        expect: () => [
          ProfileState(
            status: .loaded,
            profileData: UserData(
              fullName: 'name',
              email: 'email',
              image: 'image',
            ),
            alertMessage: BlocMessage.error('Something went wrong'),
          ),
        ],
        verify: (_) {
          verify(() => mockProfileChangeLocale.call(any())).called(1);
        },
      );
    });
  });
}
