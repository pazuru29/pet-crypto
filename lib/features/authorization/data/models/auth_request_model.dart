import 'package:json_annotation/json_annotation.dart';
import 'package:pet_crypto/core/util/typedef.dart';
import 'package:pet_crypto/features/authorization/domain/entities/auth_request.dart';

part 'auth_request_model.g.dart';

@JsonSerializable()
class AuthRequestModel {
  final String username;
  final String password;
  final int expiresInMins;

  const AuthRequestModel({
    required this.username,
    required this.password,
    this.expiresInMins = 30,
  });

  AuthRequestModel.fromEntity(AuthRequest request)
    : this(username: request.login, password: request.password);

  factory AuthRequestModel.fromJson(JSON json) =>
      _$AuthRequestModelFromJson(json);

  JSON toJson() => _$AuthRequestModelToJson(this);
}
