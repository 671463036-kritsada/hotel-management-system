// home_screen.dart
import 'package:flutter/material.dart';
import '../../../../util/model/model.dart';
import 'homeScreen_desktopBody.dart';
import 'homeScreen_mobileBody.dart';
import '../../../responsiveLayout/responsive_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final HomeFilterArgs? filterArgs = args is HomeFilterArgs ? args : null;

    return ResponsiveLayout(
      mobileBody: HomeScreenMobileBody(filterArgs: filterArgs),
      desktopBody: HomeScreenDesktopBody(filterArgs: filterArgs),
    );
  }
}
