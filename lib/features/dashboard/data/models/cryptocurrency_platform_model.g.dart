// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cryptocurrency_platform_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CryptocurrencyPlatformModel _$CryptocurrencyPlatformModelFromJson(
  Map<String, dynamic> json,
) => CryptocurrencyPlatformModel(
  id: (json['id'] as num?)?.toInt(),
  slug: json['slug'] as String?,
  name: json['name'] as String?,
  symbol: json['symbol'] as String?,
  tokenAddress: json['token_address'] as String?,
);

Map<String, dynamic> _$CryptocurrencyPlatformModelToJson(
  CryptocurrencyPlatformModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'name': instance.name,
  'symbol': instance.symbol,
  'token_address': instance.tokenAddress,
};
