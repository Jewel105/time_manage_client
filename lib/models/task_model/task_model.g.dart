// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
      categories: json['categories'] as String? ?? '',
      description: json['description'] as String? ?? '',
      endTime: (json['endTime'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      spentTime: (json['spentTime'] as num?)?.toInt() ?? 0,
      startTime: (json['startTime'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'categories': instance.categories,
      'description': instance.description,
      'endTime': instance.endTime,
      'id': instance.id,
      'spentTime': instance.spentTime,
      'startTime': instance.startTime,
    };
