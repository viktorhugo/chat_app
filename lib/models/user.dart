// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String name;
  String email;
  bool online;
  String uuid;

  User({
    required this.name,
    required this.email,
    required this.online,
    required this.uuid,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    online: json["online"],
    uuid: json["uuid"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "online": online,
    "uuid": uuid,
  };
}
