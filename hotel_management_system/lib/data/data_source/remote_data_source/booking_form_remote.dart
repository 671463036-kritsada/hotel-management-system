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
    final response = await dio.post(
      "bookings",
      data: {
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
        "paymentSlip": bookingData.paymentSlip,
        "address": bookingData.address,
      },
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
}