import 'package:pet_crypto/core/util/required_field.dart';
import 'package:pet_crypto/features/authorization/data/models/auth_response_model.dart';

class AuthTokensModel {
  final String accessToken;
  final String refreshToken;

  AuthTokensModel({required this.accessToken, required this.refreshToken});

  AuthTokensModel.fromAuthResponseModel(AuthResponseModel model)
    : this(
        accessToken: requiredField(model.accessToken, 'accessToken'),
        refreshToken: requiredField(model.refreshToken, 'refreshToken'),
      );
}
