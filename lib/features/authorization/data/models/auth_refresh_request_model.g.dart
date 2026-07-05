// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_refresh_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRefreshRequestModel _$AuthRefreshRequestModelFromJson(
  Map<String, dynamic> json,
) => AuthRefreshRequestModel(
  refreshToken: json['refreshToken'] as String,
  expiresInMins: (json['expiresInMins'] as num?)?.toInt() ?? 30,
);

Map<String, dynamic> _$AuthRefreshRequestModelToJson(
  AuthRefreshRequestModel instance,
) => <String, dynamic>{
  'refreshToken': instance.refreshToken,
  'expiresInMins': instance.expiresInMins,
};
