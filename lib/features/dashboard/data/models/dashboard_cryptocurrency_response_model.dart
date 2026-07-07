import 'package:json_annotation/json_annotation.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/util/required_field.dart';
import 'package:pet_crypto/core/util/typedef.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/dashboard_cryptocurrency.dart';

part 'dashboard_cryptocurrency_response_model.g.dart';

@JsonSerializable()
class DashboardCryptocurrencyResponseModel {
  final List<DashboardCryptocurrencyModel>? data;
  final DashboardCryptocurrencyStatusModel? status;

  const DashboardCryptocurrencyResponseModel({
    required this.data,
    required this.status,
  });

  factory DashboardCryptocurrencyResponseModel.fromJson(JSON json) =>
      _$DashboardCryptocurrencyResponseModelFromJson(json);

  JSON toJson() => _$DashboardCryptocurrencyResponseModelToJson(this);

  List<DashboardCryptocurrency> toEntities() {
    final data = this.data;

    if (data == null) {
      throw ServerException(status?.errorMessage ?? 'Something went wrong');
    }

    return data.map((e) => e.toEntity()).toList();
  }
}

@JsonSerializable()
class DashboardCryptocurrencyStatusModel {
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

  const DashboardCryptocurrencyStatusModel({
    required this.timestamp,
    required this.errorCode,
    required this.errorMessage,
    required this.elapsed,
    required this.creditCount,
  });

  factory DashboardCryptocurrencyStatusModel.fromJson(JSON json) =>
      _$DashboardCryptocurrencyStatusModelFromJson(json);

  JSON toJson() => _$DashboardCryptocurrencyStatusModelToJson(this);
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
  final JSON? platform;
  @JsonKey(name: "minted_market_cap")
  final double? mintedMarketCap;
  @JsonKey(name: "quote")
  final Map<String, DashboardCurrencyModel>? quote;

  const DashboardCryptocurrencyModel({
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
