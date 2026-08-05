import 'package:dio/dio.dart';

import '../../../../main.dart';
import '../storage/secure_storage_service.dart';


class AuthInterceptor extends Interceptor {


  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {


    final token =
        await SecureStorageService.instance.getToken();


    if(token != null && token.isNotEmpty){

      options.headers["Authorization"] =
          "Bearer $token";

    }


    handler.next(options);

  }



  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {


    print(
      "STATUS : ${err.response?.statusCode}"
    );


    print(
      "ERROR : ${err.response?.data}"
    );



    // Token หมดอายุ
    if(err.response?.statusCode == 401){


      print("TOKEN EXPIRED");



      // ลบ Token
      await SecureStorageService.instance.clear();



      // กลับหน้า Login
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(
              "/login",
              (route) => false,
          );


    }


    handler.next(err);

  }

}