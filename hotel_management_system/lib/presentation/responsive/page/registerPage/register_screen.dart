// register_screen.dart
import 'package:flutter/material.dart';
import '../../desktop_body/registerPageDesktop/registerScreen_desktopBody.dart';
import '../../mobile_body/registerPageMobile/registerScreen_mobileBody.dart';
import '../../responsive_layout.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: RegisterScreenMobileBody(),
      desktopBody: RegisterScreenDesktopBody(),
    );
  }
}
