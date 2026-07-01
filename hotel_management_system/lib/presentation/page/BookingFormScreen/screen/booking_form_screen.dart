// booking_form_screen.dart
import 'package:flutter/material.dart';
import 'booking_form_screen_desktopBody.dart';
import 'booking_form_screen_mobileBody.dart';
import '../../../responsiveLayout/responsive_layout.dart';

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
