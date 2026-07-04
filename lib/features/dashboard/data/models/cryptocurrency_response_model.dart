import 'package:json_annotation/json_annotation.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/cryptocurrency.dart';

part 'cryptocurrency_response_model.g.dart';

@JsonSerializable()
class CryptocurrencyResponseModel {
  final List<CryptocurrencyModel>? data;
  final CryptocurrencyStatusModel? status;

  CryptocurrencyResponseModel({required this.data, required this.status});

  factory CryptocurrencyResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CryptocurrencyResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CryptocurrencyResponseModelToJson(this);
}

@JsonSerializable()
class CryptocurrencyStatusModel {
  @JsonKey(name: "timestamp")
  final String? timestamp;
  @JsonKey(name: "error_code")
  final int? errorCode;
  @JsonKey(name: "error_message")
  final String? errorMessage;
  @JsonKey(name: "elapsed")
  final int? elapsed;
  @JsonKey(name: "credit_count")
  final int? creditCount;

  CryptocurrencyStatusModel({
    required this.timestamp,
    required this.errorCode,
    required this.errorMessage,
    required this.elapsed,
    required this.creditCount,
  });

  factory CryptocurrencyStatusModel.fromJson(Map<String, dynamic> json) =>
      _$CryptocurrencyStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$CryptocurrencyStatusModelToJson(this);
}

@JsonSerializable()
class CryptocurrencyModel {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "symbol")
  final String? symbol;
  @JsonKey(name: "slug")
  final String? slug;
  @JsonKey(name: "cmc_rank")
  final int? cmcRank;
  @JsonKey(name: "num_market_pairs")
  final int? numMarketPairs;
  @JsonKey(name: "circulating_supply")
  final int? circulatingSupply;
  @JsonKey(name: "total_supply")
  final int? totalSupply;
  @JsonKey(name: "max_supply")
  final int? maxSupply;
  @JsonKey(name: "last_updated")
  final String? lastUpdated;
  @JsonKey(name: "date_added")
  final String? dateAdded;
  @JsonKey(name: "tags")
  final List<String>? tags;
  @JsonKey(name: "platform")
  final Map<String, dynamic>? platform;
  @JsonKey(name: "minted_market_cap")
  final double? mintedMarketCap;
  @JsonKey(name: "quote")
  final Map<String, CurrencyModel>? quote;

  CryptocurrencyModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.slug,
    required this.cmcRank,
    required this.numMarketPairs,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.maxSupply,
    required this.lastUpdated,
    required this.dateAdded,
    required this.tags,
    required this.platform,
    required this.mintedMarketCap,
    required this.quote,
  });

  factory CryptocurrencyModel.fromJson(Map<String, dynamic> json) =>
      _$CryptocurrencyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CryptocurrencyModelToJson(this);

  Cryptocurrency toEntity() => Cryptocurrency(
    id: id,
    name: name,
    symbol: symbol,
    price: quote?.map((key, value) => MapEntry(key, value.price ?? 0)),
  );
}

@JsonSerializable()
class CurrencyModel {
  @JsonKey(name: "price")
  final double? price;
  @JsonKey(name: "volume_24h")
  final int? volume24h;
  @JsonKey(name: "volume_change_24h")
  final double? volumeChange24h;
  @JsonKey(name: "percent_change_1h")
  final double? percentChange1h;
  @JsonKey(name: "percent_change_24h")
  final double? percentChange24h;
  @JsonKey(name: "percent_change_7d")
  final double? percentChange7d;
  @JsonKey(name: "market_cap")
  final double? marketCap;
  @JsonKey(name: "market_cap_dominance")
  final int? marketCapDominance;
  @JsonKey(name: "fully_diluted_market_cap")
  final double? fullyDilutedMarketCap;
  @JsonKey(name: "last_updated")
  final String? lastUpdated;

  CurrencyModel({
    required this.price,
    required this.volume24h,
    required this.volumeChange24h,
    required this.percentChange1h,
    required this.percentChange24h,
    required this.percentChange7d,
    required this.marketCap,
    required this.marketCapDominance,
    required this.fullyDilutedMarketCap,
    required this.lastUpdated,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyModelToJson(this);
}
