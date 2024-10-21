import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable(explicitToJson: true)
class Category {
  Category(
      {required this.id,
      required this.level,
      required this.name,
      required this.parentID,
      required this.path,
      required this.userID});

  @JsonKey(name: 'id', defaultValue: 0)
  int id;

  @JsonKey(name: 'level', defaultValue: 0)
  int level;

  @JsonKey(name: 'name', defaultValue: '')
  String name;

  @JsonKey(name: 'parentID', defaultValue: 0)
  int parentID;

  @JsonKey(name: 'path', defaultValue: '')
  String path;

  @JsonKey(name: 'userID', defaultValue: 0)
  int userID;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  factory Category.emptyInstance() =>
      Category(id: 0, level: 0, name: '', parentID: 0, path: '', userID: 0);
}
