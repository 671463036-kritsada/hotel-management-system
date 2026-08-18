// check_in_screen_provider.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_management_system/domain/entitise/check_in_entitise.dart';
import 'package:hotel_management_system/domain/use_case/check_in_usecase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

enum CheckInStatus { initial, loading, success, error }
enum SaveQRStatus { initial, success, error }

/// Mock model สำหรับคูปองส่วนลด
/// TODO: เมื่อมี API คูปองจริงจาก backend แล้ว ให้ลบ mockCoupons()
/// และดึงรายการคูปองผ่าน usecase แทน
class CouponModel {
  final String id;
  final String code;
  final String title;
  final double? discountPercent; // ส่วนลดแบบ % เช่น 10 = 10%
  final double? discountAmount; // ส่วนลดแบบจำนวนเงินคงที่

  const CouponModel({
    required this.id,
    required this.code,
    required this.title,
    this.discountPercent,
    this.discountAmount,
  });

  double calculateDiscount(double baseAmount) {
    if (discountPercent != null) {
      return baseAmount * (discountPercent! / 100);
    }
    if (discountAmount != null) {
      return discountAmount!;
    }
    return 0;
  }

  static List<CouponModel> mockCoupons() {
    return const [
      CouponModel(id: 'no_coupon', code: '-', title: 'ไม่ใช้คูปอง'),
      CouponModel(
        id: 'coupon_10',
        code: 'SAVE10',
        title: 'ส่วนลด 10%',
        discountPercent: 10,
      ),
      CouponModel(
        id: 'coupon_15',
        code: 'SAVE15',
        title: 'ส่วนลด 15%',
        discountPercent: 15,
      ),
      CouponModel(
        id: 'coupon_200',
        code: 'FLAT200',
        title: 'ส่วนลด 200 บาท',
        discountAmount: 200,
      ),
    ];
  }
}

class CheckInScreenProvider extends ChangeNotifier {
  final CheckInUsecase usecase;
  CheckInScreenProvider(this.usecase);

  // --- State ---
  CheckInStatus _status = CheckInStatus.initial;
  String _errorMessage = '';
  String _gender = "ชาย";
  File? _idCardImage;
  File? _paymentSlipImage;

  SaveQRStatus _saveQRStatus = SaveQRStatus.initial;
  String _saveQRErrorMessage = '';

  final TextEditingController idCardNumberController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final SignatureController sigController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );

  // --- Coupon & Price State ---
  // TODO: totalPrice / depositAmount ควรรับมาจากหน้ารายการจอง (BookingItem)
  // เรียก setPricing() ตอน initState ของหน้า UI เพื่อกำหนดค่าตั้งต้น
  double _totalPrice = 0;
  double _depositAmount = 0;
  final List<CouponModel> _coupons = CouponModel.mockCoupons();
  late CouponModel _selectedCoupon = _coupons.first;

  double get totalPrice => _totalPrice;
  double get depositAmount => _depositAmount;
  List<CouponModel> get coupons => _coupons;
  CouponModel get selectedCoupon => _selectedCoupon;

  /// ส่วนลดที่คำนวณจากคูปองที่เลือกอยู่
  double get discountAmount => _selectedCoupon.calculateDiscount(_totalPrice);

  /// ยอดที่ต้องชำระจริง = ราคาทั้งหมด - ค่าหมัดจำ - ส่วนลดคูปอง
  double get amountDue {
    final result = _totalPrice - _depositAmount - discountAmount;
    return result < 0 ? 0 : result;
  }

  /// เรียกใช้ตอนเปิดหน้า check-in เพื่อตั้งค่าราคาจากข้อมูลการจอง
  void setPricing({required double totalPrice, required double depositAmount}) {
    _totalPrice = totalPrice;
    _depositAmount = depositAmount;
    notifyListeners();
  }

  void selectCoupon(String couponId) {
    _selectedCoupon = _coupons.firstWhere(
      (c) => c.id == couponId,
      orElse: () => _coupons.first,
    );
    notifyListeners();
  }
  // --- End Coupon & Price State ---

  // --- Getter ---
  CheckInStatus get status => _status;
  String get errorMessage => _errorMessage;
  String get gender => _gender;
  File? get idCardImage => _idCardImage;
  File? get paymentSlipImage => _paymentSlipImage;
  bool get isLoading => _status == CheckInStatus.loading;

  SaveQRStatus get saveQRStatus => _saveQRStatus;
  String get saveQRErrorMessage => _saveQRErrorMessage;

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
    if (sigController.isEmpty) {
      return 'กรุณาเซ็นลายเซ็นยืนยัน';
    }
    if (_paymentSlipImage == null) {
      return 'กรุณาแนบหลักฐานการโอนเงิน';
    }
    return null;
  }

  Future<void> submitCheckIn(String bookingId) async {
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
      final String? signatureBase64 =
          signatureBytes != null ? base64Encode(signatureBytes) : null;

      final checkInData = CheckInEntitise(
        bookingId: bookingId,
        idCardNumber: idCardNumberController.text.trim(),
        fullName: fullNameController.text.trim(),
        gender: _gender,
        address: addressController.text.trim(),
        idCardImage: _idCardImage?.path ?? '',
        paymentSlipImage: _paymentSlipImage?.path ?? '',
        signatureImage: signatureBase64,
        // TODO: เพิ่ม field couponId / amountDue ใน CheckInEntitise
        // เมื่อ backend รองรับแล้ว เพื่อส่งข้อมูลคูปองและยอดที่ชำระจริงไปด้วย
        // couponId: _selectedCoupon.id,
        // amountDue: amountDue,
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

  Future<void> saveQRCode() async {
    try {
      ByteData byteData = await rootBundle.load("assets/images/QRcodePay.png");
      Uint8List bytes = byteData.buffer.asUint8List();
      final result = await ImageGallerySaver.saveImage(
        bytes,
        quality: 100,
        name: "Hotel_QR_Payment_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (result['isSuccess']) {
        _saveQRStatus = SaveQRStatus.success;
      } else {
        throw Exception("Save failed");
      }
    } catch (e) {
      _saveQRErrorMessage = "เกิดข้อผิดพลาด: $e";
      _saveQRStatus = SaveQRStatus.error;
    }
    notifyListeners();
  }

  void resetSaveQRStatus() {
    _saveQRStatus = SaveQRStatus.initial;
    _saveQRErrorMessage = '';
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