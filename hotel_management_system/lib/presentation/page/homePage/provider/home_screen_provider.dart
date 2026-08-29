// home_screen_provider.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/entitise/home_entitise.dart';
import 'package:hotel_management_system/domain/use_case/home_usecase.dart';
import '../../../../util/widget/core/typeRoom_enum.dart';

class HomeScreenProvider extends ChangeNotifier {
  RoomType selectedRoomType = RoomType.rooms;
  int len = 10;
  HomeUsecase homeUsecase;
  List<HomeEntitise> roomData = [];
  String errorMessage = '';
  bool isLoading = false;

  // --- state สำหรับ filter วันที่ (nullable: ยังไม่เลือกวันที่ = ยังไม่มีข้อมูล) ---
  DateTime? checkInDate;
  DateTime? checkOutDate;

  HomeScreenProvider(this.homeUsecase);

  bool get hasDateFilter => checkInDate != null && checkOutDate != null;

  void selectRoomType(RoomType type) {
    selectedRoomType = type;
    len = type == RoomType.rooms ? 10 : 15;
    notifyListeners();

    // กรองใหม่เฉพาะตอนมีวันที่แล้วเท่านั้น เพราะไม่มี "ดึงห้องทั้งหมด" ให้ fallback อีกต่อไป
    if (hasDateFilter) {
      filterAvailableRooms();
    }
  }

  /// ตั้งวันที่แล้ว filter ห้องว่างทันที
  void setDateRange(DateTime checkIn, DateTime checkOut) {
    checkInDate = checkIn;
    checkOutDate = checkOut;
    notifyListeners();
    filterAvailableRooms();
  }

  /// ล้างวันที่ที่เลือก -> ไม่มีวันที่แล้ว = ไม่มีข้อมูลห้องให้แสดง (เพราะกรองอย่างเดียว ไม่มี "ห้องทั้งหมด")
  void clearDateFilter() {
    checkInDate = null;
    checkOutDate = null;
    roomData = [];
    errorMessage = '';
    notifyListeners();
  }

  Future<void> filterAvailableRooms() async {
    if (!hasDateFilter) return;

    isLoading = true;
    errorMessage = '';
    notifyListeners();
    try {
      roomData = await homeUsecase.getAvailableRooms(
        checkIn: _formatDate(checkInDate!),
        checkOut: _formatDate(checkOutDate!),
        roomType: selectedRoomType == RoomType.rooms ? 'rooms' : 'house',
      );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'ไม่สามารถโหลดข้อมูลห้องว่างได้: $e';
      notifyListeners();
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

}