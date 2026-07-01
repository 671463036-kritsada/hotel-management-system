// list_screen_provider.dart
import 'package:flutter/material.dart';

class BookingItem {
  final int roomNumber;
  final String date;
  final String payAmount;
  final String keyBooking;
  final String status;
  final String textStatus;
  final Color statusColor;
  final bool? checkInStatus;
  final bool? checkOutStatus;
  final bool? statusConCheck;

  BookingItem({
    required this.roomNumber,
    required this.date,
    required this.payAmount,
    required this.keyBooking,
    required this.status,
    required this.textStatus,
    required this.statusColor,
    this.checkInStatus,
    this.checkOutStatus,
    this.statusConCheck,
  });
}

class ListScreenProvider extends ChangeNotifier {
  // --- State ---
  List<BookingItem> _bookingList = [];
  bool _isLoading = false;

  // --- Getter ---
  List<BookingItem> get bookingList => _bookingList;
  bool get isLoading => _isLoading;

  Future<void> getBookingList() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: เชื่อม API 
      // _bookingList = await _bookingRepository.getBookingList();

      // Mock data
      await Future.delayed(const Duration(milliseconds: 500));
      _bookingList = [
        BookingItem(
          roomNumber: 205,
          date: "15-17 ก.พ. 2569",
          payAmount: "1000 บาท",
          keyBooking: "BK-10111223",
          status: "อนุมัติแล้ว",
          textStatus: "รอดำเนินการเช็คอิน",
          statusColor: Colors.green,
          checkInStatus: true,
          checkOutStatus: false,
          statusConCheck: false,
        ),
        BookingItem(
          roomNumber: 305,
          date: "10-12 ก.พ. 2569",
          payAmount: "2000 บาท",
          keyBooking: "BK-10111213",
          status: "รอดำเนินการ",
          textStatus: "เจ้าหน้าที่กำลังตรวจสอบ",
          statusColor: Colors.yellow,
          checkInStatus: null,
        ),
        BookingItem(
          roomNumber: 105,
          date: "23-25 ก.พ. 2569",
          payAmount: "1500 บาท",
          keyBooking: "BK-10111233",
          status: "ไม่ผ่าน",
          textStatus: "เอกสารไม่ผ่าน",
          statusColor: Colors.red,
          checkInStatus: null,
        ),
      ];
    } catch (e) {
      // TODO: handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
