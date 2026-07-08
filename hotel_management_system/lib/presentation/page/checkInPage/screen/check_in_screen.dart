// check_in_screen.dart
import 'package:flutter/material.dart';
import 'check_in_desktopBody.dart';
import 'check_in_mobileBody.dart';
import '../../../responsiveLayout/responsive_layout.dart';

class CheckInScreen extends StatelessWidget {
  final int? bookingId;
  const CheckInScreen({super.key, this.bookingId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: CheckInScreenMobileBody(bookingID: bookingId,),
      desktopBody: CheckInScreenDesktopBody(bookingID: bookingId,),
    );
  }
}
