// login_screen_provider.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hotel_management_system/util/provider/user_provider.dart';

enum LoginStatus { initial, loading, success, error }

class LoginScreenProvider extends ChangeNotifier {
  LoginScreenProvider(this.userProvider);

  // --- State ---
  LoginStatus _status = LoginStatus.initial;
  String _errorMessage = '';
  final UserProvider userProvider;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  // --- Getter ---
  LoginStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _status == LoginStatus.loading;

  // --- Functions ---
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      _errorMessage = 'กรุณากรอกข้อมูลให้ครบ';
      _status = LoginStatus.error;
      notifyListeners();
      return;
    }
    _status = LoginStatus.loading;
    notifyListeners();
    try {
      // TODO: เชื่อม API จริงตรงนี้
      await Future.delayed(const Duration(seconds: 1));
      userProvider.usernamePassword = (
        username: usernameController.text,
        password: passwordController.text
      );
      log("username ${userProvider.username ?? ''} ");
      _status = LoginStatus.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง';
      _status = LoginStatus.error;
      notifyListeners();
    }
  }

  void loginWithGoogle() async {
    // TODO: เชื่อม Google Auth
  }

  void loginWithFacebook() async {
    // TODO: เชื่อม Facebook Auth
  }

  /// เช็คสถานะ login แล้วจัดการผลลัพธ์
  /// onSucess คือ dialog ที่แต่ละแพลตฟอร์ม (mobile/desktop) กำหนดเอง
  void handleLoginResult(BuildContext context, VoidCallback onSuccess) {
    if (_status == LoginStatus.success) {
      onSuccess();
      resetStatus();
    } else if (_status == LoginStatus.error) {
      if (!context.mounted) return; // กัน context ตายหลัง async
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage), backgroundColor: Colors.red),
      );
      resetStatus();
    }
  }

  void resetStatus() {
    _status = LoginStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}