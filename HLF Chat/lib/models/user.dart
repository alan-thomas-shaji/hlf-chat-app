import 'dart:convert';

class UserModel {
  String? name;
  String? email;
  String? userID;
  String? photoUrl;

  UserModel({
    this.name,
    this.email,
    this.userID,
    this.photoUrl,
  });

  factory UserModel.fromRawJson(String str) => UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        photoUrl: json["photoURL"],
        userID: json["uid"],
        name: json["displayName"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "photoURL": photoUrl,
        "uid": userID,
        "displayName": name,
        "email": email,
      };
}
