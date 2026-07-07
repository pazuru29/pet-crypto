import 'package:pet_crypto/core/storage/preferences_storage.dart';
import 'package:pet_crypto/features/profile/data/datasources/profile_datasource.dart';
import 'package:pet_crypto/features/profile/data/models/profile_data_model.dart';

class ProfileDatasourceImpl implements ProfileDatasource {
  final PreferencesStorage preferencesStorage;

  const ProfileDatasourceImpl({
    required this.preferencesStorage,
  });

  static const _emailKey = 'auth.email';
  static const _fullNameKey = 'auth.fullName';
  static const _imageKey = 'auth.image';

  @override
  Future<ProfileDataModel> fetchProfileData() async {
    final email = preferencesStorage.getString(_emailKey);
    final fullName = preferencesStorage.getString(_fullNameKey);
    final image = preferencesStorage.getString(_imageKey);

    return ProfileDataModel(fullName: fullName, email: email, userImage: image);
  }
}
