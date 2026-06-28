import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/responsive/page/BookingFormScreen/Booking_form_screen_provider.dart';
import 'package:hotel_management_system/presentation/responsive/page/HousekeeperRoomCheckPage/HousekeeperRoomCheck_Screen_provider.dart';
import 'package:hotel_management_system/presentation/responsive/page/RoomConditionCheckPage/room_condition_check_screen_provider.dart';
import 'package:hotel_management_system/presentation/responsive/page/checkInPage/check_in_screen_provider.dart';
import 'package:hotel_management_system/presentation/responsive/page/historyPage/histoty_screen_provider.dart';
import 'package:hotel_management_system/presentation/responsive/page/listPage/list_screen_provider/list_screen_provider.dart';
import 'package:hotel_management_system/presentation/responsive/page/loginPage/login_screen_provider.dart';
import 'package:hotel_management_system/presentation/responsive/page/registerPage/register_screen_provider.dart';
import 'package:hotel_management_system/presentation/responsive/page/roomDetailPage/room_detail_screen_provider.dart';
import 'package:hotel_management_system/presentation/splash_screen.dart';
import 'package:hotel_management_system/presentation/responsive/page/homePage/home_screen_provider.dart';
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
        ChangeNotifierProvider(create: (_) => LoginScreenProvider(  )),
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
