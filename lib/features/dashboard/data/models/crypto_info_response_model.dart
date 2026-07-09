import 'package:json_annotation/json_annotation.dart';
import 'package:pet_crypto/core/errors/exception.dart';
import 'package:pet_crypto/core/util/required_field.dart';
import 'package:pet_crypto/core/util/typedef.dart';
import 'package:pet_crypto/features/dashboard/data/models/crypto_info_platform_model.dart';
import 'package:pet_crypto/features/dashboard/data/models/cryptocurrency_status_model.dart';
import 'package:pet_crypto/features/dashboard/domain/entities/crypto_info.dart';

part 'crypto_info_response_model.g.dart';

@JsonSerializable()
class CryptoInfoResponseModel {
  @JsonKey(name: 'data')
  final Map<String, CryptoInfoDataModel>? data;
  @JsonKey(name: 'status')
  final CryptocurrencyStatusModel? status;

  const CryptoInfoResponseModel({this.data, this.status});

  factory CryptoInfoResponseModel.fromJson(JSON json) =>
      _$CryptoInfoResponseModelFromJson(json);

  JSON toJson() => _$CryptoInfoResponseModelToJson(this);

  CryptoInfo toEntity() {
    final data = this.data;

    if (data == null || data.isEmpty) {
      throw ServerException(status?.errorMessage ?? 'Something went wrong');
    }

    return data.values.first.toEntity();
  }
}

@JsonSerializable()
class CryptoInfoDataModel {
  @JsonKey(name: 'urls')
  final CryptocurrencyUrlsModel? urls;
  @JsonKey(name: 'logo')
  final String? logo;
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'symbol')
  final String? symbol;
  @JsonKey(name: 'slug')
  final String? slug;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'date_added')
  final String? dateAdded;
  @JsonKey(name: 'date_launched')
  final String? dateLaunched;
  @JsonKey(name: 'tags')
  final List<String>? tags;
  @JsonKey(name: 'platform')
  final CryptoInfoPlatformModel? platform;
  @JsonKey(name: 'category')
  final String? category;

  const CryptoInfoDataModel({
    this.urls,
    this.logo,
    this.id,
    this.name,
    this.symbol,
    this.slug,
    this.description,
    this.dateAdded,
    this.dateLaunched,
    this.tags,
    this.platform,
    this.category,
  });

  factory CryptoInfoDataModel.fromJson(JSON json) =>
      _$CryptoInfoDataModelFromJson(json);

  JSON toJson() => _$CryptoInfoDataModelToJson(this);

  CryptoInfo toEntity() => CryptoInfo(
    name: requiredField(name, 'name'),
    symbol: requiredField(symbol, 'symbol'),
    logo: logo,
    description: description,
    tags: tags,
    website: urls?.website,
    technicalDoc: urls?.technicalDoc,
    sourceCode: urls?.sourceCode,
  );
}

@JsonSerializable()
class CryptocurrencyUrlsModel {
  @JsonKey(name: 'website')
  final List<String>? website;
  @JsonKey(name: 'technical_doc')
  final List<String>? technicalDoc;
  @JsonKey(name: 'twitter')
  final List<String>? twitter;
  @JsonKey(name: 'reddit')
  final List<String>? reddit;
  @JsonKey(name: 'message_board')
  final List<String>? messageBoard;
  @JsonKey(name: 'announcement')
  final List<String>? announcement;
  @JsonKey(name: 'chat')
  final List<String>? chat;
  @JsonKey(name: 'explorer')
  final List<String>? explorer;
  @JsonKey(name: 'source_code')
  final List<String>? sourceCode;

  const CryptocurrencyUrlsModel({
    this.website,
    this.technicalDoc,
    this.twitter,
    this.reddit,
    this.messageBoard,
    this.announcement,
    this.chat,
    this.explorer,
    this.sourceCode,
  });

  factory CryptocurrencyUrlsModel.fromJson(JSON json) =>
      _$CryptocurrencyUrlsModelFromJson(json);

  JSON toJson() => _$CryptocurrencyUrlsModelToJson(this);
}
