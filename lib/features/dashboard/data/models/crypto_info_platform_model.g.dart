// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_info_platform_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CryptoInfoPlatformModel _$CryptoInfoPlatformModelFromJson(
  Map<String, dynamic> json,
) => CryptoInfoPlatformModel(
  id: json['id'] as String?,
  slug: json['slug'] as String?,
  name: json['name'] as String?,
  symbol: json['symbol'] as String?,
  tokenAddress: json['token_address'] as String?,
);

Map<String, dynamic> _$CryptoInfoPlatformModelToJson(
  CryptoInfoPlatformModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'name': instance.name,
  'symbol': instance.symbol,
  'token_address': instance.tokenAddress,
};
