// list_screen.dart
import 'package:flutter/material.dart';
import 'list_screen_desktopBody.dart';
import 'list_screen_mobileBody.dart';
import '../../../responsiveLayout/responsive_layout.dart';
import '../../../../util/model/model.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as ListScreenArguments?;

    return ResponsiveLayout(
      mobileBody: ListScreenMobileBody(
        checkInStatus: args?.checkInStatus,
        ckeckOutStatus: args?.ckeckOutStatus,
        statusConCheck: args?.statusConCheck,
      ),
      desktopBody: ListScreenDesktopBody(
        checkInStatus: args?.checkInStatus,
        ckeckOutStatus: args?.ckeckOutStatus,
        statusConCheck: args?.statusConCheck,
      ),
    );
  }
}