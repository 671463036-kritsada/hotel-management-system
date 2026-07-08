class BookingListEntity {
  final int bookingId;
  final String bookingCode;

  final int roomNumber;
  final String? roomKey;

  final DateTime? checkInDate;
  final DateTime? checkOutDate;

  final double totalPrice;

  final String bookingStatus;
  final String paymentStatus;
  final String checkInStatus;
  final String checkOutStatus;
  final String inspectionStatus;

  BookingListEntity({
    required this.bookingId,
    required this.bookingCode,
    required this.roomNumber,
    required this.roomKey,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalPrice,
    required this.bookingStatus,
    required this.paymentStatus,
    required this.checkInStatus,
    required this.checkOutStatus,
    required this.inspectionStatus,
  });
}