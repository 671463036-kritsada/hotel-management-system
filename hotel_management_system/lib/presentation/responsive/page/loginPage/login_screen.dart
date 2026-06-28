// login_screen.dart
import 'package:flutter/material.dart';
import '../../desktop_body/loginPageDesktop/loginScreen_desktopBody.dart';
import '../../mobile_body/loginPageMobile/loginScreen_mobileBody.dart';
import '../../responsive_layout.dart';

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
