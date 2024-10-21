// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: (json['id'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      parentID: (json['parentID'] as num?)?.toInt() ?? 0,
      path: json['path'] as String? ?? '',
      userID: (json['userID'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'name': instance.name,
      'parentID': instance.parentID,
      'path': instance.path,
      'userID': instance.userID,
    };
