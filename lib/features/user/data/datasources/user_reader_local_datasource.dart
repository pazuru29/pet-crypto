import 'package:pet_crypto/features/user/data/models/user_data_model.dart';

abstract interface class UserReaderLocalDatasource {
  UserDataModel fetchUserData();

  String? fetchUserImage();
}