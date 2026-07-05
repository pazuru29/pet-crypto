import 'package:json_annotation/json_annotation.dart';
import 'package:pet_crypto/core/util/required_field.dart';
import 'package:pet_crypto/core/util/typedef.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_refresh_response.dart';

part 'auth_refresh_response_model.g.dart';

@JsonSerializable()
class AuthRefreshResponseModel {
  final String? accessToken;
  final String? refreshToken;

  AuthRefreshResponseModel({this.accessToken, this.refreshToken});

  factory AuthRefreshResponseModel.fromJson(JSON json) =>
      _$AuthRefreshResponseModelFromJson(json);

  JSON toJson() => _$AuthRefreshResponseModelToJson(this);

  AuthRefreshResponse toEntity() => AuthRefreshResponse(
    accessToken: requiredField(accessToken, 'accessToken'),
    refreshToken: requiredField(refreshToken, 'refreshToken'),
  );
}
