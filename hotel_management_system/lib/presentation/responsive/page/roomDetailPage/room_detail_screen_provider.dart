// room_detail_screen_provider.dart
import 'package:flutter/material.dart';
import '../../../core/typeRoom_enum.dart';

class RoomDetail {
  final int roomId;
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
  // --- State ---
  RoomDetail? _roomDetail;
  bool _isLoading = false;
  String _errorMessage = '';

  // --- Getter ---
  RoomDetail? get roomDetail => _roomDetail;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> getRoomDetail(int roomId, RoomType roomType, List<String> imageUrls) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: เชื่อม API จริงตรงนี้
      // _roomDetail = await _roomRepository.getRoomDetail(roomId);

      // Mock data
      await Future.delayed(const Duration(milliseconds: 300));
      _roomDetail = RoomDetail(
        roomId: roomId,
        roomType: roomType,
        imageUrls: imageUrls,
        description: 'สัมผัสประสบการณ์การพักผ่อนที่เหนือระดับ ด้วยห้องพักที่ตกแต่งอย่างทันสมัย พร้อมสิ่งอำนวยความสะดวกครบครัน อาทิ เครื่องปรับอากาศ Smart TV และฟรี Wi-Fi ความเร็วสูง',
        pricePerNight: roomId * 500,
      );
    } catch (e) {
      _errorMessage = 'ไม่สามารถโหลดข้อมูลห้องได้';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}