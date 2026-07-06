// To parse this JSON data, do
//
//     final furnitureModel = furnitureModelFromJson(jsonString);

import 'dart:convert';

FurnitureModel furnitureModelFromJson(String str) => FurnitureModel.fromJson(json.decode(str));

String furnitureModelToJson(FurnitureModel data) => json.encode(data.toJson());

class FurnitureModel {
    String? title;
    String? image;
    String? status;

    FurnitureModel({
        this.title,
        this.image,
        this.status,
    });

    factory FurnitureModel.fromJson(Map<String, dynamic> json) => FurnitureModel(
        title: json["title"],
        image: json["image"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "image": image,
        "status": status,
    };
}
