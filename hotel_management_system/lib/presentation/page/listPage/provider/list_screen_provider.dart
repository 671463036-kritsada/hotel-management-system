// list_screen_provider.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/entitise/list_entitise.dart';
import 'package:hotel_management_system/domain/use_case/list_usecase.dart';

class BookingItem {
  final int bookingId;
  final int roomNumber;
  final double? totalPrice;
  final String status;
  final String textStatus;
  final Color statusColor;
  final bool? checkInStatus;
  final bool? checkOutStatus;
  final bool? statusConCheck;
  final String? bookingStatus;
  final String? roomKey;

  BookingItem(
      {required this.bookingId,
      required this.roomNumber,
      required this.totalPrice,
      required this.status,
      required this.textStatus,
      required this.statusColor,
      this.checkInStatus,
      this.checkOutStatus,
      this.statusConCheck,
      this.bookingStatus,
      this.roomKey});
}

class ListScreenProvider extends ChangeNotifier {
  final ListUsecase usecase;
  ListScreenProvider(this.usecase);

  // --- State ---
  List<BookingItem> _bookingList = [];
  bool _isLoading = false;

  // --- Getter ---
  List<BookingItem> get bookingList => _bookingList;
  bool get isLoading => _isLoading;

  Future<void> getBookingList(int userID) async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<BookingListEntity> entities =
          await usecase.getListData(userID);

      _bookingList = entities.map((entity) {
        return BookingItem(
            bookingId: entity.bookingId,
            roomNumber: entity.roomNumber,
            totalPrice: entity.totalPrice,
            status: entity.bookingStatus,
            textStatus: _mapStatusText(entity.bookingStatus),
            statusColor: _mapStatusColor(entity.bookingStatus),
            checkInStatus: entity.checkInStatus.toLowerCase() == 'checked_in',
            checkOutStatus:
                entity.checkOutStatus.toLowerCase() == 'checked_out',
            statusConCheck: entity.inspectionStatus == 'PENDING',
            bookingStatus: entity.bookingStatus,
            roomKey: entity.roomKey);
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

  String _mapStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return 'อนุมัติแล้ว';
      case 'PENDING':
        return 'รอดำเนินการ';
      case 'REJECTED':
        return 'ถูกปฏิเสธ';
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
      default:
        return Colors.grey;
    }
  }
}
