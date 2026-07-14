// booking_form_screen.dart
import 'package:flutter/material.dart';
import '../../../responsiveLayout/responsive_layout.dart';
import 'booking_form_screen_route.dart';

class BookingFormScreen extends StatelessWidget {

  const BookingFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ต้องเขียนเช็ค null หรือ type ที่ต้องการหรือป่าว
    final int roomId = ModalRoute.of(context)!.settings.arguments as int ; 

    return ResponsiveLayout(
      mobileBody: BookingFormScreenMobileBody(roomId: roomId),
      desktopBody: BookingFormScreenDesktopBody(roomId: roomId),
    );
  }
}
