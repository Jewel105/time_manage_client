// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PieModel _$PieModelFromJson(Map<String, dynamic> json) => PieModel(
      categoryID: (json['categoryID'] as num?)?.toInt() ?? 0,
      categoryName: json['categoryName'] as String? ?? '',
      value: (json['value'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PieModelToJson(PieModel instance) => <String, dynamic>{
      'categoryID': instance.categoryID,
      'categoryName': instance.categoryName,
      'value': instance.value,
    };
