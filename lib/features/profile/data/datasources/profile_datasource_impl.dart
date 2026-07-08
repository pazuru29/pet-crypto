import 'package:pet_crypto/core/storage/preferences_storage.dart';
import 'package:pet_crypto/core/util/app_storage_keys.dart';
import 'package:pet_crypto/features/profile/data/datasources/profile_datasource.dart';
import 'package:pet_crypto/features/profile/data/models/profile_data_model.dart';

class ProfileDatasourceImpl implements ProfileDatasource {
  final PreferencesStorage preferencesStorage;

  const ProfileDatasourceImpl({required this.preferencesStorage});

  @override
  Future<ProfileDataModel> fetchProfileData() async {
    final email = preferencesStorage.getString(AppStorageKeys.emailKey);
    final fullName = preferencesStorage.getString(AppStorageKeys.fullNameKey);
    final image = preferencesStorage.getString(AppStorageKeys.imageKey);

    return ProfileDataModel(fullName: fullName, email: email, userImage: image);
  }
}
