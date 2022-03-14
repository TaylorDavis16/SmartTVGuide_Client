class User {
  int? id;
  String? username;
  String? email;
  String? gender;

  User({this.id, this.username, this.email, this.gender});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int?,
        username: json['username'] as String?,
        email: json['email'] as String?,
        gender: json['gender'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'username': username,
        'email': email,
        'gender': gender,
      };
}
