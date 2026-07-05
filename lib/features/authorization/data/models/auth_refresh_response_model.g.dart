// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_refresh_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRefreshResponseModel _$AuthRefreshResponseModelFromJson(
  Map<String, dynamic> json,
) => AuthRefreshResponseModel(
  accessToken: json['accessToken'] as String?,
  refreshToken: json['refreshToken'] as String?,
);

Map<String, dynamic> _$AuthRefreshResponseModelToJson(
  AuthRefreshResponseModel instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
};
