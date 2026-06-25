// home_screen_provider.dart
import 'package:flutter/material.dart';
import '../core/typeRoom_enum.dart';

class HomeScreenProvider extends ChangeNotifier {
  RoomType selectedRoomType = RoomType.rooms;
  int len = 10;

  void selectRoomType(RoomType type) {
    selectedRoomType = type;
    len = type == RoomType.rooms ? 10 : 15;
    notifyListeners();
  }
}