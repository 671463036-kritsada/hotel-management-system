// To parse this JSON data, do
//
//     final homeModel = homeModelFromJson(jsonString);

import 'dart:convert';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
    int? roomId;
    String? roomType;
    List<String>? imageUrls;
    String? description;
    int? pricePerNight;
    String? status;
    Owner? owner;

    HomeModel({
        this.roomId,
        this.roomType,
        this.imageUrls,
        this.description,
        this.pricePerNight,
        this.status,
        this.owner,
    });

    factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        roomId: json["roomId"],
        roomType: json["roomType"],
        imageUrls: json["imageUrls"] == null ? [] : List<String>.from(json["imageUrls"]!.map((x) => x)),
        description: json["description"],
        pricePerNight: json["pricePerNight"],
        status: json["status"],
        owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
    );

    Map<String, dynamic> toJson() => {
        "roomId": roomId,
        "roomType": roomType,
        "imageUrls": imageUrls == null ? [] : List<dynamic>.from(imageUrls!.map((x) => x)),
        "description": description,
        "pricePerNight": pricePerNight,
        "status": status,
        "owner": owner?.toJson(),
    };
}

class Owner {
    int? id;
    String? name;
    int? age;

    Owner({
        this.id,
        this.name,
        this.age,
    });

    factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        id: json["id"],
        name: json["name"],
        age: json["age"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "age": age,
    };
}
