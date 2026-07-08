import 'dart:developer';

import 'package:hotel_management_system/data/model/booking_form_model.dart';

abstract class BookingFormRemoteDataSource {
  Future<bool> bookingForm(BookingFormModel bookingData);
}

class BookingFormRemoteDataSourceImpl implements BookingFormRemoteDataSource {
  @override
  Future<bool> bookingForm(BookingFormModel bookingData) async {
    log("roomId ${bookingData.roomId}, username ${bookingData.fullName} , checkinDate ${bookingData.checkInDate} , checkoutDate ${bookingData.checkOutDate} , email ${bookingData.email} , bankAccount ${bookingData.bankAccount} , numberOfGuests ${bookingData.numberOfGuests} , phonenumber ${bookingData.phoneNumber} , paymentslip ${bookingData.paymentSlip}");

    await Future.delayed(const Duration(seconds: 2));

    if (bookingData.fullName!.isNotEmpty &&
        bookingData.checkInDate != null &&
        bookingData.checkOutDate != null &&
        bookingData.email!.isNotEmpty &&
        bookingData.phoneNumber!.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
