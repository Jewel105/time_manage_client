import 'package:json_annotation/json_annotation.dart';

part 'pie_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PieModel {
  PieModel(
      {required this.categoryID,
      required this.categoryName,
      required this.value});

  @JsonKey(name: 'categoryID', defaultValue: 0)
  int categoryID;

  @JsonKey(name: 'categoryName', defaultValue: '')
  String categoryName;

  @JsonKey(name: 'value', defaultValue: 0)
  int value;

  factory PieModel.fromJson(Map<String, dynamic> json) =>
      _$PieModelFromJson(json);

  Map<String, dynamic> toJson() => _$PieModelToJson(this);

  factory PieModel.emptyInstance() =>
      PieModel(categoryID: 0, categoryName: '', value: 0);

  PieModel operator +(PieModel other) {
    return PieModel(
      categoryID: 0,
      categoryName: '',
      value: value + other.value,
    );
  }

  @override
  int get hashCode =>
      categoryID.hashCode ^ categoryName.hashCode ^ value.hashCode;
}
