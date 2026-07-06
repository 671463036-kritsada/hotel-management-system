import 'package:flutter/material.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/home_remote.dart';
import 'package:hotel_management_system/data/repositorise/home_repositorise.dart';
import 'package:hotel_management_system/domain/use_case/home_usecase.dart';
import 'package:hotel_management_system/presentation/page/BookingFormScreen/provider/Booking_form_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/HousekeeperRoomCheckPage/provider/HousekeeperRoomCheck_Screen_provider.dart';
import 'package:hotel_management_system/presentation/page/RoomConditionCheckPage/provider/room_condition_check_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/checkInPage/provider/check_in_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/historyPage/provider/histoty_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/listPage/provider/list_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/loginPage/provider/login_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/registerPage/provider/register_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/roomDetailPage/provider/room_detail_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/splashPage/screen/splash_screen.dart';
import 'package:hotel_management_system/presentation/page/homePage/provider/home_screen_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final homeUsecase = HomeUsecase(
      HomeRepositoryImpl(HomeRemoteDataSourceImpl()),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => HomeScreenProvider(homeUsecase, [])),


        ChangeNotifierProvider(create: (_) => LoginScreenProvider()),


        ChangeNotifierProvider(create: (_) => RegisterScreenProvider()),

        ChangeNotifierProvider(
            create: (_) => HousekeeperRoomCheckScreenProvider()),

        ChangeNotifierProvider(
            create: (_) => RoomDetailScreenProvider(homeUsecase, [])),


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
