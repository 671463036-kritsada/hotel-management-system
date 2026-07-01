// login_screen.dart
import 'package:flutter/material.dart';
import 'loginScreen_desktopBody.dart';
import 'loginScreen_mobileBody.dart';
import '../../../responsiveLayout/responsive_layout.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: LoginScreenMobileBody(),
      desktopBody: LoginScreenDesktopBody(),
    );
  }
}
