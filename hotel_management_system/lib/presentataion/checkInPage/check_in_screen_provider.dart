// check_in_screen_provider.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';

enum CheckInStatus { initial, loading, success, error }

class CheckInScreenProvider extends ChangeNotifier {
  // --- State ---
  CheckInStatus _status = CheckInStatus.initial;
  String _errorMessage = '';
  String _gender = "ชาย";
  File? _idCardImage;
  File? _paymentSlipImage;

  final TextEditingController idCardNumberController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final SignatureController sigController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );

  // --- Getter ---
  CheckInStatus get status => _status;
  String get errorMessage => _errorMessage;
  String get gender => _gender;
  File? get idCardImage => _idCardImage;
  File? get paymentSlipImage => _paymentSlipImage;
  bool get isLoading => _status == CheckInStatus.loading;

  // --- Functions ---
  void setGender(String value) {
    _gender = value;
    notifyListeners();
  }

  Future<void> takeIdCardPhoto() async {
    var status = await Permission.camera.request();

    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        _idCardImage = File(photo.path);
        notifyListeners();
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> pickSlipImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      _paymentSlipImage = File(image.path);
      notifyListeners();
    }
  }

  Future<void> submitCheckIn() async {
    _status = CheckInStatus.loading;
    notifyListeners();

    try {
      // TODO: เชื่อม API จริงตรงนี้
      // await _checkInRepository.submitCheckIn(
      //   idCardNumber: idCardNumberController.text,
      //   fullName: fullNameController.text,
      //   gender: _gender,
      //   address: addressController.text,
      //   idCardImage: _idCardImage,
      //   paymentSlip: _paymentSlipImage,
      //   signature: await sigController.toPngBytes(),
      // );

      // Mock success
      await Future.delayed(const Duration(milliseconds: 500));
      _status = CheckInStatus.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง';
      _status = CheckInStatus.error;
      notifyListeners();
    }
  }

  void resetStatus() {
    _status = CheckInStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    idCardNumberController.dispose();
    fullNameController.dispose();
    addressController.dispose();
    sigController.dispose();
    super.dispose();
  }
}