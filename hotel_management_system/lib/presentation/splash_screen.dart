import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/responsive/desktop_body/splashPageDesktop/splashScreen_desktopBody.dart';
import 'package:hotel_management_system/presentation/responsive/mobile_body/splashPageMobile/splashScreen_mobileBody.dart';
import 'package:hotel_management_system/presentation/responsive/responsive_layout.dart';

import 'responsive/page/loginPage/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void onTopToLoginPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: SplashScreenMobileBody(),
      desktopBody: SplashScreenDesktopBody(),
    );
  }
}
