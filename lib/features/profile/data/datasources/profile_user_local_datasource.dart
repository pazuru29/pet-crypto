import 'package:pet_crypto/features/user/data/models/user_data_model.dart';

abstract interface class ProfileUserLocalDatasource {
  UserDataModel fetchUserData();

  Future<void> saveUserData(UserDataModel model);

  Future<void> clearUserData();
}
