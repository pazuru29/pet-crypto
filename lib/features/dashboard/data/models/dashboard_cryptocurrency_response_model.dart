import 'package:json_annotation/json_annotation.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/util/required_field.dart';
import 'package:pet_crypto/core/util/typedef.dart';
import 'package:pet_crypto/features/dashboard/data/models/cryptocurrency_platform_model.dart';
import 'package:pet_crypto/features/dashboard/data/models/cryptocurrency_status_model.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency.dart';

part 'dashboard_cryptocurrency_response_model.g.dart';

@JsonSerializable()
class DashboardCryptocurrencyResponseModel {
  final List<DashboardCryptocurrencyModel>? data;
  final CryptocurrencyStatusModel? status;

  const DashboardCryptocurrencyResponseModel({this.data, this.status});

  factory DashboardCryptocurrencyResponseModel.fromJson(JSON json) =>
      _$DashboardCryptocurrencyResponseModelFromJson(json);

  JSON toJson() => _$DashboardCryptocurrencyResponseModelToJson(this);

  List<DashboardCryptocurrency> toEntities() {
    final data = this.data;

    if (data == null) {
      throw ParsingException(
        technicalMessage: status?.errorMessage ?? 'Something went wrong',
      );
    }

    return data.map((e) => e.toEntity()).toList();
  }
}

@JsonSerializable()
class DashboardCryptocurrencyModel {
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
  final CryptocurrencyPlatformModel? platform;
  @JsonKey(name: "minted_market_cap")
  final double? mintedMarketCap;
  @JsonKey(name: "quote")
  final Map<String, DashboardCurrencyModel>? quote;

  const DashboardCryptocurrencyModel({
    this.id,
    this.name,
    this.symbol,
    this.slug,
    this.cmcRank,
    this.numMarketPairs,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.lastUpdated,
    this.dateAdded,
    this.tags,
    this.platform,
    this.mintedMarketCap,
    this.quote,
  });

  factory DashboardCryptocurrencyModel.fromJson(JSON json) =>
      _$DashboardCryptocurrencyModelFromJson(json);

  JSON toJson() => _$DashboardCryptocurrencyModelToJson(this);

  DashboardCryptocurrency toEntity() => DashboardCryptocurrency(
    id: requiredField(id, 'id'),
    name: requiredField(name, 'name'),
    symbol: requiredField(symbol, 'symbol'),
    prices:
        quote?.entries
            .map((e) => e.value.toEntity(e.key))
            .whereType<DashboardCryptocurrencyPrice>()
            .toList() ??
        const [],
  );
}

@JsonSerializable()
class DashboardCurrencyModel {
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

  const DashboardCurrencyModel({
    this.price,
    this.volume24h,
    this.volumeChange24h,
    this.percentChange1h,
    this.percentChange24h,
    this.percentChange7d,
    this.marketCap,
    this.marketCapDominance,
    this.fullyDilutedMarketCap,
    this.lastUpdated,
  });

  factory DashboardCurrencyModel.fromJson(JSON json) =>
      _$DashboardCurrencyModelFromJson(json);

  JSON toJson() => _$DashboardCurrencyModelToJson(this);

  DashboardCryptocurrencyPrice? toEntity(String currencyCode) {
    final price = this.price;
    if (price == null) {
      return null;
    }

    return DashboardCryptocurrencyPrice(
      currencyCode: currencyCode,
      amount: price,
    );
  }
}
