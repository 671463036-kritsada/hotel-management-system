// register_screen_provider.dart
import 'package:flutter/material.dart';

enum RegisterStatus { initial, loading, success, error }

class RegisterScreenProvider extends ChangeNotifier {
  // --- State ---
  RegisterStatus _status = RegisterStatus.initial;
  String _errorMessage = '';
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // --- Getter ---
  RegisterStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool get isLoading => _status == RegisterStatus.loading;

  // --- Functions ---
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  bool _validate() {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _errorMessage = 'กรุณากรอกข้อมูลให้ครบ';
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      _errorMessage = 'รหัสผ่านไม่ตรงกัน';
      return false;
    }
    return true;
  }

  Future<void> register() async {
    if (!_validate()) {
      _status = RegisterStatus.error;
      notifyListeners();
      return;
    }
    _status = RegisterStatus.loading;
    notifyListeners();
    try {
      // TODO: เชื่อม API จริงตรงนี้
      await Future.delayed(const Duration(seconds: 1));
      _status = RegisterStatus.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'สมัครสมาชิกไม่สำเร็จ กรุณาลองใหม่อีกครั้ง';
      _status = RegisterStatus.error;
      notifyListeners();
    }
  }

  /// เช็คสถานะ register แล้วจัดการผลลัพธ์
  /// [onSuccess] คือ dialog ที่แต่ละแพลตฟอร์ม (mobile/desktop) กำหนดเอง
  void handleRegisterResult(BuildContext context, VoidCallback onSuccess) {
    if (_status == RegisterStatus.success) {
      onSuccess();
      resetStatus();
    } else if (_status == RegisterStatus.error) {
      if (!context.mounted) return; // กัน context ตายหลัง async
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage), backgroundColor: Colors.red),
      );
      resetStatus();
    }
  }

  void resetStatus() {
    _status = RegisterStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}