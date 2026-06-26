import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/BookingFormScreen/Booking_form_screen_provider.dart';
import 'package:hotel_management_system/presentation/HousekeeperRoomCheckPage/HousekeeperRoomCheck_Screen_provider.dart';
import 'package:hotel_management_system/presentation/RoomConditionCheckPage/room_condition_check_screen_provider.dart';
import 'package:hotel_management_system/presentation/checkInPage/check_in_screen_provider.dart';
import 'package:hotel_management_system/presentation/historyPage/histoty_screen_provider.dart';
import 'package:hotel_management_system/presentation/listPage/list_screen_provider/list_screen_provider.dart';
import 'package:hotel_management_system/presentation/loginPage/login_screen_provider.dart';
import 'package:hotel_management_system/presentation/registerPage/register_screen_provider.dart';
import 'package:hotel_management_system/presentation/roomDetailPage/room_detail_screen_provider.dart';
import 'package:hotel_management_system/presentation/splash_screen.dart';
import 'package:hotel_management_system/presentation/homePage/home_screen_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (_) => LoginScreenProvider()),
        ChangeNotifierProvider(create: (_) => RegisterScreenProvider()),
        ChangeNotifierProvider(
            create: (_) => HousekeeperRoomCheckScreenProvider()),
        ChangeNotifierProvider(create: (_) => RoomDetailScreenProvider()),
        ChangeNotifierProvider(create: (_) => HistoryScreenProvider()),
        ChangeNotifierProvider(create: (_) => ListScreenProvider()),
        ChangeNotifierProvider(create: (_) => CheckInScreenProvider()),
        ChangeNotifierProvider(create: (_) => BookingFormScreenProvider()),
        ChangeNotifierProvider(
            create: (_) => RoomConditionCheckScreenProvider()),
        // เพิ่ม Provider อื่นๆ ตรงนี้ในอนาคต
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        theme: ThemeData(
          fontFamily: 'Prompt',
          useMaterial3: true,
        ),
      ),
    );
  }
}
