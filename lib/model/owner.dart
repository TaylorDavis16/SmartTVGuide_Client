import 'package:json_annotation/json_annotation.dart';

part 'owner.g.dart';

@JsonSerializable()
class Owner {
  String? name;
  String? face;
  int? fans;

  Owner({this.name, this.face, this.fans});

  //固定格式，不同的类使用不同的mixin即可
  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);

  //固定格式，
  Map<String, dynamic> toJson() => _$OwnerToJson(this);
}
