import 'package:json_annotation/json_annotation.dart';

part 'line_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LineModel {
  LineModel(
      {required this.categoryID,
      required this.categoryName,
      required this.value});

  @JsonKey(name: 'categoryID', defaultValue: 0)
  int categoryID;

  @JsonKey(name: 'categoryName', defaultValue: '')
  String categoryName;

  @JsonKey(name: 'value', defaultValue: [])
  List<Value> value;

  factory LineModel.fromJson(Map<String, dynamic> json) =>
      _$LineModelFromJson(json);

  Map<String, dynamic> toJson() => _$LineModelToJson(this);

  factory LineModel.emptyInstance() =>
      LineModel(categoryID: 0, categoryName: '', value: []);
}

@JsonSerializable(explicitToJson: true)
class Value {
  Value({required this.x, required this.y});

  @JsonKey(name: 'x', defaultValue: 0)
  int x;

  @JsonKey(name: 'y', defaultValue: 0)
  int y;

  factory Value.fromJson(Map<String, dynamic> json) => _$ValueFromJson(json);

  Map<String, dynamic> toJson() => _$ValueToJson(this);

  factory Value.emptyInstance() => Value(x: 0, y: 0);
}
