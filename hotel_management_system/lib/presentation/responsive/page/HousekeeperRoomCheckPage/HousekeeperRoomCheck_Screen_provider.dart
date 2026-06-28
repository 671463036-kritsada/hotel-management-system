// housekeeper_room_check_screen_provider.dart
import 'package:flutter/material.dart';

class RoomItem {
  final String roomNo;
  final String status;

  RoomItem({
    required this.roomNo,
    required this.status,
  });
}

class HousekeeperRoomCheckScreenProvider extends ChangeNotifier {
  // --- State ---
  List<RoomItem> _allRooms = [];
  List<RoomItem> _filteredRooms = [];
  bool _isLoading = false;

  // --- Getter ---
  List<RoomItem> get filteredRooms => _filteredRooms;
  bool get isLoading => _isLoading;

  Future<void> getRooms() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: เชื่อม API จริงตรงนี้
      // _allRooms = await _roomRepository.getRooms();

      // Mock data
      await Future.delayed(const Duration(milliseconds: 300));
      List<String> statuses = [
        "มีลูกค้าพักอยู่",
        "รอทำความสะอาด",
        "เสร็จสิ้น",
        "ปิดปรับปรุง"
      ];
      _allRooms = List.generate(50, (index) {
        int floor = (index ~/ 10) + 1;
        int roomNum = (index % 10) + 1;
        String roomNo = "$floor${roomNum.toString().padLeft(2, '0')}";
        return RoomItem(roomNo: roomNo, status: statuses[index % 4]);
      });

      _filteredRooms = _allRooms;
    } catch (e) {
      // TODO: handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterRooms(String query) {
    _filteredRooms = query.isEmpty
        ? _allRooms
        : _allRooms.where((room) => room.roomNo.contains(query)).toList();
    notifyListeners();
  }
}