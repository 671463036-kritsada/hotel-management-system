// room_condition_check_screen_provider.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FurnitureItem {
  final String title;
  final dynamic image; // String (asset path) หรือ IconData
  String status;
  String note;
  File? damageImage;

  FurnitureItem({
    required this.title,
    required this.image,
    this.status = "ปกติ",
    this.note = "",
    this.damageImage,
  });
}

class RoomConditionCheckScreenProvider extends ChangeNotifier {
  // --- State ---
  List<FurnitureItem> _furnitureList = [];
  int _remainingSeconds = 3600;
  Timer? _timer;

  // --- Getter ---
  List<FurnitureItem> get furnitureList => _furnitureList;
  int get remainingSeconds => _remainingSeconds;
  bool get isTimeUp => _remainingSeconds <= 0;

  // --- Init ---
  void init() {
    _loadFurnitureList();
    _startTimer();
  }

  void _loadFurnitureList() {
    // TODO: เชื่อม API จริงตรงนี้
    // _furnitureList = await _roomRepository.getFurnitureList(roomId);

    // Mock data
    _furnitureList = [
      FurnitureItem(
        title: "เตียงนอน",
        image: "assets/images/furnitures/bed.jpg",
      ),
      FurnitureItem(
        title: "เครื่องปรับอากาศ",
        image: "assets/images/furnitures/airconditioner.jpg",
      ),
      FurnitureItem(
        title: "ตู้เย็น / มินิบาร์",
        image: "assets/images/furnitures/fridge.jpg",
      ),
      FurnitureItem(
        title: "ทีวี และ รีโมท",
        image: "assets/images/furnitures/TV.jpg",
      ),
    ];
    notifyListeners();
  }

  // --- Timer ---
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
        notifyListeners(); // แจ้ง UI ว่าหมดเวลา
      }
    });
  }

  String formatTime(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;
    return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  // --- Functions ---
  void updateStatus(int index, String status) {
    _furnitureList[index].status = status;
    notifyListeners();
  }

  void updateNote(int index, String note) {
    _furnitureList[index].note = note;
  }

  Future<void> pickDamageImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      _furnitureList[index].damageImage = File(image.path);
      notifyListeners();
    }
  }

  Future<void> addExtraFurniture({
    required String title,
    File? damageImage,
  }) async {
    _furnitureList.add(FurnitureItem(
      title: title,
      image: Icons.warning_amber_rounded,
      status: "ชำรุด",
      damageImage: damageImage,
    ));
    notifyListeners();
  }

  Future<void> submitCheckCondition() async {
    _timer?.cancel();

    try {
      // TODO: เชื่อม API จริงตรงนี้
      // await _roomRepository.submitConditionCheck(
      //   furnitureList: _furnitureList,
      // );

      // Mock success
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      // TODO: handle error
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}