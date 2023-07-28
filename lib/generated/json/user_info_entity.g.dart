import '../../generated/json/base/json_convert_content.dart';
import '../../bean/user_info_entity.dart';

UserInfoEntity $UserInfoEntityFromJson(Map<String, dynamic> json) {
  final UserInfoEntity userInfoEntity = UserInfoEntity();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    userInfoEntity.name = name;
  }
  final int? age = jsonConvert.convert<int>(json['age']);
  if (age != null) {
    userInfoEntity.age = age;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    userInfoEntity.address = address;
  }
  return userInfoEntity;
}

Map<String, dynamic> $UserInfoEntityToJson(UserInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['age'] = entity.age;
  data['address'] = entity.address;
  return data;
}
