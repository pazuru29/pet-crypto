// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cryptocurrency_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CryptocurrencyResponseModel _$CryptocurrencyResponseModelFromJson(
  Map<String, dynamic> json,
) => CryptocurrencyResponseModel(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => CryptocurrencyModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  status: json['status'] == null
      ? null
      : CryptocurrencyStatusModel.fromJson(
          json['status'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CryptocurrencyResponseModelToJson(
  CryptocurrencyResponseModel instance,
) => <String, dynamic>{'data': instance.data, 'status': instance.status};

CryptocurrencyStatusModel _$CryptocurrencyStatusModelFromJson(
  Map<String, dynamic> json,
) => CryptocurrencyStatusModel(
  timestamp: json['timestamp'] as String?,
  errorCode: (json['error_code'] as num?)?.toInt(),
  errorMessage: json['error_message'] as String?,
  elapsed: (json['elapsed'] as num?)?.toInt(),
  creditCount: (json['credit_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$CryptocurrencyStatusModelToJson(
  CryptocurrencyStatusModel instance,
) => <String, dynamic>{
  'timestamp': instance.timestamp,
  'error_code': instance.errorCode,
  'error_message': instance.errorMessage,
  'elapsed': instance.elapsed,
  'credit_count': instance.creditCount,
};

CryptocurrencyModel _$CryptocurrencyModelFromJson(Map<String, dynamic> json) =>
    CryptocurrencyModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
      slug: json['slug'] as String?,
      cmcRank: (json['cmc_rank'] as num?)?.toInt(),
      numMarketPairs: (json['num_market_pairs'] as num?)?.toInt(),
      circulatingSupply: (json['circulating_supply'] as num?)?.toInt(),
      totalSupply: (json['total_supply'] as num?)?.toInt(),
      maxSupply: (json['max_supply'] as num?)?.toInt(),
      lastUpdated: json['last_updated'] as String?,
      dateAdded: json['date_added'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      platform: json['platform'] as Map<String, dynamic>?,
      mintedMarketCap: (json['minted_market_cap'] as num?)?.toDouble(),
      quote: (json['quote'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, CurrencyModel.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$CryptocurrencyModelToJson(
  CryptocurrencyModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'symbol': instance.symbol,
  'slug': instance.slug,
  'cmc_rank': instance.cmcRank,
  'num_market_pairs': instance.numMarketPairs,
  'circulating_supply': instance.circulatingSupply,
  'total_supply': instance.totalSupply,
  'max_supply': instance.maxSupply,
  'last_updated': instance.lastUpdated,
  'date_added': instance.dateAdded,
  'tags': instance.tags,
  'platform': instance.platform,
  'minted_market_cap': instance.mintedMarketCap,
  'quote': instance.quote,
};

CurrencyModel _$CurrencyModelFromJson(Map<String, dynamic> json) =>
    CurrencyModel(
      price: (json['price'] as num?)?.toDouble(),
      volume24h: (json['volume_24h'] as num?)?.toInt(),
      volumeChange24h: (json['volume_change_24h'] as num?)?.toDouble(),
      percentChange1h: (json['percent_change_1h'] as num?)?.toDouble(),
      percentChange24h: (json['percent_change_24h'] as num?)?.toDouble(),
      percentChange7d: (json['percent_change_7d'] as num?)?.toDouble(),
      marketCap: (json['market_cap'] as num?)?.toDouble(),
      marketCapDominance: (json['market_cap_dominance'] as num?)?.toInt(),
      fullyDilutedMarketCap: (json['fully_diluted_market_cap'] as num?)
          ?.toDouble(),
      lastUpdated: json['last_updated'] as String?,
    );

Map<String, dynamic> _$CurrencyModelToJson(CurrencyModel instance) =>
    <String, dynamic>{
      'price': instance.price,
      'volume_24h': instance.volume24h,
      'volume_change_24h': instance.volumeChange24h,
      'percent_change_1h': instance.percentChange1h,
      'percent_change_24h': instance.percentChange24h,
      'percent_change_7d': instance.percentChange7d,
      'market_cap': instance.marketCap,
      'market_cap_dominance': instance.marketCapDominance,
      'fully_diluted_market_cap': instance.fullyDilutedMarketCap,
      'last_updated': instance.lastUpdated,
    };
