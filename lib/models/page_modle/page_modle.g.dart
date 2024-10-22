// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_modle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageModle _$PageModleFromJson(Map<String, dynamic> json) => PageModle(
      page: (json['page'] as num?)?.toInt() ?? 0,
      size: (json['size'] as num?)?.toInt() ?? 0,
      data: json['data'] as List<dynamic>? ?? [],
    );

Map<String, dynamic> _$PageModleToJson(PageModle instance) => <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
      'data': instance.data,
    };
