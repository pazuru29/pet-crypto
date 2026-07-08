import 'package:get_it/get_it.dart';
import 'package:pet_crypto/features/profile/data/datasources/profile_datasource.dart';
import 'package:pet_crypto/features/profile/data/datasources/profile_datasource_impl.dart';
import 'package:pet_crypto/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:pet_crypto/features/profile/domain/repositories/profile_repository.dart';
import 'package:pet_crypto/features/profile/domain/usecases/profile_change_locale.dart';
import 'package:pet_crypto/features/profile/domain/usecases/profile_change_theme_mode.dart';
import 'package:pet_crypto/features/profile/domain/usecases/profile_get_data.dart';
import 'package:pet_crypto/features/profile/presentation/bloc/profile_bloc.dart';

class RegisterProfileDependencies {
  static Future<void> call(GetIt i) async {
    // DataSources
    i.registerLazySingleton<ProfileDatasource>(
      () => ProfileDatasourceImpl(preferencesStorage: i()),
    );

    // Repositories
    i.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(local: i()),
    );

    // UseCases
    i.registerLazySingleton<ProfileGetData>(() => ProfileGetData(repo: i()));
    i.registerLazySingleton<ProfileChangeLocale>(
      () => ProfileChangeLocale(localeProvider: i()),
    );
    i.registerLazySingleton<ProfileChangeThemeMode>(
      () => ProfileChangeThemeMode(themeProvider: i()),
    );

    // Bloc
    i.registerFactory<ProfileBloc>(
      () => ProfileBloc(
        profileGetData: i(),
        profileChangeThemeMode: i(),
        profileChangeLocale: i(),
      ),
    );
  }
}
