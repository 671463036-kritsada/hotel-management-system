// room_condition_check_screen.dart
import 'package:flutter/material.dart';

import 'RoomConditionCheckPage_desktopBody.dart';
import 'RoomConditionCheckPage_mobileBody.dart';
import '../../../responsiveLayout/responsive_layout.dart';

class RoomConditionCheckScreen extends StatefulWidget {

  const RoomConditionCheckScreen({super.key});

  @override
  State<RoomConditionCheckScreen> createState() =>
      _RoomConditionCheckScreenState();
}

class _RoomConditionCheckScreenState extends State<RoomConditionCheckScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: RoomConditionCheckScreenMobileBody(roomId: 205),
      desktopBody: RoomConditionCheckScreenDesktopBody(),
    );
  }
}
