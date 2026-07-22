import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_management_system/domain/entitise/booking_form_entitise.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hotel_management_system/domain/use_case/booking_form_usecase.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

enum BookingFormStatus { initial, loading, success, error }
enum SaveQRStatus { initial, success, error }

class BookingFormScreenProvider extends ChangeNotifier {
  final BookingFormUsecase bookingFormUseCase;
  BookingFormScreenProvider(this.bookingFormUseCase);

  // --- State ---
  BookingFormStatus _status = BookingFormStatus.initial;
  String _errorMessage = '';
  File? _paymentSlipImage;

  SaveQRStatus _saveQRStatus = SaveQRStatus.initial;
  String _saveQRErrorMessage = ''; 

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController numberOfGuestsController =
      TextEditingController();
  final TextEditingController checkInController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();

  // --- Getter ---
  BookingFormStatus get status => _status;
  String get errorMessage => _errorMessage;
  File? get paymentSlipImage => _paymentSlipImage;
  bool get isLoading => _status == BookingFormStatus.loading;

  SaveQRStatus get saveQRStatus => _saveQRStatus;
  String get saveQRErrorMessage => _saveQRErrorMessage;

  // --- Functions ---
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

  Future<void> submitBooking({required int roomId}) async {
    _status = BookingFormStatus.loading;
    notifyListeners();
    try {
      final bookingFormData = BookingFormEntitise(
        roomId: roomId,
        fullName: fullNameController.text,
        email: emailController.text,
        bankAccount: bankController.text,
        phoneNumber: phoneController.text,
        numberOfGuests: int.tryParse(numberOfGuestsController.text) ?? 1,
        checkInDate:
            DateTime.tryParse(checkInController.text) ?? DateTime.now(),
        checkOutDate:
            DateTime.tryParse(checkOutController.text) ?? DateTime.now(),
        paymentSlip: _paymentSlipImage?.path ?? '',
      );
      final result = await bookingFormUseCase.bookingForm(bookingFormData);
      if (result) {
        _status = BookingFormStatus.success;
      } else {
        _errorMessage = 'กรุณากรอกข้อมูลให้ครบถ้วน';
        _status = BookingFormStatus.error;
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง';
      _status = BookingFormStatus.error;
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
    _status = BookingFormStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    bankController.dispose();
    phoneController.dispose();
    numberOfGuestsController.dispose();
    checkInController.dispose();
    checkOutController.dispose();
    super.dispose();
  }
}