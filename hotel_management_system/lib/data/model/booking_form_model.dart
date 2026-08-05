// To parse this JSON data, do
//
//     final bookingFormModel = bookingFormModelFromJson(jsonString);

import 'dart:convert';

BookingFormModel bookingFormModelFromJson(String str) => BookingFormModel.fromJson(json.decode(str));

String bookingFormModelToJson(BookingFormModel data) => json.encode(data.toJson());

class BookingFormModel {
    String? roomId;
    String? fullName;
    DateTime? checkInDate;
    DateTime? checkOutDate;
    String? email;
    String? bankAccount;
    String? phoneNumber;
    int? numberOfGuests;
    String? paymentSlip;

    BookingFormModel({
        this.roomId,
        this.fullName,
        this.checkInDate,
        this.checkOutDate,
        this.email,
        this.bankAccount,
        this.phoneNumber,
        this.numberOfGuests,
        this.paymentSlip,
    });

    factory BookingFormModel.fromJson(Map<String, dynamic> json) => BookingFormModel(
        roomId: json["roomId"],
        fullName: json["fullName"],
        checkInDate: json["checkInDate"] == null ? null : DateTime.parse(json["checkInDate"]),
        checkOutDate: json["checkOutDate"] == null ? null : DateTime.parse(json["checkOutDate"]),
        email: json["email"],
        bankAccount: json["bankAccount"],
        phoneNumber: json["phoneNumber"],
        numberOfGuests: json["numberOfGuests"],
        paymentSlip: json["paymentSlip"],
    );

    Map<String, dynamic> toJson() => {
        "roomId": roomId,
        "fullName": fullName,
        "checkInDate": checkInDate == null ? null : "${checkInDate!.year.toString().padLeft(4, '0')}-${checkInDate!.month.toString().padLeft(2, '0')}-${checkInDate!.day.toString().padLeft(2, '0')}",
        "checkOutDate": checkOutDate == null ? null : "${checkOutDate!.year.toString().padLeft(4, '0')}-${checkOutDate!.month.toString().padLeft(2, '0')}-${checkOutDate!.day.toString().padLeft(2, '0')}",
        "email": email,
        "bankAccount": bankAccount,
        "phoneNumber": phoneNumber,
        "numberOfGuests": numberOfGuests,
        "paymentSlip": paymentSlip,
    };
}
