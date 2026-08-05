import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/page/splashPage/screen/splash_screen.dart';
import 'package:hotel_management_system/util/function/generate_routes.dart';
import 'package:hotel_management_system/util/provider/user_provider.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
// ควรใส่แค่ provider กลาง หมายความว่าทุกหน้าสามารถเข้าถึง provider หน้าอื่นได้
// มันควรจะเป็น provider กลางเท่านั้น ที่จะอยู่ main
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          home: SplashScreen(),
          theme: ThemeData(
            fontFamily: 'Prompt',
            useMaterial3: true,
          ),
          onGenerateRoute: onGenerateRoute),
    );
  }
}
