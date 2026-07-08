// To parse this JSON data, do
//
//     final listModel = listModelFromJson(jsonString);

import 'dart:convert';

ListModel listModelFromJson(String str) => ListModel.fromJson(json.decode(str));

String listModelToJson(ListModel data) => json.encode(data.toJson());

class ListModel {
    int? bookingId;
    String? bookingCode;
    int? roomNumber;
    String? roomKey;
    DateTime? checkInDate;
    DateTime? checkOutDate;
    int? totalPrice;
    String? bookingStatus;
    String? paymentStatus;
    String? checkInStatus;
    String? checkOutStatus;
    String? inspectionStatus;

    ListModel({
        this.bookingId,
        this.bookingCode,
        this.roomNumber,
        this.roomKey,
        this.checkInDate,
        this.checkOutDate,
        this.totalPrice,
        this.bookingStatus,
        this.paymentStatus,
        this.checkInStatus,
        this.checkOutStatus,
        this.inspectionStatus,
    });

    factory ListModel.fromJson(Map<String, dynamic> json) => ListModel(
        bookingId: json["bookingId"],
        bookingCode: json["bookingCode"],
        roomNumber: json["roomNumber"],
        roomKey: json["roomKey"],
        checkInDate: json["checkInDate"] == null ? null : DateTime.parse(json["checkInDate"]),
        checkOutDate: json["checkOutDate"] == null ? null : DateTime.parse(json["checkOutDate"]),
        totalPrice: json["totalPrice"],
        bookingStatus: json["bookingStatus"],
        paymentStatus: json["paymentStatus"],
        checkInStatus: json["checkInStatus"],
        checkOutStatus: json["checkOutStatus"],
        inspectionStatus: json["inspectionStatus"],
    );

    Map<String, dynamic> toJson() => {
        "bookingId": bookingId,
        "bookingCode": bookingCode,
        "roomNumber": roomNumber,
        "roomKey": roomKey,
        "checkInDate": checkInDate == null ? null : "${checkInDate!.year.toString().padLeft(4, '0')}-${checkInDate!.month.toString().padLeft(2, '0')}-${checkInDate!.day.toString().padLeft(2, '0')}",
        "checkOutDate": checkOutDate == null ? null : "${checkOutDate!.year.toString().padLeft(4, '0')}-${checkOutDate!.month.toString().padLeft(2, '0')}-${checkOutDate!.day.toString().padLeft(2, '0')}",
        "totalPrice": totalPrice,
        "bookingStatus": bookingStatus,
        "paymentStatus": paymentStatus,
        "checkInStatus": checkInStatus,
        "checkOutStatus": checkOutStatus,
        "inspectionStatus": inspectionStatus,
    };
}
