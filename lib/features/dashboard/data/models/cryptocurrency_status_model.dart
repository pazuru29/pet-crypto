import 'package:json_annotation/json_annotation.dart';
import 'package:pet_crypto/core/util/typedef.dart';

part 'cryptocurrency_status_model.g.dart';

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
  @JsonKey(name: "notice")
  final String? notice;

  const CryptocurrencyStatusModel({
    this.timestamp,
    this.errorCode,
    this.errorMessage,
    this.elapsed,
    this.creditCount,
    this.notice,
  });

  factory CryptocurrencyStatusModel.fromJson(JSON json) =>
      _$CryptocurrencyStatusModelFromJson(json);

  JSON toJson() => _$CryptocurrencyStatusModelToJson(this);
}
