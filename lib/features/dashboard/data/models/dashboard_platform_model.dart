import 'package:json_annotation/json_annotation.dart';
import 'package:pet_crypto/core/util/typedef.dart';

part 'dashboard_platform_model.g.dart';

@JsonSerializable()
class DashboardPlatformModel {
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

  DashboardPlatformModel({
    this.id,
    this.slug,
    this.name,
    this.symbol,
    this.tokenAddress,
  });

  factory DashboardPlatformModel.fromJson(JSON json) =>
      _$DashboardPlatformModelFromJson(json);

  JSON toJson() => _$DashboardPlatformModelToJson(this);
}
