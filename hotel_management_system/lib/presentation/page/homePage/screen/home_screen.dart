// home_screen.dart
import 'package:flutter/material.dart';
import 'homeScreen_desktopBody.dart';
import 'homeScreen_mobileBody.dart';
import '../../../responsiveLayout/responsive_layout.dart';

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
