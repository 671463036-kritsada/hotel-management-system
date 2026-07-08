// check_in_screen_provider.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/entitise/check_in_entitise.dart';
import 'package:hotel_management_system/domain/use_case/check_in_usecase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';

enum CheckInStatus { initial, loading, success, error }

class CheckInScreenProvider extends ChangeNotifier {
  final CheckInUsecase usecase;
  CheckInScreenProvider(this.usecase);

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

  void clearSignature() {
    sigController.clear();
    notifyListeners();
  }

  /// เช็คว่าฟอร์มกรอกครบและเซ็นลายเซ็นแล้วหรือยัง ก่อนส่ง
  String? _validateForm() {
    if (idCardNumberController.text.trim().isEmpty) {
      return 'กรุณากรอกเลขบัตรประชาชน';
    }
    if (fullNameController.text.trim().isEmpty) {
      return 'กรุณากรอกชื่อ-นามสกุล';
    }
    if (addressController.text.trim().isEmpty) {
      return 'กรุณากรอกที่อยู่';
    }
    // if (_idCardImage == null) {
    //   return 'กรุณาถ่ายรูปบัตรประชาชน';
    // }
    if (sigController.isEmpty) {
      return 'กรุณาเซ็นลายเซ็นยืนยัน';
    }
    if (_paymentSlipImage == null) {
      return 'กรุณาแนบหลักฐานการโอนเงิน';
    }
    return null;
  }

  Future<void> submitCheckIn(int bookingId) async {
    final validationError = _validateForm();
    if (validationError != null) {
      _errorMessage = validationError;
      _status = CheckInStatus.error;
      notifyListeners();
      return;
    }

    _status = CheckInStatus.loading;
    notifyListeners();

    try {
      final signatureBytes = await sigController.toPngBytes();
      final String? signatureBase64 = signatureBytes != null
          ? base64Encode(signatureBytes)
          : null; // แปลงตรงนี้

      final checkInData = CheckInEntitise(
        bookingId: bookingId,
        idCardNumber: idCardNumberController.text.trim(),
        fullName: fullNameController.text.trim(),
        gender: _gender,
        address: addressController.text.trim(),
        idCardImage: _idCardImage?.path ?? '',
        paymentSlipImage: _paymentSlipImage?.path ?? '',
        signatureImage: signatureBase64, // ส่ง string เข้าไป
      );

      await usecase.getCheckInData(checkInData);

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
