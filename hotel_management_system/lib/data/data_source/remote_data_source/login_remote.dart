import 'package:dio/dio.dart';

import '../../model/login_model.dart';

abstract class LoginRemoteDataSource {
  Future<LoginModel> login({
    required String email,
    required String password,
  });
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final Dio dio;

  static const String _endpoint = "auth/login";

  LoginRemoteDataSourceImpl(this.dio);

  @override
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        _endpoint,
        data: {
          "email": email,
          "password": password,
        },
      );

      return LoginModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Login Failed",
      );
    }
  }
}