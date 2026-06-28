// home_screen.dart
import 'package:flutter/material.dart';
import '../../desktop_body/homePageDesktop/homeScreen_desktopBody.dart';
import '../../mobile_body/homePageMobile/homeScreen_mobileBody.dart';
import '../../responsive_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: HomeScreenMobileBody(),
      desktopBody: HomeScreenDesktopBody(),
    );
  }
}
