// list_screen.dart
import 'package:flutter/material.dart';
import '../../desktop_body/listPageDesktop/list_screen_desktopBody.dart';
import '../../mobile_body/listPageMobile/list_screen_mobileBody.dart';
import '../../responsive_layout.dart';


class ListScreen extends StatefulWidget {
  final bool? checkInStatus, ckeckOutStatus, statusConCheck;

  const ListScreen({
    super.key,
    this.checkInStatus,
    this.ckeckOutStatus = false,
    this.statusConCheck = false,
  });

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: ListScreenMobileBody(
        checkInStatus: widget.checkInStatus,
        ckeckOutStatus: widget.ckeckOutStatus,
        statusConCheck: widget.statusConCheck,
      ),
      desktopBody: ListScreenDesktopBody(
        checkInStatus: widget.checkInStatus,
        ckeckOutStatus: widget.ckeckOutStatus,
        statusConCheck: widget.statusConCheck,
      ),
    );
  }
}
