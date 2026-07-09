import 'package:json_annotation/json_annotation.dart';
import 'package:pet_crypto/core/util/typedef.dart';

part 'crypto_info_platform_model.g.dart';

@JsonSerializable()
class CryptoInfoPlatformModel {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "slug")
  final String? slug;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "symbol")
  final String? symbol;
  @JsonKey(name: "token_address")
  final String? tokenAddress;

  const CryptoInfoPlatformModel({
    this.id,
    this.slug,
    this.name,
    this.symbol,
    this.tokenAddress,
  });

  factory CryptoInfoPlatformModel.fromJson(JSON json) =>
      _$CryptoInfoPlatformModelFromJson(json);

  JSON toJson() => _$CryptoInfoPlatformModelToJson(this);
}
