import 'package:json_annotation/json_annotation.dart';
import 'package:pet_crypto/core/util/required_field.dart';
import 'package:pet_crypto/core/util/typedef.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_tokens.dart';
import 'package:pet_crypto/features/user/domain/entities/user_data.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel {
  final int? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? image;
  final String? accessToken;
  final String? refreshToken;

  AuthResponseModel({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.image,
    this.accessToken,
    this.refreshToken,
  });

  factory AuthResponseModel.fromJson(JSON json) =>
      _$AuthResponseModelFromJson(json);

  JSON toJson() => _$AuthResponseModelToJson(this);

  UserData toUserDataEntity() => UserData(
    fullName: firstName != null && lastName != null
        ? '$firstName $lastName'
        : firstName != null
        ? '$firstName'
        : lastName != null
        ? '$lastName'
        : null,
    email: email,
    image: image,
  );

  AuthTokens toAuthTokensEntity() => AuthTokens(
    accessToken: requiredField(accessToken, 'accessToken'),
    refreshToken: requiredField(refreshToken, 'refreshToken'),
  );
}
