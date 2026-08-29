
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/entitise/list_entitise.dart';
import 'package:hotel_management_system/domain/use_case/list_usecase.dart';

import 'package:hotel_management_system/domain/use_case/check_in_usecase.dart';
import 'package:hotel_management_system/domain/use_case/history_usecase.dart'; // เพิ่ม

class BookingItem {
  final String bookingId;
  final String roomId;
  final double? totalPrice;
  final String status;
  final String textStatus;
  final Color statusColor;
  final bool? checkInStatus;
  final bool? checkOutStatus;
  final bool? statusConCheck;
  final String? bookingStatus;
  final String? roomKey;
  final String customerName;
  final String phone;
  final String email;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int roomsCount;
  final int personCount;
  final String? slipUrl;

  BookingItem(
      {required this.bookingId,
      required this.roomId,
      required this.totalPrice,
      required this.status,
      required this.textStatus,
      required this.statusColor,
      this.checkInStatus,
      this.checkOutStatus,
      this.statusConCheck,
      this.bookingStatus,
      this.roomKey,
      required this.customerName,
      required this.phone,
      required this.email,
      required this.checkIn,
      required this.checkOut,
      required this.roomsCount,
      required this.personCount,
      this.slipUrl});
}

class ListScreenProvider extends ChangeNotifier {
  final ListUsecase usecase;
  final CheckInUsecase checkInUsecase;
  final BookingHistoryUseCase historyUsecase; // เพิ่ม
  ListScreenProvider(this.usecase, this.checkInUsecase, this.historyUsecase); // แก้ constructor

  List<BookingItem> _bookingList = [];
  bool _isLoading = false;
  bool _isCheckingOut = false;

  List<BookingItem> get bookingList => _bookingList;
  bool get isLoading => _isLoading;
  bool get isCheckingOut => _isCheckingOut;

  Future<bool> checkOutBooking(String bookingId) async {
    _isCheckingOut = true;
    notifyListeners();
    try {
      final result = await checkInUsecase.checkOut(bookingId);
      if (result) {
        await getBookingList(); // โหลดรายการใหม่หลังเช็คเอาท์สำเร็จ
      }
      _isCheckingOut = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isCheckingOut = false;
      notifyListeners();
      rethrow; // โยน error ต่อให้ widget จัดการแสดงผล
    }
  }

  // เพิ่มฟังก์ชันใหม่สำหรับส่งรีวิว
  Future<bool> submitReview({
    required String bookingId,
    required int rating,
    required String comment,
  }) async {
    try {
      return await historyUsecase.submitReview(
        bookingId: bookingId,
        rating: rating,
        comment: comment,
      );
    } catch (e) {
      rethrow; // โยน error ต่อให้ widget จัดการแสดงผล
    }
  }

  Future<void> getBookingList() async {
    _isLoading = true;
    notifyListeners();
    try {
      final List<BookingListEntity> entities = await usecase.getListData();
      _bookingList = entities.map((entity) {
        return BookingItem(
            bookingId: entity.bookingId,
            roomId: entity.roomId,
            totalPrice: entity.amount,
            status: entity.status,
            textStatus: _mapStatusText(entity.status),
            statusColor: _mapStatusColor(entity.status),
            checkInStatus: entity.checkInStatus.toLowerCase() == 'checked_in',
            checkOutStatus:
                entity.checkOutStatus.toLowerCase() == 'checked_out',
            statusConCheck: entity.inspectionStatus == 'PENDING',
            bookingStatus: entity.status,
            roomKey: entity.roomKey,
            customerName: entity.customerName,
            phone: entity.phone,
            email: entity.email,
            checkIn: entity.checkIn,
            checkOut: entity.checkOut,
            roomsCount: entity.roomsCount,
            personCount: entity.personCount,
            slipUrl: entity.slipUrl);
      }).toList();
      _isLoading = false;
      notifyListeners();
    } on SocketException {
      _isLoading = false;
      notifyListeners();
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      _isLoading = false;
      notifyListeners();
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }

  List<BookingItem> filteredBookingList({
    bool? checkInStatus,
    bool? checkOutStatus,
    bool? statusConCheck,
  }) {
    return _bookingList.where((booking) {
      if (checkInStatus != null && booking.checkInStatus != checkInStatus) {
        return false;
      }
      if (checkOutStatus != null && booking.checkOutStatus != checkOutStatus) {
        return false;
      }
      if (statusConCheck != null && booking.statusConCheck != statusConCheck) {
        return false;
      }
      return true;
    }).toList();
  }

  String _mapStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return 'อนุมัติแล้ว';
      case 'PENDING':
        return 'รอดำเนินการ';
      case 'REJECTED':
        return 'ถูกปฏิเสธ';
      case 'CHECKED_IN':
        return 'เช็คอินแล้ว';
      default:
        return status;
    }
  }

  Color _mapStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'REJECTED':
        return Colors.red;
      case 'CHECKED_IN':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:hotel_management_system/domain/entitise/list_entitise.dart';
// import 'package:hotel_management_system/domain/use_case/list_usecase.dart';

// import 'package:hotel_management_system/domain/use_case/check_in_usecase.dart';

// class BookingItem {
//   final String bookingId;
//   final String roomId;
//   final double? totalPrice;
//   final String status;
//   final String textStatus;
//   final Color statusColor;
//   final bool? checkInStatus;
//   final bool? checkOutStatus;
//   final bool? statusConCheck;
//   final String? bookingStatus;
//   final String? roomKey;
//   final String customerName;
//   final String phone;
//   final String email;
//   final DateTime? checkIn;
//   final DateTime? checkOut;
//   final int roomsCount;
//   final int personCount;
//   final String? slipUrl;

//   BookingItem(
//       {required this.bookingId,
//       required this.roomId,
//       required this.totalPrice,
//       required this.status,
//       required this.textStatus,
//       required this.statusColor,
//       this.checkInStatus,
//       this.checkOutStatus,
//       this.statusConCheck,
//       this.bookingStatus,
//       this.roomKey,
//       required this.customerName,
//       required this.phone,
//       required this.email,
//       required this.checkIn,
//       required this.checkOut,
//       required this.roomsCount,
//       required this.personCount,
//       this.slipUrl});
// }

// class ListScreenProvider extends ChangeNotifier {
//   final ListUsecase usecase;
//    final CheckInUsecase checkInUsecase;
//   ListScreenProvider(this.usecase, this.checkInUsecase);

//   List<BookingItem> _bookingList = [];
//   bool _isLoading = false;
//     bool _isCheckingOut = false;

//   List<BookingItem> get bookingList => _bookingList;
//   bool get isLoading => _isLoading;
//   bool get isCheckingOut => _isCheckingOut;

//   Future<bool> checkOutBooking(String bookingId) async {
//     _isCheckingOut = true;
//     notifyListeners();
//     try {
//       final result = await checkInUsecase.checkOut(bookingId);
//       if (result) {
//         await getBookingList(); // โหลดรายการใหม่หลังเช็คเอาท์สำเร็จ
//       }
//       _isCheckingOut = false;
//       notifyListeners();
//       return result;
//     } catch (e) {
//       _isCheckingOut = false;
//       notifyListeners();
//       rethrow; // โยน error ต่อให้ widget จัดการแสดงผล
//     }
//   }


//   Future<void> getBookingList() async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       final List<BookingListEntity> entities = await usecase.getListData();
//       _bookingList = entities.map((entity) {
//         return BookingItem(
//             bookingId: entity.bookingId,
//             roomId: entity.roomId,
//             totalPrice: entity.amount,
//             status: entity.status,
//             textStatus: _mapStatusText(entity.status),
//             statusColor: _mapStatusColor(entity.status),
//             checkInStatus: entity.checkInStatus.toLowerCase() == 'checked_in',
//             checkOutStatus:
//                 entity.checkOutStatus.toLowerCase() == 'checked_out',
//             statusConCheck: entity.inspectionStatus == 'PENDING',
//             bookingStatus: entity.status,
//             roomKey: entity.roomKey,
//             customerName: entity.customerName,
//             phone: entity.phone,
//             email: entity.email,
//             checkIn: entity.checkIn,
//             checkOut: entity.checkOut,
//             roomsCount: entity.roomsCount,
//             personCount: entity.personCount,
//             slipUrl: entity.slipUrl);
//       }).toList();
//       _isLoading = false;
//       notifyListeners();
//     } on SocketException {
//       _isLoading = false;
//       notifyListeners();
//       throw Exception("ไม่มีการเชื่อมต่อ internet");
//     } on HttpException {
//       _isLoading = false;
//       notifyListeners();
//       throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
//     } catch (e) {
//       _isLoading = false;
//       notifyListeners();
//       throw Exception("เกิดข้อผิดพลาด $e");
//     }
//   }

//   List<BookingItem> filteredBookingList({
//     bool? checkInStatus,
//     bool? checkOutStatus,
//     bool? statusConCheck,
//   }) {
//     return _bookingList.where((booking) {
//       if (checkInStatus != null && booking.checkInStatus != checkInStatus) {
//         return false;
//       }
//       if (checkOutStatus != null && booking.checkOutStatus != checkOutStatus) {
//         return false;
//       }
//       if (statusConCheck != null && booking.statusConCheck != statusConCheck) {
//         return false;
//       }
//       return true;
//     }).toList();
//   }

//   String _mapStatusText(String status) {
//     switch (status.toUpperCase()) {
//       case 'APPROVED':
//         return 'อนุมัติแล้ว';
//       case 'PENDING':
//         return 'รอดำเนินการ';
//       case 'REJECTED':
//         return 'ถูกปฏิเสธ';
//       case 'CHECKED_IN':
//         return 'เช็คอินแล้ว';
//       default:
//         return status;
//     }
//   }

//   Color _mapStatusColor(String status) {
//     switch (status.toUpperCase()) {
//       case 'APPROVED':
//         return Colors.green;
//       case 'PENDING':
//         return Colors.orange;
//       case 'REJECTED':
//         return Colors.red;
//       case 'CHECKED_IN':
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }
// }
