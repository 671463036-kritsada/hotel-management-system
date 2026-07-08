import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/entitise/booking_form_entitise.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hotel_management_system/domain/use_case/booking_form_usecase.dart';

enum BookingFormStatus { initial, loading, success, error }

class BookingFormScreenProvider extends ChangeNotifier {
  final BookingFormUsecase bookingFormUseCase;
  BookingFormScreenProvider(this.bookingFormUseCase);

  // --- State ---
  BookingFormStatus _status = BookingFormStatus.initial;
  String _errorMessage = '';
  File? _paymentSlipImage;

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
