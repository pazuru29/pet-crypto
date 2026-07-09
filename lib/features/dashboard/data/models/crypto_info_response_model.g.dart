// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_info_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CryptoInfoResponseModel _$CryptoInfoResponseModelFromJson(
  Map<String, dynamic> json,
) => CryptoInfoResponseModel(
  data: (json['data'] as Map<String, dynamic>?)?.map(
    (k, e) =>
        MapEntry(k, CryptoInfoDataModel.fromJson(e as Map<String, dynamic>)),
  ),
  status: json['status'] == null
      ? null
      : CryptocurrencyStatusModel.fromJson(
          json['status'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CryptoInfoResponseModelToJson(
  CryptoInfoResponseModel instance,
) => <String, dynamic>{'data': instance.data, 'status': instance.status};

CryptoInfoDataModel _$CryptoInfoDataModelFromJson(Map<String, dynamic> json) =>
    CryptoInfoDataModel(
      urls: json['urls'] == null
          ? null
          : CryptocurrencyUrlsModel.fromJson(
              json['urls'] as Map<String, dynamic>,
            ),
      logo: json['logo'] as String?,
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      dateAdded: json['date_added'] as String?,
      dateLaunched: json['date_launched'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      platform: json['platform'] == null
          ? null
          : CryptoInfoPlatformModel.fromJson(
              json['platform'] as Map<String, dynamic>,
            ),
      category: json['category'] as String?,
    );

Map<String, dynamic> _$CryptoInfoDataModelToJson(
  CryptoInfoDataModel instance,
) => <String, dynamic>{
  'urls': instance.urls,
  'logo': instance.logo,
  'id': instance.id,
  'name': instance.name,
  'symbol': instance.symbol,
  'slug': instance.slug,
  'description': instance.description,
  'date_added': instance.dateAdded,
  'date_launched': instance.dateLaunched,
  'tags': instance.tags,
  'platform': instance.platform,
  'category': instance.category,
};

CryptocurrencyUrlsModel _$CryptocurrencyUrlsModelFromJson(
  Map<String, dynamic> json,
) => CryptocurrencyUrlsModel(
  website: (json['website'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  technicalDoc: (json['technical_doc'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  twitter: (json['twitter'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  reddit: (json['reddit'] as List<dynamic>?)?.map((e) => e as String).toList(),
  messageBoard: (json['message_board'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  announcement: (json['announcement'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  chat: (json['chat'] as List<dynamic>?)?.map((e) => e as String).toList(),
  explorer: (json['explorer'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  sourceCode: (json['source_code'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$CryptocurrencyUrlsModelToJson(
  CryptocurrencyUrlsModel instance,
) => <String, dynamic>{
  'website': instance.website,
  'technical_doc': instance.technicalDoc,
  'twitter': instance.twitter,
  'reddit': instance.reddit,
  'message_board': instance.messageBoard,
  'announcement': instance.announcement,
  'chat': instance.chat,
  'explorer': instance.explorer,
  'source_code': instance.sourceCode,
};
