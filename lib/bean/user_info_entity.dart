import '../generated/json/base/json_field.dart';
import '../generated/json/user_info_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class UserInfoEntity {
  String? name;
  int? age;
  String? address;

  UserInfoEntity();

  factory UserInfoEntity.fromJson(Map<String, dynamic> json) =>
      $UserInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => $UserInfoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
