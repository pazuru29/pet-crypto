import 'package:json_annotation/json_annotation.dart';
import 'package:pet_crypto/core/util/typedef.dart';

part 'dashboard_status_model.g.dart';

@JsonSerializable()
class DashboardStatusModel {
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

  const DashboardStatusModel({
    this.timestamp,
    this.errorCode,
    this.errorMessage,
    this.elapsed,
    this.creditCount,
    this.notice,
  });

  factory DashboardStatusModel.fromJson(JSON json) =>
      _$DashboardStatusModelFromJson(json);

  JSON toJson() => _$DashboardStatusModelToJson(this);
}
