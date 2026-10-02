// home_screen_provider.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/entitise/home_entitise.dart';
import 'package:hotel_management_system/domain/use_case/home_usecase.dart';
import '../../../../util/widget/core/typeRoom_enum.dart';

enum PriceSortOrder {
  none,
  lowToHigh,
  highToLow,
}

class HomeScreenProvider extends ChangeNotifier {
  RoomType selectedRoomType = RoomType.rooms;
  int len = 10;
  HomeUsecase homeUsecase;
  List<HomeEntitise> roomData = [];
  String errorMessage = '';
  bool isLoading = false;

  // --- state สำหรับ filter ชื่อ/ประเภทย่อย และ การเรียงราคา ---
  String selectedNameFilter = 'ทั้งหมด';
  PriceSortOrder priceSortOrder = PriceSortOrder.none;

  // --- state สำหรับ filter วันที่ (nullable: ยังไม่เลือกวันที่ = ยังไม่มีข้อมูล) ---
  DateTime? checkInDate;
  DateTime? checkOutDate;

  HomeScreenProvider(this.homeUsecase);

  bool get hasDateFilter => checkInDate != null && checkOutDate != null;

  /// ดึงรายชื่อประเภทห้อง/บ้านที่มีอยู่จริงใน roomData สำหรับทำ Filter Chips
  List<String> get availableNames {
    final names = <String>{};
    for (final room in roomData) {
      if (room.name.trim().isNotEmpty) {
        names.add(room.name.trim());
      }
    }
    return ['ทั้งหมด', ...names];
  }

  /// กรองตามประเภทห้อง (name) และเรียงลำดับตามราคา (price)
  List<HomeEntitise> get filteredRoomData {
    var result = List<HomeEntitise>.from(roomData);

    // 1. กรองตามชื่อประเภทห้อง
    if (selectedNameFilter != 'ทั้งหมด') {
      result = result
          .where((room) => room.name.trim() == selectedNameFilter)
          .toList();
    }

    // 2. เรียงตามราคา
    if (priceSortOrder == PriceSortOrder.lowToHigh) {
      result.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
    } else if (priceSortOrder == PriceSortOrder.highToLow) {
      result.sort((a, b) => b.pricePerNight.compareTo(a.pricePerNight));
    }

    return result;
  }

  void selectNameFilter(String name) {
    selectedNameFilter = name;
    notifyListeners();
  }

  void togglePriceSort() {
    if (priceSortOrder == PriceSortOrder.none) {
      priceSortOrder = PriceSortOrder.lowToHigh;
    } else if (priceSortOrder == PriceSortOrder.lowToHigh) {
      priceSortOrder = PriceSortOrder.highToLow;
    } else {
      priceSortOrder = PriceSortOrder.none;
    }
    notifyListeners();
  }

  void selectRoomType(RoomType type) {
    selectedRoomType = type;
    len = type == RoomType.rooms ? 10 : 15;
    selectedNameFilter = 'ทั้งหมด';
    notifyListeners();

    // กรองใหม่เฉพาะตอนมีวันที่แล้วเท่านั้น เพราะไม่มี "ดึงห้องทั้งหมด" ให้ fallback
    if (hasDateFilter) {
      filterAvailableRooms();
    }
  }

  /// ตั้งวันที่แล้ว filter ห้องว่างทันที
  void setDateRange(DateTime checkIn, DateTime checkOut) {
    checkInDate = checkIn;
    checkOutDate = checkOut;
    selectedNameFilter = 'ทั้งหมด';
    notifyListeners();
    filterAvailableRooms();
  }

  /// ล้างวันที่ที่เลือก - ไม่มีวันที่แล้ว = ไม่มีข้อมูลห้องให้แสดง (เพราะกรองอย่างเดียว ไม่มี "ห้องทั้งหมด")
  void clearDateFilter() {
    checkInDate = null;
    checkOutDate = null;
    roomData = [];
    selectedNameFilter = 'ทั้งหมด';
    priceSortOrder = PriceSortOrder.none;
    errorMessage = '';
    notifyListeners();
  }

  Future<void> filterAvailableRooms() async {
    if (!hasDateFilter || isLoading) return;

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

  Future<bool?> refreshAndCheckRoom(String roomId) async {
    if (!hasDateFilter || isLoading) return null;
    await filterAvailableRooms();
    if (errorMessage.isNotEmpty) return null;
    return roomData.any((room) => room.roomId == roomId);
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
