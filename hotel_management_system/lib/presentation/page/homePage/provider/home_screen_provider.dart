// home_screen_provider.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/entitise/home_entitise.dart';
import 'package:hotel_management_system/domain/use_case/home_usecase.dart';
import '../../../core/typeRoom_enum.dart';

class HomeScreenProvider extends ChangeNotifier {
  RoomType selectedRoomType = RoomType.rooms;
  int len = 10;

  HomeUsecase homeUsecase;
  List<HomeEntitise> roomData = [];

  String errorMessage = '';
  bool isLoading = false;

  HomeScreenProvider(this.homeUsecase);

  void selectRoomType(RoomType type) {
    selectedRoomType = type;
    len = type == RoomType.rooms ? 10 : 15;
    notifyListeners();
  }

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
