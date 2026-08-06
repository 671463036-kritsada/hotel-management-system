import 'package:hotel_management_system/data/repositorise/booking_form_repositorise.dart';
import 'package:hotel_management_system/domain/entitise/booking_form_entitise.dart';

import '../../data/model/booking_form_model.dart';

class BookingFormUsecase {
  final BookingFormRepositoriseImpl repository;

  BookingFormUsecase(this.repository);

  Future<bool> bookingForm(BookingFormEntitise bookingData) async {
    try {
      final model = BookingFormModel(
        roomId: bookingData.roomId,
        fullName: bookingData.fullName,
        checkInDate: bookingData.checkInDate,
        checkOutDate: bookingData.checkOutDate,
        email: bookingData.email,
        bankAccount: bookingData.bankAccount,
        phoneNumber: bookingData.phoneNumber,
        numberOfGuests: bookingData.numberOfGuests,
        roomsCount: bookingData.roomsCount,
        totalPrice: bookingData.totalPrice,
        address: bookingData.address,
        paymentSlip: bookingData.paymentSlip,
      );
      return await repository.bookingForm(model);
    } catch (e) {
      throw Exception("UseCase error: $e");
    }
  }
}
