import 'package:json_annotation/json_annotation.dart';
import 'package:pet_crypto/core/util/typedef.dart';

part 'cryptocurrency_platform_model.g.dart';

@JsonSerializable()
class CryptocurrencyPlatformModel {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "slug")
  final String? slug;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "symbol")
  final String? symbol;
  @JsonKey(name: "token_address")
  final String? tokenAddress;

  const CryptocurrencyPlatformModel({
    this.id,
    this.slug,
    this.name,
    this.symbol,
    this.tokenAddress,
  });

  factory CryptocurrencyPlatformModel.fromJson(JSON json) =>
      _$CryptocurrencyPlatformModelFromJson(json);

  JSON toJson() => _$CryptocurrencyPlatformModelToJson(this);
}
