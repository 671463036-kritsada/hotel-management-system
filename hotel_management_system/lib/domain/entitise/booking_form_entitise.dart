class BookingFormEntitise {
  String roomId;
  String fullName;
  DateTime checkInDate;
  DateTime checkOutDate;
  String email;
  String bankAccount;
  String phoneNumber;
  int numberOfGuests;
  String paymentSlip;

  BookingFormEntitise(
      {required this.roomId,
      required this.fullName,
      required this.checkInDate,
      required this.checkOutDate,
      required this.email,
      required this.bankAccount,
      required this.phoneNumber,
      required this.numberOfGuests,
      required this.paymentSlip});
}
