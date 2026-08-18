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

  // --- เพิ่มใหม่: state สำหรับ filter วันที่ ---
  DateTime? checkInDate;
  DateTime? checkOutDate;

  HomeScreenProvider(this.homeUsecase);

  void selectRoomType(RoomType type) {
    selectedRoomType = type;
    len = type == RoomType.rooms ? 10 : 15;
    notifyListeners();

    // ถ้ามีวันที่เลือกไว้แล้ว ให้ filter ใหม่ตาม type ที่เปลี่ยน
    if (checkInDate != null && checkOutDate != null) {
      filterAvailableRooms();
    } else {
      getRoomdata();
    }
  }

  /// เรียกตอนเปิดหน้าครั้งแรก (ห้องทั้งหมด ยังไม่กรองวันที่)
  Future<List<HomeEntitise>> getRoomdata() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    try {
      roomData = await homeUsecase.getRooms();
      isLoading = false;
      notifyListeners();
      return roomData;
    } catch (e) {
      isLoading = false;
      errorMessage = 'error fetch roomdata: $e';
      notifyListeners();
      throw Exception(errorMessage);
    }
  }

  /// ตั้งวันที่แล้ว filter ห้องว่างทันที
  void setDateRange(DateTime checkIn, DateTime checkOut) {
    checkInDate = checkIn;
    checkOutDate = checkOut;
    notifyListeners();
    filterAvailableRooms();
  }

  /// ล้างวันที่ที่เลือก กลับไปแสดงห้องทั้งหมด
  void clearDateFilter() {
    checkInDate = null;
    checkOutDate = null;
    notifyListeners();
    getRoomdata();
  }

  Future<void> filterAvailableRooms() async {
    if (checkInDate == null || checkOutDate == null) return;

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

  String getName(int? id) {
    if (id == null) {
      return 'null';
    }
    if (id == 1) {
      return 'ก';
    } else if (id > 1) {
      return 'ข';
    } else {
      return 'ค';
    }
  }
}