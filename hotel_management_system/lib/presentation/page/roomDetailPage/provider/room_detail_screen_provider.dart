// room_detail_screen_provider.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/entitise/home_entitise.dart';
import 'package:hotel_management_system/domain/use_case/home_usecase.dart';

import '../../../../util/widget/core/typeRoom_enum.dart';

class RoomDetail {
  final String roomId;
  final RoomType roomType;
  final List<String> imageUrls;
  final String description;
  final double pricePerNight;

  RoomDetail({
    required this.roomId,
    required this.roomType,
    required this.imageUrls,
    required this.description,
    required this.pricePerNight,
  });
}

class RoomDetailScreenProvider extends ChangeNotifier {
  HomeUsecase homeUsecase;
  late List<HomeEntitise> roomData;

  RoomDetailScreenProvider(this.homeUsecase);

  // --- State ---
  RoomDetail? _roomDetail;
  bool _isLoading = false;
  String _errorMessage = '';

  // --- Getter ---
  RoomDetail? get roomDetail => _roomDetail;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> getRoomDetail(String roomId, RoomType roomType) async {
    _isLoading = true;
    notifyListeners();
    try {
      roomData = await homeUsecase.getRooms();
      final room = roomData.firstWhere(
        (item) => item.roomId == roomId && item.roomType == roomType.name,
      );

      _roomDetail = RoomDetail(
        roomId: room.roomId,
        roomType: roomType,
        imageUrls: room.imageUrls, // ใช้ตรง ๆ เลย ไม่ต้องแปลงซ้ำ
        description: room.description,
        pricePerNight: room
            .pricePerNight, // เป็น double อยู่แล้วจาก entity ไม่ต้อง .toDouble() ซ้ำ
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = 'ไม่สามารถโหลดข้อมูลห้องได้';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
