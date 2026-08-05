// To parse this JSON data, do
//
//     final bookingFormModel = bookingFormModelFromJson(jsonString);

import 'dart:convert';

BookingFormModel bookingFormModelFromJson(String str) =>
    BookingFormModel.fromJson(json.decode(str));

String bookingFormModelToJson(BookingFormModel data) =>
    json.encode(data.toJson());

class BookingFormModel {
  String? roomId;

  String? fullName;

  DateTime? checkInDate;

  DateTime? checkOutDate;

  int? roomsCount;

  int? numberOfGuests;

  double? totalPrice;

  String? email;

  String? phoneNumber;

  String? bankAccount;

  String? address;

  String? paymentSlip;

  BookingFormModel({
    this.roomId,
    this.fullName,
    this.checkInDate,
    this.checkOutDate,
    this.roomsCount,
    this.numberOfGuests,
    this.totalPrice,
    this.email,
    this.phoneNumber,
    this.bankAccount,
    this.address,
    this.paymentSlip,
  });

  factory BookingFormModel.fromJson(Map<String, dynamic> json) =>
      BookingFormModel(
        roomId: json["roomId"],
        fullName: json["fullName"],
        checkInDate: json["checkInDate"] == null
            ? null
            : DateTime.parse(json["checkInDate"]),
        checkOutDate: json["checkOutDate"] == null
            ? null
            : DateTime.parse(json["checkOutDate"]),
        email: json["email"],
        bankAccount: json["bankAccount"],
        phoneNumber: json["phoneNumber"],
        numberOfGuests: json["numberOfGuests"],
        paymentSlip: json["paymentSlip"],
      );

  Map<String, dynamic> toJson() {
    return {
      "roomId": roomId,
      "fullName": fullName,
      "checkInDate": checkInDate?.toIso8601String(),
      "checkOutDate": checkOutDate?.toIso8601String(),
      "roomsCount": roomsCount,
      "numberOfGuests": numberOfGuests,
      "totalPrice": totalPrice,
      "email": email,
      "phoneNumber": phoneNumber,
      "bankAccount": bankAccount,
      "address": address,
      "paymentSlip": paymentSlip,
    };
  }
}
