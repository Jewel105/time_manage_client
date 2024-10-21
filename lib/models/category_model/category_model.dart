import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryModel {

  CategoryModel(
      {required this.id,
      required this.level,
      required this.name,
      required this.parentID,
      required this.path,
      required this.userID});

  @JsonKey(name: "id", defaultValue: 0)
  int id;

  @JsonKey(name: "level", defaultValue: 0)
  int level;

  @JsonKey(name: "name", defaultValue: "")
  String name;

  @JsonKey(name: "parentID", defaultValue: 0)
  int parentID;

  @JsonKey(name: "path", defaultValue: "")
  String path;

  @JsonKey(name: "userID", defaultValue: 0)
  int userID;


  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
  
  factory CategoryModel.emptyInstance() => CategoryModel(id: 0, level: 0, name: "", parentID: 0, path: "", userID: 0);
}


