// To parse this JSON data, do
//
//     final homeModel = homeModelFromJson(jsonString);

import 'dart:convert';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
    String? roomId;
    String? roomType;
    String? name;
    String? description;
    String? pricePerNight;
    String? status;
    String? imageUrl;
    DateTime? createdAt;

    HomeModel({
        this.roomId,
        this.roomType,
        this.name,
        this.description,
        this.pricePerNight,
        this.status,
        this.imageUrl,
        this.createdAt,
    });

    factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        roomId: json["roomId"],
        roomType: json["roomType"],
        name: json["name"],
        description: json["description"],
        pricePerNight: json["pricePerNight"],
        status: json["status"],
        imageUrl: json["imageUrl"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "roomId": roomId,
        "roomType": roomType,
        "name": name,
        "description": description,
        "pricePerNight": pricePerNight,
        "status": status,
        "imageUrl": imageUrl,
        "createdAt": createdAt?.toIso8601String(),
    };
}
