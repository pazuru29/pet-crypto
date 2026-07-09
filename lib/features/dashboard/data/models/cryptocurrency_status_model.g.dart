// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cryptocurrency_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CryptocurrencyStatusModel _$CryptocurrencyStatusModelFromJson(
  Map<String, dynamic> json,
) => CryptocurrencyStatusModel(
  timestamp: json['timestamp'] as String?,
  errorCode: (json['error_code'] as num?)?.toInt(),
  errorMessage: json['error_message'] as String?,
  elapsed: (json['elapsed'] as num?)?.toInt(),
  creditCount: (json['credit_count'] as num?)?.toInt(),
  notice: json['notice'] as String?,
);

Map<String, dynamic> _$CryptocurrencyStatusModelToJson(
  CryptocurrencyStatusModel instance,
) => <String, dynamic>{
  'timestamp': instance.timestamp,
  'error_code': instance.errorCode,
  'error_message': instance.errorMessage,
  'elapsed': instance.elapsed,
  'credit_count': instance.creditCount,
  'notice': instance.notice,
};
