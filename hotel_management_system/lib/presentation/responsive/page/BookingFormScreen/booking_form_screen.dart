// booking_form_screen.dart
import 'package:flutter/material.dart';
import '../../desktop_body/bookingFormPageDesktop/booking_form_screen_desktopBody.dart';
import '../../mobile_body/bookingFormPageMobile/booking_form_screen_mobileBody.dart';
import '../../responsive_layout.dart';

class BookingFormScreen extends StatelessWidget {
  final int roomId;

  const BookingFormScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: BookingFormScreenMobileBody(roomId: roomId),
      desktopBody: BookingFormScreenDesktopBody(roomId: roomId),
    );
  }
}
