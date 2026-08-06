class BookingFormEntitise {
  String roomId;
  String fullName;
  DateTime checkInDate;
  DateTime checkOutDate;
  String email;
  String bankAccount;
  String phoneNumber;
  int numberOfGuests;
  int roomsCount;
  double totalPrice;
  String paymentSlip;
  String address;


  BookingFormEntitise({
    required this.roomId,
    required this.fullName,
    required this.checkInDate,
    required this.checkOutDate,
    required this.email,
    required this.bankAccount,
    required this.phoneNumber,
    required this.numberOfGuests,
    required this.roomsCount,
    required this.totalPrice,
    required this.paymentSlip,
    required this.address,
  });
}