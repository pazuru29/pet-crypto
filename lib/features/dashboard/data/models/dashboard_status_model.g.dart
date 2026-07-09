// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStatusModel _$DashboardStatusModelFromJson(
  Map<String, dynamic> json,
) => DashboardStatusModel(
  timestamp: json['timestamp'] as String?,
  errorCode: (json['error_code'] as num?)?.toInt(),
  errorMessage: json['error_message'] as String?,
  elapsed: (json['elapsed'] as num?)?.toInt(),
  creditCount: (json['credit_count'] as num?)?.toInt(),
  notice: json['notice'] as String?,
);

Map<String, dynamic> _$DashboardStatusModelToJson(
  DashboardStatusModel instance,
) => <String, dynamic>{
  'timestamp': instance.timestamp,
  'error_code': instance.errorCode,
  'error_message': instance.errorMessage,
  'elapsed': instance.elapsed,
  'credit_count': instance.creditCount,
  'notice': instance.notice,
};
