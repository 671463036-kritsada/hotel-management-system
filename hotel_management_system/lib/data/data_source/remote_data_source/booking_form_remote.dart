import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hotel_management_system/data/model/booking_form_model.dart';

abstract class BookingFormRemoteDataSource {
  Future<bool> bookingForm(BookingFormModel bookingData);
}

class BookingFormRemoteDataSourceImpl implements BookingFormRemoteDataSource {
  final Dio dio;
  BookingFormRemoteDataSourceImpl(this.dio);

  @override
  Future<bool> bookingForm(BookingFormModel bookingData) async {
    final Map<String, dynamic> fields = {
      "roomId": bookingData.roomId,
      "fullName": bookingData.fullName,
      "checkInDate": bookingData.checkInDate?.toIso8601String(),
      "checkOutDate": bookingData.checkOutDate?.toIso8601String(),
      "roomsCount": bookingData.roomsCount,
      "numberOfGuests": bookingData.numberOfGuests,
      "totalPrice": bookingData.totalPrice,
      "depositAmount": bookingData.depositAmount,
      "remainingAmount": bookingData.remainingAmount,
      "phoneNumber": bookingData.phoneNumber,
      "email": bookingData.email,
      "bankAccount": bookingData.bankAccount,
      "address": bookingData.address,
    };

    // เช็ค null ก่อนใช้ ด้วย local variable ที่ non-nullable
    final String? slipPath = bookingData.paymentSlip;
    if (slipPath != null &&
        slipPath.isNotEmpty &&
        File(slipPath).existsSync()) {
      fields["paymentSlip"] = await MultipartFile.fromFile(
        slipPath,
        filename: slipPath.split('/').last,
      );
    }

    final formData = FormData.fromMap(fields);

    final response = await dio.post(
      "bookings",
      data: formData,
      // ไม่ต้องตั้ง Content-Type เอง — Dio จะใส่ multipart/form-data; boundary=... ให้อัตโนมัติ
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}