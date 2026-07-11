// housekeeper_room_check_screen_provider.dart
import 'package:flutter/material.dart';

import '../../../../data/data_source/remote_data_source/houseKeeper_remote.dart';
import '../../../../data/repositorise/houseKeeper_repositorise.dart';
import '../../../../domain/entitise/housekeeper_room_entity.dart';
import '../../../../domain/use_case/houseKeeper_usecase.dart';

class HousekeeperRoomCheckScreenProvider extends ChangeNotifier {
  // --- Dependency ---
  final HousekeeperRoomUseCase _useCase = HousekeeperRoomUseCase(
    repository: HousekeeperRoomRepositoryImpl(
      remoteDataSource: HousekeeperRoomRemoteDataSourceImpl(),
    ),
  );

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
      _allRooms = await _useCase.getRooms();
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
      return await _useCase.saveRoomDetail(
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