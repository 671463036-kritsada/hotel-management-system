import 'package:flutter/material.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/home_remote.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/list_remote.dart';
import 'package:hotel_management_system/data/repositorise/home_repositorise.dart';
import 'package:hotel_management_system/data/repositorise/list_repositorise.dart';
import 'package:hotel_management_system/domain/use_case/home_usecase.dart';
import 'package:hotel_management_system/domain/use_case/list_usecase.dart';

import 'package:hotel_management_system/presentation/page/HousekeeperRoomCheckPage/provider/HousekeeperRoomCheck_Screen_provider.dart';

import 'package:hotel_management_system/presentation/page/historyPage/provider/histoty_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/listPage/provider/list_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/registerPage/provider/register_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/roomDetailPage/provider/room_detail_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/splashPage/screen/splash_screen.dart';
import 'package:hotel_management_system/presentation/page/homePage/provider/home_screen_provider.dart';
import 'package:hotel_management_system/util/function/generate_routes.dart';
import 'package:hotel_management_system/util/provider/user_provider.dart';
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

    final listUsecase =
        ListUsecase(ListRepositoriseImpl(ListRemoteDatasourceImpl()));

// ควรใส่แค่ provider กลาง หมายความว่าทุกหน้าสามารถเข้าถึง provider หน้าอื่นได้
// มันควรจะเป็น provider กลางเท่านั้น ที่จะอยู่ main
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => HomeScreenProvider(homeUsecase, [])),

        ChangeNotifierProvider(create: (_) => RegisterScreenProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),

        ChangeNotifierProvider(
            create: (_) => HousekeeperRoomCheckScreenProvider()),

        ChangeNotifierProvider(
            create: (_) => RoomDetailScreenProvider(homeUsecase, [])),

        ChangeNotifierProvider(create: (_) => HistoryScreenProvider()),

        ChangeNotifierProvider(create: (_) => ListScreenProvider(listUsecase)),
        // เพิ่ม Provider อื่นๆ ตรงนี้ในอนาคต
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        theme: ThemeData(
          fontFamily: 'Prompt',
          useMaterial3: true,
        ),
        onGenerateRoute: onGenerateRoute
      ),
    );
  }
}
