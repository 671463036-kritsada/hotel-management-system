import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/page/page_route.dart';

import 'package:hotel_management_system/util/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../../data/data_source/remote_data_source/booking_form_remote.dart';
import '../../data/repositorise/booking_form_repositorise.dart';
import '../../domain/use_case/booking_form_usecase.dart';

RouteFactory onGenerateRoute = (settings) {
  switch (settings.name) {
    case "/login":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) =>
                    LoginScreenProvider(context.read<UserProvider>()),
                child: const LoginScreen(),
              ));
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
    default:
      null;
  }
};
