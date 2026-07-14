// housekeeper_room_check_screen_provider.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/use_case/houseKeeper_usecase.dart';
import '../../../../domain/entitise/housekeeper_room_entity.dart';

class HousekeeperRoomCheckScreenProvider extends ChangeNotifier {
  // --- Dependency ---

  HousekeeperRoomUseCase housekeeperRoomUseCase ;

  HousekeeperRoomCheckScreenProvider(this.housekeeperRoomUseCase);


  // --- State ---
  List<HousekeeperRoomEntity> _allRooms = [];
  List<HousekeeperRoomEntity> _filteredRooms = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // --- Getter ---
  List<HousekeeperRoomEntity> get filteredRooms => _filteredRooms;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> getRooms() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allRooms = await housekeeperRoomUseCase.getRooms();
      _filteredRooms = _allRooms;
    } catch (e) {
      _errorMessage = 'ไม่สามารถโหลดข้อมูลห้องได้';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterRooms(String query) {
    _filteredRooms = query.isEmpty
        ? _allRooms
        : _allRooms
            .where((room) => room.roomNo.contains(query))
            .toList();
    notifyListeners();
  }

  Future<bool> saveRoomDetail({
    required String roomNo,
    required String cleaningStatus,
  }) async {
    try {
      return await housekeeperRoomUseCase.saveRoomDetail(
        roomNo: roomNo,
        cleaningStatus: cleaningStatus,
      );
    } catch (e) {
      _errorMessage = 'ไม่สามารถบันทึกข้อมูลได้';
      notifyListeners();
      return false;
    }
  }
}