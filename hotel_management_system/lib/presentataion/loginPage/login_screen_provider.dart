// login_screen_provider.dart
import 'package:flutter/material.dart';

enum LoginStatus { initial, loading, success, error }

class LoginScreenProvider extends ChangeNotifier {
  // --- State ---
  LoginStatus _status = LoginStatus.initial;
  String _errorMessage = '';

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
    // TODO: validate ก่อน
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
      // final result = await _authRepository.login(
      //   username: usernameController.text,
      //   password: passwordController.text,
      // );

      // Mock success
      await Future.delayed(const Duration(seconds: 1));

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