// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    final String token;
    final User user;

    const LoginModel({
        this.token,
        this.user,
    });

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        token: json["token"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "user": user.toJson(),
    };
}

class User {
    int id;
    int roleId;
    int master;
    String name;
    String email;
    String address;
    dynamic emailVerifiedAt;
    DateTime createdAt;
    DateTime updatedAt;
    String userType;

    User({
        this.id,
        this.roleId,
        this.master,
        this.name,
        this.email,
        this.address,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.userType,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        roleId: json["role_id"],
        master: json["master"],
        name: json["name"]?? json["company_name"]?? "NULL",
        email: json["email"],
        address: json["address"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        userType: json["user_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": roleId,
        "master": master,
        "name": name,
        "email": email,
        "address": address,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user_type": userType,
    };
}
