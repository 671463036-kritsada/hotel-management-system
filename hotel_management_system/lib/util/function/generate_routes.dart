import 'package:flutter/material.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/furniture_remote.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/home_remote.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/houseKeeper_remote.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/list_remote.dart';
import 'package:hotel_management_system/data/repositorise/furniture_repositorise.dart';
import 'package:hotel_management_system/data/repositorise/home_repositorise.dart';
import 'package:hotel_management_system/data/repositorise/houseKeeper_repositorise.dart';
import 'package:hotel_management_system/data/repositorise/list_repositorise.dart';
import 'package:hotel_management_system/domain/use_case/furniture_usecase.dart';
import 'package:hotel_management_system/domain/use_case/history_usecase.dart';
import 'package:hotel_management_system/domain/use_case/home_usecase.dart';
import 'package:hotel_management_system/domain/use_case/list_usecase.dart';
import 'package:hotel_management_system/presentation/page/HousekeeperRoomCheckPage/provider/HousekeeperRoomCheck_Screen_provider.dart';
import 'package:hotel_management_system/presentation/page/HousekeeperRoomCheckPage/screen/HousekeeperRoomCheck_Screen.dart';
import 'package:hotel_management_system/presentation/page/RoomConditionCheckPage/provider/room_condition_check_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/RoomConditionCheckPage/screen/room_condition_check_screen.dart';
import 'package:hotel_management_system/presentation/page/historyPage/provider/histoty_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/homePage/provider/home_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/listPage/provider/list_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/listPage/screen/list_screen.dart';
import 'package:hotel_management_system/presentation/page/page_route.dart';
import 'package:hotel_management_system/presentation/page/registerPage/provider/register_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/registerPage/screen/register_screen.dart';
import 'package:hotel_management_system/presentation/page/roomDetailPage/provider/room_detail_screen_provider.dart';

import 'package:hotel_management_system/util/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../../data/data_source/remote_data_source/booking_form_remote.dart';
import '../../data/data_source/remote_data_source/history_remote.dart';
import '../../data/repositorise/booking_form_repositorise.dart';
import '../../data/repositorise/history_repository.dart';
import '../../domain/use_case/booking_form_usecase.dart';
import '../../domain/use_case/houseKeeper_usecase.dart';
import '../../presentation/page/historyPage/screen/history_screen.dart';
import '../../presentation/page/homePage/screen/home_screen.dart';
import '../../presentation/page/roomDetailPage/screen/room_detail_screen.dart';

import 'package:dio/dio.dart';

//  Dio instance กลาง
final Dio _dio = Dio(
  BaseOptions(
    baseUrl: 'http://localhost:2000/api/',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
  ),
)..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));


RouteFactory onGenerateRoute = (settings) {
  switch (settings.name) {
    case "/login":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) =>
                    LoginScreenProvider(context.read<UserProvider>()),
                child: const LoginScreen(),
              ));
    case "/register":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) => RegisterScreenProvider(),
                child: const RegisterScreen(),
              ),
          settings: settings);
    case "/home":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) => HomeScreenProvider(HomeUsecase(
                    HomeRepositoryImpl(HomeRemoteDataSourceImpl(_dio)))),
                child: const HomeScreen(),
              ));
    case '/room_detail':
      return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => RoomDetailScreenProvider(
              HomeUsecase(HomeRepositoryImpl(HomeRemoteDataSourceImpl(_dio)))),
          child: RoomDetailScreen(),
        ),
        settings: settings,
      );
    case "/booking_form":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) => BookingFormScreenProvider(BookingFormUsecase(
                    BookingFormRepositoriseImpl(
                        BookingFormRemoteDataSourceImpl()))),
                child: const BookingFormScreen(),
              ),
          // ส่ง agument ถ้ามีหลาย aguments เราจะทำ Map แล้วส่งมา เอา Map ไปทำเป็น model ก็ได้
          settings: settings);
    case "/room_condition_check":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) => RoomConditionCheckScreenProvider(
                    FurnitureUsecase(FurnitureRepositoriseImpl(
                        furnitureRemoteDataSourceImpl()))),
                child: RoomConditionCheckScreen(),
              ),
          settings: settings);
    case "/history":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) => HistoryScreenProvider(BookingHistoryUseCase(
                    repository: BookingHistoryRepositoryImpl(
                        remoteDataSource:
                            BookingHistoryRemoteDataSourceImpl()))),
                child: const HistoryScreen(),
              ),
          settings: settings);
    case "/housekeeper":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) => HousekeeperRoomCheckScreenProvider(
                    HousekeeperRoomUseCase(
                        repository: HousekeeperRoomRepositoryImpl(
                            remoteDataSource:
                                HousekeeperRoomRemoteDataSourceImpl()))),
                child: const HousekeeperRoomCheckScreen(),
              ),
          settings: settings);
    case "/list_page":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) => ListScreenProvider(ListUsecase(
                    ListRepositoriseImpl(ListRemoteDatasourceImpl(_dio)))),
                child: const ListScreen(),
              ),
          settings: settings);
    default:
      return null;
  }
};
