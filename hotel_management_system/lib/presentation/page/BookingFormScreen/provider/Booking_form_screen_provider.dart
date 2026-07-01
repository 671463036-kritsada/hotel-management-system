// booking_form_screen_provider.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum BookingFormStatus { initial, loading, success, error }

class BookingFormScreenProvider extends ChangeNotifier {
  // --- State ---
  BookingFormStatus _status = BookingFormStatus.initial;
  String _errorMessage = '';
  File? _paymentSlipImage;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController numberOfGuestsController = TextEditingController();
  final TextEditingController checkInController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();

  // --- Getter ---
  BookingFormStatus get status => _status;
  String get errorMessage => _errorMessage;
  File? get paymentSlipImage => _paymentSlipImage;
  bool get isLoading => _status == BookingFormStatus.loading;

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

  Future<void> submitBooking(int roomId) async {
    _status = BookingFormStatus.loading;
    notifyListeners();

    try {
      // TODO: เชื่อม API จริง
      // await _bookingRepository.createBooking(
      //   roomId: roomId,
      //   fullName: fullNameController.text,
      //   email: emailController.text,
      //   bank: bankController.text,
      //   phone: phoneController.text,
      //   numberOfGuests: numberOfGuestsController.text,
      //   checkInDate: checkInController.text,
      //   checkOutDate: checkOutController.text,
      //   paymentSlip: _paymentSlipImage,
      // );

      // Mock success
      await Future.delayed(const Duration(milliseconds: 500));
      _status = BookingFormStatus.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง';
      _status = BookingFormStatus.error;
      notifyListeners();
    }
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