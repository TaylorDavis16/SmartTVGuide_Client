import 'package:hive_flutter/adapters.dart';
part 'user.g.dart';
@HiveType(typeId: 2)
class User{
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? username;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? gender;

  User({this.id, this.username, this.email, this.gender});

  User.fromJson(Map<String, dynamic> json) {
    id=json['id'];
    username= json['username'];
    email= json['email'];
    gender= json['gender'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'username': username,
        'email': email,
        'gender': gender,
      };
}
