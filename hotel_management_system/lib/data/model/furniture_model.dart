// To parse this JSON data, do
//
//     final furnitureModel = furnitureModelFromJson(jsonString);

import 'dart:convert';

FurnitureModel furnitureModelFromJson(String str) => FurnitureModel.fromJson(json.decode(str));

String furnitureModelToJson(FurnitureModel data) => json.encode(data.toJson());

class FurnitureModel {
    int? id;
    String? roomId;
    String? title;
    bool? isCustom = false;
    String? image;
    List<Inspection>? inspections;

    FurnitureModel({
        this.id,
        this.roomId,
        this.title,
        this.isCustom,
        this.image,
        this.inspections,
    });

    factory FurnitureModel.fromJson(Map<String, dynamic> json) => FurnitureModel(
        id: json["id"],
        roomId: json["roomId"],
        title: json["title"],
        isCustom: json["isCustom"],
        image: json["image"],
        inspections: json["inspections"] == null ? [] : List<Inspection>.from(json["inspections"]!.map((x) => Inspection.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "roomId": roomId,
        "title": title,
        "isCustom": isCustom,
        "image": image,
        "inspections": inspections == null ? [] : List<dynamic>.from(inspections!.map((x) => x.toJson())),
    };
}

class Inspection {
    int? inspectorId;
    String? inspectorName;
    String? inspectorRole;
    String? status;
    dynamic note;
    dynamic damageImage;
    DateTime? inspectedAt;

    Inspection({
        this.inspectorId,
        this.inspectorName,
        this.inspectorRole,
        this.status,
        this.note,
        this.damageImage,
        this.inspectedAt,
    });

    factory Inspection.fromJson(Map<String, dynamic> json) => Inspection(
        inspectorId: json["inspectorId"],
        inspectorName: json["inspectorName"],
        inspectorRole: json["inspectorRole"],
        status: json["status"],
        note: json["note"],
        damageImage: json["damageImage"],
        inspectedAt: json["inspectedAt"] == null ? null : DateTime.parse(json["inspectedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "inspectorId": inspectorId,
        "inspectorName": inspectorName,
        "inspectorRole": inspectorRole,
        "status": status,
        "note": note,
        "damageImage": damageImage,
        "inspectedAt": inspectedAt?.toIso8601String(),
    };
}
