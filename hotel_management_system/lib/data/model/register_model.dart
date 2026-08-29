// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  String? name;
  String? email;
  String? password;
  String? phone;
  String? address;
  String? bankName;

  RegisterModel(
      {this.name,
      this.email,
      this.password,
      this.phone,
      this.address,
      this.bankName});

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
      name: json["name"],
      email: json["email"],
      password: json["password"],
      phone: json["phone"],
      address: json["address"],
      bankName: json["bankName"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "address": address,
        "bankName": bankName
      };
}
