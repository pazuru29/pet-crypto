import 'package:json_annotation/json_annotation.dart';
import 'package:pet_crypto/core/util/typedef.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_refresh_request.dart';

part 'auth_refresh_request_model.g.dart';

@JsonSerializable()
class AuthRefreshRequestModel {
  final String refreshToken;
  final int expiresInMins;

  AuthRefreshRequestModel({
    required this.refreshToken,
    this.expiresInMins = 30,
  });

  AuthRefreshRequestModel.fromEntity(AuthRefreshRequest request)
    : this(refreshToken: request.refreshToken);

  factory AuthRefreshRequestModel.fromJson(JSON json) =>
      _$AuthRefreshRequestModelFromJson(json);

  JSON toJson() => _$AuthRefreshRequestModelToJson(this);
}
