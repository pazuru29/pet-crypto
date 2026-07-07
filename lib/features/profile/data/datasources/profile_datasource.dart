import 'package:pet_crypto/features/profile/data/models/profile_data_model.dart';

abstract interface class ProfileDatasource {
  Future<ProfileDataModel> fetchProfileData();
}
