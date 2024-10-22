import 'package:json_annotation/json_annotation.dart';

part 'page_modle.g.dart';

@JsonSerializable(explicitToJson: true)
class PageModle {
  PageModle({required this.page, required this.size, required this.data});

  @JsonKey(name: 'page', defaultValue: 0)
  int page;

  @JsonKey(name: 'size', defaultValue: 0)
  int size;

  @JsonKey(name: 'data', defaultValue: [])
  List<Object?> data;

  factory PageModle.fromJson(Map<String, dynamic> json) =>
      _$PageModleFromJson(json);

  Map<String, dynamic> toJson() => _$PageModleToJson(this);

  factory PageModle.emptyInstance() =>
      PageModle(page: 0, size: 0, data: <Object?>[]);
}
