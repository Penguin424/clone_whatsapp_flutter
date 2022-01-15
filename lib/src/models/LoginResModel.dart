// ignore_for_file: file_names

import 'dart:convert';

LoginRes loginResFromMap(String str) => LoginRes.fromMap(json.decode(str));

String loginResToMap(LoginRes data) => json.encode(data.toMap());

class LoginRes {
  LoginRes({
    required this.jwt,
    required this.user,
  });

  String jwt;
  User user;

  factory LoginRes.fromMap(Map<String, dynamic> json) => LoginRes(
        jwt: json["jwt"],
        user: User.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "jwt": jwt,
        "user": user.toMap(),
      };
}

class User {
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.provider,
    required this.confirmed,
    required this.blocked,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String username;
  String email;
  String provider;
  bool confirmed;
  bool blocked;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        provider: json["provider"],
        confirmed: json["confirmed"],
        blocked: json["blocked"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "email": email,
        "provider": provider,
        "confirmed": confirmed,
        "blocked": blocked,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
