// room_condition_check_screen_provider.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/use_case/furniture_usecase.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../domain/entitise/furniture_entitise.dart';

class FurnitureItem {
  final String title;
  final dynamic image;
  String status;
  String note;
  bool isCustom;
  File? damageImage;

  FurnitureItem({
    required this.title,
    required this.image,
    this.status = "ปกติ",
    this.note = "",
    this.isCustom = false,
    this.damageImage,
  });
}

class RoomConditionCheckScreenProvider extends ChangeNotifier {
  final FurnitureUsecase usecase;
  RoomConditionCheckScreenProvider(this.usecase);

  // --- State ---
  List<FurnitureItem> _furnitureList = [];
  int _remainingSeconds = 3600;
  Timer? _timer;
  bool _isLoading = false;
  bool _disposed = false;
  bool _autoSubmitTriggered = false; // กันเรียก auto-submit ซ้ำเมื่อหมดเวลา
  String? _errorMessage;

  // --- Getter ---
  List<FurnitureItem> get furnitureList => _furnitureList;
  int get remainingSeconds => _remainingSeconds;
  bool get isTimeUp => _remainingSeconds <= 0;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get normalCount => _furnitureList.where((f) => f.status == "ปกติ").length;
  int get damagedCount =>
      _furnitureList.where((f) => f.status == "ชำรุด").length;

  // เช็คว่าควร trigger auto-submit หรือยัง (เรียกครั้งเดียวจาก UI แล้ว mark ว่า trigger ไปแล้ว)
  bool consumeAutoSubmitTrigger() {
    if (isTimeUp && !_autoSubmitTriggered) {
      _autoSubmitTriggered = true;
      return true;
    }
    return false;
  }

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  // --- Init ---
  void init(String roomID) {
    _loadFurnitureList(roomID);
    _startTimer();
  }

  Future<void> _loadFurnitureList(String roomID) async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotify();

    try {
      final entities = await usecase.getFurnitureData(roomID);

      _furnitureList = entities.map((entity) {
        return FurnitureItem(
          title: entity.title ?? "",
          image: entity.image ?? "",
          status: entity.status ?? "ปกติ",
        );
      }).toList();
    } catch (e) {
      _errorMessage = "ไม่สามารถโหลดข้อมูลเฟอร์นิเจอร์ได้ กรุณาลองใหม่อีกครั้ง";
      debugPrint("Load furniture error: $e");
    } finally {
      _isLoading = false;
      _safeNotify();
    }
  }

  // --- Timer ---
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _safeNotify();
      } else {
        _timer?.cancel();
        _safeNotify();
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
    _safeNotify();
  }

  void updateNote(int index, String note) {
    _furnitureList[index].note = note;
    _safeNotify();
  }

  Future<void> pickDamageImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      _furnitureList[index].damageImage = File(image.path);
      _safeNotify();
    }
  }

  Future<void> addExtraFurniture({
    required String title,
    File? damageImage,
  }) async {
    _furnitureList.add(FurnitureItem(
      title: title,
      image: null,
      status: "ชำรุด",
      isCustom: true,
      damageImage: damageImage,
    ));
    _safeNotify();
  }

  Future<void> submitCheckCondition(String roomID) async {
    _timer?.cancel();

    try {
      final reportData = _furnitureList.map((item) {
        return FurnitureEntitise(
          roomID: roomID,
          title: item.title,
          image: item.image is String ? item.image as String : null,
          status: item.status,
          note: item.note,
          isCustom: item.isCustom,
          damageImage: item.damageImage?.path,
        );
      }).toList();

      await usecase.submitReport(reportData);
    } catch (e) {
      debugPrint("Submit error: $e");
      rethrow;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}
