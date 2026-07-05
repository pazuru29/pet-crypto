import 'package:json_annotation/json_annotation.dart';
import 'package:pet_crypto/core/util/required_field.dart';
import 'package:pet_crypto/core/util/typedef.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_response.dart';

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

  AuthResponse toEntity() => AuthResponse(
    fullName:
        '${requiredField(firstName, 'firstName')} ${requiredField(lastName, 'lastName')}',
    email: requiredField(email, 'email'),
    image: requiredField(image, 'image'),
    accessToken: requiredField(accessToken, 'accessToken'),
    refreshToken: requiredField(refreshToken, 'refreshToken'),
  );
}
