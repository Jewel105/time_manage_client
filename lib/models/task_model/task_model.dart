import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TaskModel {
  TaskModel(
      {required this.categories,
      required this.description,
      required this.endTime,
      required this.id,
      required this.spentTime,
      required this.startTime,
      required this.categoryID});

  @JsonKey(name: 'categories', defaultValue: '')
  String categories;

  @JsonKey(name: 'description', defaultValue: '')
  String description;

  @JsonKey(name: 'endTime', defaultValue: 0)
  int endTime;

  @JsonKey(name: 'id', defaultValue: 0)
  int id;

  @JsonKey(name: 'spentTime', defaultValue: 0)
  int spentTime;

  @JsonKey(name: 'startTime', defaultValue: 0)
  int startTime;

  @JsonKey(name: 'categoryID', defaultValue: 0)
  int categoryID;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  factory TaskModel.emptyInstance() => TaskModel(
      categories: '',
      description: '',
      endTime: 0,
      id: 0,
      spentTime: 0,
      startTime: 0,
      categoryID: 0);
}
