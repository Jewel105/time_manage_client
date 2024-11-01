// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LineModel _$LineModelFromJson(Map<String, dynamic> json) => LineModel(
      categoryID: (json['categoryID'] as num?)?.toInt() ?? 0,
      categoryName: json['categoryName'] as String? ?? '',
      value: (json['value'] as List<dynamic>?)
              ?.map((e) => Value.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$LineModelToJson(LineModel instance) => <String, dynamic>{
      'categoryID': instance.categoryID,
      'categoryName': instance.categoryName,
      'value': instance.value.map((e) => e.toJson()).toList(),
    };

Value _$ValueFromJson(Map<String, dynamic> json) => Value(
      x: (json['x'] as num?)?.toInt() ?? 0,
      y: (json['y'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ValueToJson(Value instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
    };
